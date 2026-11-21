#!/usr/bin/env python3
"""Check that the mock JSON files agree with each other. Standard library only.

Run from the repo root or from mock/:

    python3 mock/validate.py
"""

from __future__ import annotations

import json
import sys
from datetime import datetime, timedelta
from pathlib import Path

ROOT = Path(__file__).resolve().parent

LANGS = [
    ("hi", "Hindi"),
    ("en", "English"),
    ("bn", "Bengali"),
    ("ta", "Tamil"),
    ("te", "Telugu"),
    ("mr", "Marathi"),
    ("kn", "Kannada"),
]

# Tier B is the specified rate. A and C are the mock display ladder.
TIER_RATES = {"A": (60, 30), "B": (40, 20), "C": (20, 10)}

# U13/U14 fields. They are on Priya only; other hosts do not show them.
PRIYA_FIELDS = {"bio", "verified", "freeCall", "topGift", "gallery"}

LEDGER_TYPES = {"recharge", "call", "gift", "message", "vip", "bonus", "refund"}
POSITIVE_TYPES = {"recharge", "bonus", "refund"}
NEGATIVE_TYPES = {"call", "gift", "message", "vip"}
REF_KEYS = {"hostId", "userId", "refId", "callId", "giftId"}
CALL_STATUSES = {"completed", "missed", "dropped", "refunded"}
GIFT_CATEGORIES = {"popular", "interactive", "luxury", "event"}

errors: list[str] = []


def fail(message: str) -> None:
    errors.append(message)


def load(name: str):
    path = ROOT / name
    try:
        with path.open(encoding="utf-8") as handle:
            return json.load(handle)
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"{name}: {exc}")
        return None


def is_int(value) -> bool:
    return isinstance(value, int) and not isinstance(value, bool)


def parse_time(value, label: str):
    if not isinstance(value, str) or not value.endswith("Z"):
        fail(f"{label}: expected a UTC timestamp ending in Z")
        return None
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        fail(f"{label}: bad timestamp {value!r}")
        return None


def require_keys(
    obj,
    keys: set[str],
    label: str,
    optional: set[str] | None = None,
) -> None:
    if not isinstance(obj, dict):
        fail(f"{label}: expected an object")
        return
    actual = set(obj)
    allowed = set(keys)
    if optional:
        allowed |= optional
    missing = keys - actual
    extra = actual - allowed
    if missing:
        fail(f"{label}: missing {sorted(missing)}")
    if extra:
        fail(f"{label}: unexpected {sorted(extra)}")


def register(index: dict[str, str], value, source: str) -> None:
    if not isinstance(value, str) or not value:
        fail(f"{source}: id must be a non-empty string")
        return
    if value in index:
        fail(f"duplicate id {value!r} ({source} and {index[value]})")
    else:
        index[value] = source


def walk_refs(node, index: dict[str, str], path: str) -> None:
    if isinstance(node, dict):
        for key, value in node.items():
            child = f"{path}.{key}"
            if key in REF_KEYS:
                if not isinstance(value, str) or value not in index:
                    fail(f"{child}: {value!r} does not resolve")
            else:
                walk_refs(value, index, child)
    elif isinstance(node, list):
        for i, item in enumerate(node):
            walk_refs(item, index, f"{path}[{i}]")


def walk_languages(node, codes: set[str], path: str) -> None:
    if isinstance(node, dict):
        for key, value in node.items():
            child = f"{path}.{key}"
            if key == "languages":
                if not isinstance(value, list) or not value:
                    fail(f"{child}: expected a non-empty list of language codes")
                    continue
                for code in value:
                    if code not in codes:
                        fail(f"{child}: unknown language code {code!r}")
            else:
                walk_languages(value, codes, child)
    elif isinstance(node, list):
        for i, item in enumerate(node):
            walk_languages(item, codes, f"{path}[{i}]")


def walk_single_profile(node, path: str) -> None:
    """Level, VIP, and balance live only on user_profile.json."""
    banned = {"level", "vip", "diamondBalance", "levelProgress", "username"}
    if isinstance(node, dict):
        for key, value in node.items():
            if key in banned:
                fail(f"{path}.{key}: duplicates the canonical user profile")
            else:
                walk_single_profile(value, f"{path}.{key}")
    elif isinstance(node, list):
        for i, item in enumerate(node):
            walk_single_profile(item, f"{path}[{i}]")


def check_languages(languages) -> set[str]:
    if not isinstance(languages, list):
        fail("languages.json: expected a list")
        return set()
    rows = []
    for i, row in enumerate(languages):
        require_keys(row, {"code", "name"}, f"languages[{i}]")
        if isinstance(row, dict):
            rows.append((row.get("code"), row.get("name")))
    if rows != LANGS:
        fail(f"languages.json: expected {LANGS}, found {rows}")
    return {code for code, _ in LANGS}


def check_user(user, levels) -> None:
    require_keys(
        user,
        {
            "id",
            "username",
            "avatar",
            "languages",
            "level",
            "levelProgress",
            "vip",
            "diamondBalance",
            "followsCount",
            "freeMatchesLeft",
            "freeMatchesTotal",
            "freeMessages",
        },
        "user_profile",
    )
    if not isinstance(user, dict):
        return
    require_keys(
        user.get("levelProgress"),
        {"current", "required", "nextLevel", "percent"},
        "user_profile.levelProgress",
    )
    require_keys(user.get("vip"), {"active"}, "user_profile.vip")
    require_keys(
        user.get("freeMessages"),
        {"left", "priceAfter"},
        "user_profile.freeMessages",
    )
    if user.get("id") != "user_rahul" or user.get("username") != "Rahul_K":
        fail("user_profile: canonical user must be user_rahul / Rahul_K")
    if user.get("level") != 2:
        fail("user_profile: level must be 2")
    if user.get("vip") != {"active": False}:
        fail("user_profile: vip must be {active: false}")
    if user.get("diamondBalance") != 120:
        fail("user_profile: diamondBalance must be 120")
    if user.get("freeMatchesLeft") != 2 or user.get("freeMatchesTotal") != 3:
        fail("user_profile: free matches must be 2 of 3")
    messages = user.get("freeMessages") or {}
    if messages.get("left") != 3 or messages.get("priceAfter") != 5:
        fail("user_profile: freeMessages must be left 3, priceAfter 5")
    progress = user.get("levelProgress") or {}
    current = progress.get("current")
    required = progress.get("required")
    percent = progress.get("percent")
    if progress.get("nextLevel") != 3 or current != 320 or required != 500 or percent != 64:
        fail("user_profile: levelProgress must be 320/500 to level 3 (64%)")
    if is_int(current) and is_int(required) and is_int(percent):
        if current * 100 != percent * required:
            fail("user_profile: percent is not current/required")
    user_levels = levels.get("userLevels") if isinstance(levels, dict) else None
    if isinstance(user_levels, list) and len(user_levels) >= 3:
        gap = user_levels[2].get("diamonds", 0) - user_levels[1].get("diamonds", 0)
        if gap != required:
            fail(f"level gap from Lv2 to Lv3 is {gap}, profile required is {required}")


def _expect_host(host, label: str, expected: dict) -> None:
    if not isinstance(host, dict):
        fail(f"hosts.json: missing {label}")
        return
    for key, value in expected.items():
        if host.get(key) != value:
            fail(f"{label}.{key}: expected {value!r}, found {host.get(key)!r}")


def check_hosts(hosts) -> dict:
    if not isinstance(hosts, list):
        fail("hosts.json: expected a list")
        return {}
    by_id = {}
    humans = 0
    statuses = set()
    tiers = set()
    human_keys = {
        "id",
        "name",
        "age",
        "city",
        "languages",
        "rating",
        "callsCount",
        "followers",
        "charmLevel",
        "tier",
        "videoRatePerMin",
        "voiceRatePerMin",
        "status",
        "isAI",
    }
    for i, host in enumerate(hosts):
        label = f"hosts[{i}]"
        if not isinstance(host, dict):
            fail(f"{label}: expected an object")
            continue
        if host.get("isAI") is True:
            require_keys(host, human_keys | {"label", "subtitle"}, label)
        else:
            require_keys(host, human_keys, label, optional=PRIYA_FIELDS)
            extras = set(host) - human_keys
            expected_extras = PRIYA_FIELDS if host.get("id") == "host_priya" else set()
            if extras != expected_extras:
                fail(
                    f"{label}: artboard fields {sorted(extras)} != {sorted(expected_extras)}"
                )
            humans += 1
        by_id[host.get("id")] = host
        statuses.add(host.get("status"))
        if host.get("status") not in {"online", "busy", "offline"}:
            fail(f"{label}: bad status {host.get('status')!r}")
        if host.get("isAI") is True:
            tiers_ok = host.get("tier") is None
        elif host.get("tier") is None:
            # Anjali and Neha show a video rate and no tier letter.
            tiers_ok = True
        else:
            tiers_ok = host.get("tier") in TIER_RATES
            tiers.add(host.get("tier"))
        if not tiers_ok:
            fail(f"{label}: bad tier {host.get('tier')!r}")
        if host.get("isAI") is False and host.get("tier") in TIER_RATES:
            video, voice = TIER_RATES[host["tier"]]
            if (host.get("videoRatePerMin"), host.get("voiceRatePerMin")) != (video, voice):
                fail(f"{label}: {host.get('tier')} rates must be {video}/{voice}")
            if not is_int(host.get("callsCount")) or not is_int(host.get("followers")):
                fail(f"{label}: callsCount and followers must be integers")
        elif host.get("isAI") is False:
            voice = host.get("voiceRatePerMin")
            if voice is not None and (not is_int(voice) or voice < 0):
                fail(f"{label}: voiceRatePerMin must be null or a non-negative integer")
            if host.get("callsCount") is not None or host.get("followers") is not None:
                fail(f"{label}: callsCount and followers stay null until the artboard shows them")
            if not is_int(host.get("videoRatePerMin")):
                fail(f"{label}: videoRatePerMin must be an integer")
    if humans != 10:
        fail(f"hosts.json: expected 10 human hosts, found {humans}")
    aria = by_id.get("host_aria")
    if not aria or aria.get("name") != "Aria" or aria.get("isAI") is not True:
        fail("hosts.json: missing AI companion Aria")
    elif (
        aria.get("label") != "AI companion"
        or aria.get("subtitle") != "Always available"
        or aria.get("videoRatePerMin") != 15
        or aria.get("voiceRatePerMin") != 15
    ):
        fail("Aria must be labelled AI companion, subtitle Always available, at 15/min")
    priya = by_id.get("host_priya")
    if not priya:
        fail("hosts.json: missing host_priya")
    else:
        expected = {
            "name": "Priya",
            "age": 24,
            "city": "Lucknow",
            "languages": ["hi", "en"],
            "rating": 4.8,
            "callsCount": 2100,
            "followers": 8400,
            "charmLevel": 12,
            "tier": "B",
            "videoRatePerMin": 40,
            "voiceRatePerMin": 20,
            "status": "online",
            "isAI": False,
            "bio": "Hi! I love Bollywood music and long chats about travel. Say hi and let's talk.",
            "verified": True,
            "freeCall": True,
        }
        for key, value in expected.items():
            if priya.get(key) != value:
                fail(f"host_priya.{key}: expected {value!r}, found {priya.get(key)!r}")
        if priya.get("topGift") != {"giftId": "gift_rose", "count": 120}:
            fail(f"host_priya.topGift: expected Rose x120, found {priya.get('topGift')!r}")
        gallery = {
            "profileIndex": 1,
            "viewerIndex": 3,
            "count": 6,
            "tiles": [
                {"label": "Photo"},
                {"label": "Photo"},
                {"label": "Intro clip", "durationSec": 12, "caption": "Recorded intro"},
            ],
            "moreLabel": "+3",
            "viewerLabel": '[Intro clip \u00b7 12s \u00b7 labelled "Recorded intro"]',
        }
        if priya.get("gallery") != gallery:
            fail(f"host_priya.gallery: expected the U13/U14 media, found {priya.get('gallery')!r}")
    _expect_host(
        by_id.get("host_anjali"),
        "host_anjali",
        {
            "name": "Anjali",
            "age": 26,
            "city": None,
            "languages": ["hi", "mr"],
            "rating": None,
            "callsCount": None,
            "followers": None,
            "charmLevel": None,
            "tier": None,
            "videoRatePerMin": 60,
            "voiceRatePerMin": 20,
            "status": "online",
            "isAI": False,
        },
    )
    _expect_host(
        by_id.get("host_neha"),
        "host_neha",
        {
            "name": "Neha",
            "age": 23,
            "city": None,
            "languages": ["ta", "en"],
            "rating": None,
            "callsCount": None,
            "followers": None,
            "charmLevel": None,
            "tier": None,
            "videoRatePerMin": 40,
            "voiceRatePerMin": None,
            "status": "busy",
            "isAI": False,
        },
    )
    if statuses != {"online", "busy", "offline"}:
        fail(f"hosts.json: statuses should cover online/busy/offline, found {statuses}")
    if tiers != {"A", "B", "C"}:
        fail(f"hosts.json: tiers should cover A/B/C, found {tiers}")
    return by_id


def check_wallet(wallet) -> dict:
    require_keys(
        wallet,
        {"packs", "firstRechargeOffer", "paymentMethods", "vipPlans", "vipPerks"},
        "wallet",
    )
    packs = {}
    if not isinstance(wallet, dict):
        return packs
    rows = wallet.get("packs")
    if not isinstance(rows, list) or not 5 <= len(rows) <= 7:
        fail("wallet.packs: expected 5 to 7 packs")
        rows = []
    tag_seen = {"BEST": 0, "BEST_VALUE": 0}
    pack_optional = {"bonusLabel"}
    for i, pack in enumerate(rows):
        require_keys(
            pack,
            {"id", "diamonds", "bonus", "priceINR", "tags"},
            f"wallet.packs[{i}]",
            optional=pack_optional,
        )
        if not isinstance(pack, dict):
            continue
        packs[pack.get("id")] = pack
        for key in ("diamonds", "priceINR"):
            if not is_int(pack.get(key)) or pack.get(key) < 0:
                fail(f"wallet.packs[{i}].{key}: expected a non-negative integer")
        bonus = pack.get("bonus")
        if bonus is not None and (not is_int(bonus) or bonus < 0):
            fail(f"wallet.packs[{i}].bonus: expected null or a non-negative integer")
        extras = set(pack) - {"id", "diamonds", "bonus", "priceINR", "tags"}
        if pack.get("id") == "pack_700":
            if extras != {"bonusLabel"} or pack.get("bonusLabel") != "+20% bonus":
                fail(f"wallet.packs[{i}]: U28 bonus label must be +20% bonus")
        elif extras:
            fail(f"wallet.packs[{i}]: unexpected {sorted(extras)}")
        tags = pack.get("tags")
        if not isinstance(tags, list):
            fail(f"wallet.packs[{i}].tags: expected a list")
            continue
        for tag in tags:
            if tag not in tag_seen:
                fail(f"wallet.packs[{i}]: unknown tag {tag!r}")
            else:
                tag_seen[tag] += 1
    for tag, count in tag_seen.items():
        if count != 1:
            fail(f"wallet.packs: tag {tag} appears {count} times, expected 1")
    sheet = packs.get("pack_700")
    if not isinstance(sheet, dict) or (
        sheet.get("diamonds") != 600
        or sheet.get("priceINR") != 249
        or sheet.get("bonus") is not None
        or sheet.get("tags") != ["BEST"]
    ):
        fail("wallet.packs pack_700: U28 shows 600 diamonds at ₹249, tag BEST, +20% bonus")
    larger = packs.get("pack_1500")
    if not isinstance(larger, dict) or (
        larger.get("diamonds") != 1300
        or larger.get("priceINR") != 499
        or larger.get("bonus") is not None
        or larger.get("tags") != []
    ):
        fail("wallet.packs pack_1500: U28 shows 1,300 diamonds at ₹499 and no bonus")
    offer = wallet.get("firstRechargeOffer")
    require_keys(offer, {"expiresAt", "validOnce"}, "wallet.firstRechargeOffer")
    if isinstance(offer, dict):
        parse_time(offer.get("expiresAt"), "wallet.firstRechargeOffer.expiresAt")
        if offer.get("validOnce") is not True:
            fail("wallet.firstRechargeOffer.validOnce must be true")
    methods = wallet.get("paymentMethods")
    method_ids = []
    if isinstance(methods, list):
        for i, method in enumerate(methods):
            require_keys(method, {"id", "label"}, f"wallet.paymentMethods[{i}]")
            if isinstance(method, dict):
                method_ids.append(method.get("id"))
    if method_ids != ["google_play", "upi_razorpay_alt_billing"]:
        fail(f"wallet.paymentMethods: unexpected ids {method_ids}")
    plans = wallet.get("vipPlans")
    plan_ids = {}
    if isinstance(plans, list):
        for i, plan in enumerate(plans):
            require_keys(plan, {"id", "duration", "priceINR"}, f"wallet.vipPlans[{i}]")
            if isinstance(plan, dict):
                plan_ids[plan.get("id")] = plan.get("priceINR")
    if plan_ids != {"vip_1w": 129, "vip_1m": 399, "vip_3m": 999}:
        fail(f"wallet.vipPlans: unexpected {plan_ids}")
    perks = wallet.get("vipPerks")
    if perks != [
        "15% off calls",
        "30 free Diamonds/day",
        "priority match",
        "unlimited free messages",
    ]:
        fail(f"wallet.vipPerks: unexpected {perks}")
    return packs


def check_gifts(gifts) -> dict:
    if not isinstance(gifts, list):
        fail("gifts.json: expected a list")
        return {}
    by_id = {}
    categories = set()
    names = {}
    for i, gift in enumerate(gifts):
        require_keys(
            gift,
            {"id", "name", "price", "category", "animation"},
            f"gifts[{i}]",
            optional={"tag", "chipLabel"},
        )
        if not isinstance(gift, dict):
            continue
        by_id[gift.get("id")] = gift
        names[gift.get("name")] = gift.get("price")
        price = gift.get("price")
        if not is_int(price) or not 10 <= price <= 999:
            fail(f"gifts[{i}]: price must be an integer from 10 to 999")
        category = gift.get("category")
        if category is None:
            if gift.get("name") != "Star":
                fail(f"gifts[{i}]: category is null only for Star, which U27 does not classify")
        elif category not in GIFT_CATEGORIES:
            fail(f"gifts[{i}]: bad category")
        else:
            categories.add(category)
        animation = gift.get("animation")
        if animation is None:
            if gift.get("name") != "Star":
                fail(f"gifts[{i}]: animation is null only for Star, which U27 does not show")
        elif not isinstance(animation, str) or not animation:
            fail(f"gifts[{i}]: animation placeholder required")
        if gift.get("name") == "Sing for me":
            if gift.get("tag") != "SONG" or gift.get("chipLabel") != "Song":
                fail("gifts: Sing for me tag is SONG and the U26 chip is Song")
        elif "tag" in gift or "chipLabel" in gift:
            fail(f"gifts[{i}]: tag and chipLabel are only on Sing for me")
    expected = {"Rose": 10, "Wave": 20, "Star": 30, "Sing for me": 99, "Dance": 199, "Crown": 500}
    for name, price in expected.items():
        if names.get(name) != price:
            fail(f"gifts: {name} must cost {price}")
    if categories != GIFT_CATEGORIES:
        fail(f"gifts: categories should cover {GIFT_CATEGORIES}, found {categories}")
    return by_id


def check_levels(levels) -> None:
    require_keys(levels, {"userLevels", "hostLevels"}, "levels")
    if not isinstance(levels, dict):
        return
    rows = levels.get("userLevels")
    if not isinstance(rows, list) or len(rows) != 30:
        fail("levels.userLevels: expected Lv1-Lv30")
        return
    previous = -1
    for i, row in enumerate(rows):
        require_keys(row, {"level", "diamonds", "perks"}, f"levels.userLevels[{i}]")
        if not isinstance(row, dict):
            continue
        if row.get("level") != i + 1:
            fail(f"levels.userLevels[{i}]: expected level {i + 1}")
        diamonds = row.get("diamonds")
        if not is_int(diamonds) or diamonds <= previous:
            fail(f"levels.userLevels[{i}]: diamonds must increase")
        previous = diamonds if is_int(diamonds) else previous
        perks = row.get("perks")
        if row.get("level") == 10 and perks != ["5% call discount"]:
            fail("Lv10 perk must be 5% call discount")
        elif row.get("level") == 20 and perks != ["dedicated support"]:
            fail("Lv20 perk must be dedicated support")
        elif row.get("level") not in (10, 20) and perks != []:
            fail(f"Lv{row.get('level')}: no extra perks")
    if rows[0].get("diamonds") != 0:
        fail("Lv1 threshold must be 0")
    if rows[-1].get("diamonds") != 200000:
        fail("Lv30 threshold must be 200000")
    bands = levels.get("hostLevels")
    if not isinstance(bands, list) or len(bands) != 4:
        fail("levels.hostLevels: expected 4 bands")
        return
    expected_bands = [("1-5", 1, 5), ("6-10", 6, 10), ("11-15", 11, 15), ("16+", 16, None)]
    for i, (band, start, end) in enumerate(expected_bands):
        row = bands[i]
        require_keys(
            row,
            {"band", "fromLevel", "toLevel", "sharePercent"},
            f"levels.hostLevels[{i}]",
        )
        if not isinstance(row, dict):
            continue
        if (
            row.get("band") != band
            or row.get("fromLevel") != start
            or row.get("toLevel") != end
            or row.get("sharePercent") is not None
        ):
            fail(f"levels.hostLevels[{i}]: expected {band} with sharePercent null")


def check_calls(calls, hosts: dict) -> dict:
    if not isinstance(calls, list) or not calls:
        fail("calls.json: expected a non-empty list")
        return {}
    by_id = {}
    statuses = set()
    keys = {
        "id",
        "hostId",
        "userId",
        "type",
        "startedAt",
        "durationSec",
        "ratePerMin",
        "diamondsCharged",
        "giftsCount",
        "status",
    }
    for i, call in enumerate(calls):
        label = f"calls[{i}]"
        require_keys(call, keys, label)
        if not isinstance(call, dict):
            continue
        by_id[call.get("id")] = call
        if call.get("userId") != "user_rahul":
            fail(f"{label}: sample history belongs to user_rahul")
        if call.get("type") not in {"video", "voice"}:
            fail(f"{label}: bad type")
        if call.get("status") not in CALL_STATUSES:
            fail(f"{label}: bad status")
        statuses.add(call.get("status"))
        for key in ("durationSec", "ratePerMin", "diamondsCharged", "giftsCount"):
            if not is_int(call.get(key)) or call.get(key) < 0:
                fail(f"{label}.{key}: expected a non-negative integer")
        host = hosts.get(call.get("hostId"))
        if isinstance(host, dict) and call.get("type") in {"video", "voice"}:
            rate_key = "videoRatePerMin" if call["type"] == "video" else "voiceRatePerMin"
            if call.get("ratePerMin") != host.get(rate_key):
                fail(f"{label}: ratePerMin does not match host {rate_key}")
        if call.get("status") == "missed" and (
            call.get("durationSec") != 0 or call.get("diamondsCharged") != 0
        ):
            fail(f"{label}: a missed call has no duration and no charge")
        # Exact pro-rata, except the specified 8:42 call which is stored as 349.
        if is_int(call.get("durationSec")) and is_int(call.get("ratePerMin")):
            raw = call["durationSec"] * call["ratePerMin"]
            if call.get("id") == "call_priya_842":
                if raw != 522 * 40 or call.get("diamondsCharged") != 349:
                    fail("call_priya_842 must be 522s at 40/min, charged 349")
            elif raw % 60 != 0 or call.get("diamondsCharged") != raw // 60:
                fail(f"{label}: diamondsCharged is not durationSec * ratePerMin / 60")
        parse_time(call.get("startedAt"), f"{label}.startedAt")
    featured = by_id.get("call_priya_842")
    if not featured:
        fail("calls.json: missing call_priya_842")
    elif (
        featured.get("hostId") != "host_priya"
        or featured.get("type") != "video"
        or featured.get("durationSec") != 522
        or featured.get("giftsCount") != 2
        or featured.get("status") != "completed"
    ):
        fail("call_priya_842 must be Priya's completed 8:42 video call with 2 gifts")
    if statuses != CALL_STATUSES:
        fail(f"calls.json: statuses should cover {CALL_STATUSES}, found {statuses}")
    return by_id


def check_ledger(ledger, packs: dict, calls: dict, gifts: dict, balance: int) -> None:
    if not isinstance(ledger, list) or not ledger:
        fail("ledger.json: expected a non-empty list")
        return
    keys = {"id", "type", "amount", "balanceAfter", "createdAt", "refId", "meta"}
    previous_balance = 0
    previous_time = None
    call_amounts: dict[str, int] = {}
    gift_counts: dict[str, int] = {}
    gift_totals: dict[str, int] = {}
    by_id = {}
    refunds = []
    for i, entry in enumerate(ledger):
        label = f"ledger[{i}]"
        require_keys(entry, keys, label)
        if not isinstance(entry, dict):
            continue
        by_id[entry.get("id")] = entry
        kind = entry.get("type")
        amount = entry.get("amount")
        after = entry.get("balanceAfter")
        if kind not in LEDGER_TYPES:
            fail(f"{label}: bad type {kind!r}")
        if not is_int(amount) or not is_int(after):
            fail(f"{label}: amount and balanceAfter must be integers")
            continue
        if kind in POSITIVE_TYPES and amount <= 0:
            fail(f"{label}: {kind} amount must be positive")
        if kind in NEGATIVE_TYPES and amount >= 0:
            fail(f"{label}: {kind} amount must be negative")
        if after != previous_balance + amount:
            fail(
                f"{label}: balanceAfter {after} != {previous_balance} + {amount}"
            )
        if after < 0:
            fail(f"{label}: balance went negative")
        previous_balance = after
        created = parse_time(entry.get("createdAt"), f"{label}.createdAt")
        if created is not None and previous_time is not None and created <= previous_time:
            fail(f"{label}: createdAt must increase")
        if created is not None:
            previous_time = created
        ref = entry.get("refId")
        meta = entry.get("meta")
        if not isinstance(meta, dict):
            fail(f"{label}: meta must be an object")
            meta = {}
        if kind in {"recharge", "bonus"}:
            pack = packs.get(ref)
            if not pack:
                fail(f"{label}: {kind} ref does not resolve")
            elif ref == "pack_700" and kind == "recharge":
                # U28 lists 600 diamonds. This row stays 700 so the sample
                # still ends at diamondBalance 120. 20% of 600 is not stored.
                if amount != 700:
                    fail(f"{label}: sample recharge credit stays 700")
            elif ref == "pack_700" and kind == "bonus":
                if amount != 100:
                    fail(f"{label}: sample bonus credit stays 100")
            else:
                field = "diamonds" if kind == "recharge" else "bonus"
                if amount != pack.get(field):
                    fail(f"{label}: {kind} amount must match pack {field}")
        if kind == "call":
            call = calls.get(ref)
            call_amounts[ref] = call_amounts.get(ref, 0) + amount
            if not call:
                fail(f"{label}: call ref does not resolve")
            else:
                if meta.get("hostId") != call.get("hostId"):
                    fail(f"{label}: meta.hostId does not match the call")
                if meta.get("durationSec") != call.get("durationSec"):
                    fail(f"{label}: meta.durationSec does not match the call")
                if meta.get("ratePerMin") != call.get("ratePerMin"):
                    fail(f"{label}: meta.ratePerMin does not match the call")
                started = parse_time(call.get("startedAt"), f"{label}.call.startedAt")
                if started and created and is_int(call.get("durationSec")):
                    end = started + timedelta(seconds=call["durationSec"])
                    if created != end:
                        fail(f"{label}: call charge must be timestamped at hangup")
        if kind == "gift":
            call = calls.get(ref)
            gift = gifts.get(meta.get("giftId"))
            gift_counts[ref] = gift_counts.get(ref, 0) + 1
            gift_totals[ref] = gift_totals.get(ref, 0) + (-amount)
            if not gift or amount != -gift.get("price"):
                fail(f"{label}: gift amount must match the catalog price")
            if not call:
                fail(f"{label}: gift refId must be the call it was sent in")
            else:
                started = parse_time(call.get("startedAt"), f"{label}.call.startedAt")
                if started and created and is_int(call.get("durationSec")):
                    end = started + timedelta(seconds=call["durationSec"])
                    if not started <= created <= end:
                        fail(f"{label}: gift was not sent during the call")
        if kind == "refund":
            refunds.append(entry)
    if previous_balance != balance:
        fail(f"ledger ends at {previous_balance}, profile diamondBalance is {balance}")
    if len(refunds) != 1:
        fail(f"ledger: expected one refund entry, found {len(refunds)}")
    for call_id, call in calls.items():
        charged = call_amounts.get(call_id, 0)
        if charged != -call.get("diamondsCharged"):
            fail(
                f"{call_id}: ledger call sum {charged} != -{call.get('diamondsCharged')}"
            )
        if gift_counts.get(call_id, 0) != call.get("giftsCount"):
            fail(f"{call_id}: gift ledger rows do not match giftsCount")
    if len(refunds) == 1:
        refund = refunds[0]
        original = by_id.get(refund.get("refId"))
        if not original or refund.get("amount") != -original.get("amount"):
            fail("refund must reverse its refId ledger entry in full")
        elif original.get("type") != "call":
            fail("the sample refund must reverse a call charge")
        else:
            call = calls.get(original.get("refId"))
            if not call or call.get("status") != "refunded":
                fail("refunded ledger call must point at a call with status refunded")
            if refund.get("meta", {}).get("callId") != original.get("refId"):
                fail("refund meta.callId must be the refunded call")
    featured_gifts = gift_totals.get("call_priya_842")
    if featured_gifts != 109:
        fail(f"call_priya_842 gifts must total 109 Diamonds, found {featured_gifts}")


def check_earnings(earnings, calls: dict, gifts_total_by_call: dict[str, int]) -> None:
    require_keys(earnings, {"hostId", "entries"}, "host_earnings")
    if not isinstance(earnings, dict):
        return
    if earnings.get("hostId") != "host_priya":
        fail("host_earnings: this file is Priya's view")
    entries = earnings.get("entries")
    if not isinstance(entries, list):
        fail("host_earnings.entries: expected a list")
        return
    seen = []
    keys = {
        "id",
        "callId",
        "userDiamonds",
        "giftUserDiamonds",
        "inrAmount",
        "sharePercent",
        "tds",
    }
    for i, entry in enumerate(entries):
        label = f"host_earnings.entries[{i}]"
        require_keys(entry, keys, label)
        if not isinstance(entry, dict):
            continue
        seen.append(entry.get("callId"))
        call = calls.get(entry.get("callId"))
        if not call:
            fail(f"{label}: callId does not resolve")
            continue
        if call.get("hostId") != earnings.get("hostId"):
            fail(f"{label}: earnings call belongs to another host")
        if entry.get("userDiamonds") != call.get("diamondsCharged"):
            fail(f"{label}: userDiamonds must match calls.diamondsCharged")
        if entry.get("giftUserDiamonds") != gifts_total_by_call.get(call["id"], 0):
            fail(f"{label}: giftUserDiamonds must match gifts sent on that call")
        for key in ("inrAmount", "sharePercent", "tds"):
            if entry.get(key) is not None:
                fail(f"{label}.{key} must be null")
    if set(seen) != set(calls):
        fail("host_earnings call ids must be exactly the ids in calls.json")
    if len(seen) != len(set(seen)):
        fail("host_earnings: duplicate callId")


def check_config(config, codes: set[str], packs: dict) -> None:
    """App config. Pack ids must exist in wallet.json. Copy uses languages.json codes."""
    require_keys(
        config,
        {
            "version",
            "assetBaseUrl",
            "strings",
            "rechargePackIds",
            "homeBanners",
            "tabs",
            "features",
            "limits",
            "discover",
            "calls",
        },
        "config",
    )
    if not isinstance(config, dict):
        return
    version = config.get("version")
    if not isinstance(version, str) or not version:
        fail("config.version: expected a non-empty version string")
    base = config.get("assetBaseUrl")
    if not isinstance(base, str) or not base.startswith("https://") or not base.endswith("/"):
        fail("config.assetBaseUrl: expected an https CDN placeholder ending in /")

    sample_keys = {"U01_title", "U01_subtitle", "U32_title", "U32_subtitle", "U48_lowBalance"}
    strings = config.get("strings")
    if not isinstance(strings, dict) or set(strings) != sample_keys:
        fail(f"config.strings: expected sample keys {sorted(sample_keys)}")
        strings = {}
    for key, value in strings.items():
        _check_lang_map(value, codes, f"config.strings.{key}")

    pack_ids = config.get("rechargePackIds")
    if not isinstance(pack_ids, list) or not pack_ids:
        fail("config.rechargePackIds: expected a non-empty list of pack ids")
        pack_ids = []
    seen_packs = set()
    for i, pack_id in enumerate(pack_ids):
        if not isinstance(pack_id, str):
            fail(f"config.rechargePackIds[{i}]: must be a pack id, not a price object")
            continue
        if pack_id not in packs:
            fail(f"config.rechargePackIds[{i}]: unknown pack {pack_id!r}")
        if pack_id in seen_packs:
            fail(f"config.rechargePackIds: duplicate {pack_id!r}")
        seen_packs.add(pack_id)

    banners = config.get("homeBanners")
    if not isinstance(banners, list) or not banners:
        fail("config.homeBanners: expected a non-empty list")
        banners = []
    banner_ids = set()
    banner_keys = {"id", "imageUrl", "deeplink", "startAt", "endAt", "serverDriven"}
    banner_copy = {"title", "detail", "cta"}
    for i, banner in enumerate(banners):
        label = f"config.homeBanners[{i}]"
        require_keys(banner, banner_keys, label, optional=banner_copy)
        if not isinstance(banner, dict):
            continue
        banner_id = banner.get("id")
        if not isinstance(banner_id, str) or not banner_id:
            fail(f"{label}.id: expected a non-empty string")
        elif banner_id in banner_ids:
            fail(f"{label}: duplicate banner id {banner_id!r}")
        banner_ids.add(banner_id)
        image = banner.get("imageUrl")
        if not isinstance(image, str) or (isinstance(base, str) and not image.startswith(base)):
            fail(f"{label}.imageUrl: expected a URL under assetBaseUrl")
        if not isinstance(banner.get("deeplink"), str) or not banner.get("deeplink"):
            fail(f"{label}.deeplink: expected a non-empty string")
        if banner.get("serverDriven") is not True:
            fail(f"{label}.serverDriven must be true")
        start = parse_time(banner.get("startAt"), f"{label}.startAt")
        end = parse_time(banner.get("endAt"), f"{label}.endAt")
        if start is not None and end is not None and end <= start:
            fail(f"{label}: endAt must be after startAt")
        copy = {key: banner.get(key) for key in banner_copy if key in banner}
        if banner_id == "banner_recharge":
            expected_copy = {
                "title": "First recharge: +100% Diamonds",
                "detail": "Ends in 23:41:10 \u00b7 new users only",
                "cta": "Get",
            }
            if copy != expected_copy:
                fail(f"{label}: promo copy {copy!r} != {expected_copy!r}")
        elif copy:
            fail(f"{label}: promo copy is only on banner_recharge, found {sorted(copy)}")

    tabs = config.get("tabs")
    expected_tabs = [
        ("discover", "Home"),
        ("match", "Match"),
        ("live", "Live"),
        ("messages", "Messages"),
        ("me", "Me"),
    ]
    if not isinstance(tabs, list) or len(tabs) != len(expected_tabs):
        fail("config.tabs: expected Home, Match, Live, Messages, Me")
        tabs = []
    for i, (tab_id, label_text) in enumerate(expected_tabs):
        if i >= len(tabs):
            break
        tab = tabs[i]
        require_keys(tab, {"id", "label", "enabled"}, f"config.tabs[{i}]")
        if not isinstance(tab, dict):
            continue
        if tab.get("id") != tab_id or tab.get("label") != label_text:
            fail(f"config.tabs[{i}]: expected {tab_id} / {label_text}")
        if not isinstance(tab.get("enabled"), bool):
            fail(f"config.tabs[{i}].enabled: expected a boolean")

    features = config.get("features")
    require_keys(
        features,
        {
            "quickMatch",
            "liveRooms",
            "aiCompanion",
            "vip",
            "chatPaidMessages",
            "forceUpdate",
            "maintenance",
        },
        "config.features",
    )
    if isinstance(features, dict):
        for key in ("quickMatch", "liveRooms", "aiCompanion", "vip", "chatPaidMessages"):
            if not isinstance(features.get(key), bool):
                fail(f"config.features.{key}: expected a boolean")
        force = features.get("forceUpdate")
        require_keys(force, {"minVersion"}, "config.features.forceUpdate")
        if isinstance(force, dict):
            min_version = force.get("minVersion")
            if not isinstance(min_version, str) or not min_version:
                fail("config.features.forceUpdate.minVersion: expected a version string")
        maintenance = features.get("maintenance")
        require_keys(maintenance, {"on", "message"}, "config.features.maintenance")
        if isinstance(maintenance, dict):
            if maintenance.get("on") is not False:
                fail("config.features.maintenance.on must be false")
            _check_lang_map(maintenance.get("message"), codes, "config.features.maintenance.message")

    limits = config.get("limits")
    require_keys(
        limits,
        {"freeMatchesPerDay", "freeMessagesPerHost", "lowBalanceWarningSec"},
        "config.limits",
    )
    if isinstance(limits, dict) and (
        limits.get("freeMatchesPerDay") != 3
        or limits.get("freeMessagesPerHost") != 3
        or limits.get("lowBalanceWarningSec") != 60
    ):
        fail("config.limits: expected freeMatchesPerDay 3, freeMessagesPerHost 3, lowBalanceWarningSec 60")

    _check_discover(config.get("discover"))
    _check_calls(config.get("calls"))


def _check_discover(discover) -> None:
    """U11–U12 copy. Strings are the artboard text, including the en dash in 40–80."""
    mid = "\u00b7"
    expected = {
        "cardHostIds": ["host_priya", "host_anjali", "host_neha", "host_aria"],
        "chips": [
            {"label": "Hot", "selected": True},
            {"label": "New", "selected": False},
            {"label": "Following", "selected": False},
            {"label": "Hindi", "selected": False},
            {"label": "Filter", "selected": False},
        ],
        "badges": {
            "online": "\u25cf Online",
            "inCall": "\u25cf In a call",
            "freeCall": "Free call",
            "verified": "Verified",
        },
        "filters": {
            "title": "Filters",
            "resetLabel": "Reset",
            "hostCount": 128,
            "submitLabel": "Show 128 hosts",
            "groups": [
                {
                    "label": "Language",
                    "options": [
                        {"label": "Hindi", "selected": True},
                        {"label": "English", "selected": False},
                        {"label": "Tamil", "selected": False},
                        {"label": "Telugu", "selected": False},
                        {"label": "Bengali", "selected": False},
                        {"label": "Marathi", "selected": False},
                    ],
                },
                {
                    "label": "Price per minute",
                    "options": [
                        {"label": "Any", "selected": True},
                        {"label": "Up to 40", "selected": False},
                        {"label": "40\u201380", "selected": False},
                        {"label": "80+", "selected": False},
                    ],
                },
                {
                    "label": "Show",
                    "options": [
                        {"label": "Online now", "selected": True},
                        {"label": "Free-call hosts", "selected": False},
                        {"label": "AI companions", "selected": False},
                    ],
                },
                {
                    "label": "Region",
                    "options": [
                        {"label": "All India", "selected": True},
                        {"label": "North", "selected": False},
                        {"label": "South", "selected": False},
                        {"label": "East", "selected": False},
                        {"label": "West", "selected": False},
                    ],
                },
            ],
        },
        "profile": {"chatLabel": "Chat", "videoCallLabel": "Video call"},
        "viewer": {"liveCallLabel": f"Call $name live {mid} $rate/min"},
    }
    if discover != expected:
        fail("config.discover: does not match the U11–U12 artboard copy")
        if isinstance(discover, dict) and isinstance(expected, dict):
            for key in sorted(set(discover) | set(expected)):
                if discover.get(key) != expected.get(key):
                    fail(f"config.discover.{key}: mismatch")


def _check_calls(calls) -> None:
    """U23–U31 copy. Clocks and balances are the artboard strings, not derived."""
    mid = "\u00b7"
    expected = {
        "confirm": {
            "statusLine": f"Online {mid} usually answers in 5s",
            "billing": f"Per second {mid} stops when you hang up",
            "warning": "We'll warn you 60 seconds before your balance runs out. You can top up without ending the call.",
            "dontShow": "Don't show this again for calls under 60/min",
            "talkTime": "about 3 minutes",
            "balanceLabel": "120 Diamonds",
            "startLabel": "Start video call",
            "voiceInstead": f"Voice call instead {mid} 20/min",
        },
        "outgoing": {
            "status": "Calling\u2026",
            "notice": "You are not charged until she answers",
        },
        "incoming": {
            "badge": f"Verified host {mid} live now",
            "talked": "You talked yesterday",
            "rateNote": "40/min if you answer",
            "turnOff": "Turn off host call-backs",
        },
        "video": {
            "clock": "03:12",
            "balance": 88,
            "minutesLeft": f"~2 min left",
            "caption": "Live video (host camera)",
            "youLabel": "You",
            "roseSent": 10,
            "thanks": "Thank you so much!",
            "balanceLine": f"88 {mid} ~2 min left",
        },
        "gifts": {
            "clock": "03:40",
            "balance": 64,
            "combo": f"Combo x3 active {mid} send again within 3s",
        },
        "lowBalance": {
            "clock": "0:58 left",
            "seconds": 58,
            "body": "Your balance runs out in 58 seconds. The call continues while you pay.",
            "pay": "Pay \u20b9249 with Google Play",
            "otherMethods": "Other payment methods",
            "endWhenEmpty": "End call when balance runs out",
        },
        "voice": {
            "hostId": "host_anjali",
            "clock": "07:25",
            "label": f"Voice call {mid} 20/min",
        },
        "summary": {
            "chips": [
                {"label": "Friendly", "selected": True},
                {"label": "Good talk", "selected": False},
                {"label": "Camera off", "selected": False},
                {"label": "Rude", "selected": False},
            ]
        },
        "queue": {
            "place": 3,
            "wait": "About 2 minutes",
            "body": "All Hindi-speaking hosts are in calls. We'll connect you to the next free one.",
            "ariaLine": f"AI companion {mid} 15/min",
            "voiceHostsAvailable": 12,
            "dontWait": "Don't want to wait?",
            "notify": "Notify me when it's my turn",
            "leave": "Leave queue",
        },
    }
    if calls != expected:
        fail("config.calls: does not match the U23–U31 artboard copy")
        if isinstance(calls, dict) and isinstance(expected, dict):
            for key in sorted(set(calls) | set(expected)):
                if calls.get(key) != expected.get(key):
                    fail(f"config.calls.{key}: mismatch")


def _check_lang_map(value, codes: set[str], label: str) -> None:
    if not isinstance(value, dict):
        fail(f"{label}: expected an object keyed by language code")
        return
    unknown = sorted(set(value) - codes)
    missing = sorted(codes - set(value))
    if unknown:
        fail(f"{label}: unknown language code(s) {unknown}")
    if missing:
        fail(f"{label}: missing language code(s) {missing}")
    for code, text in value.items():
        if not isinstance(text, str) or not text.strip():
            fail(f"{label}.{code}: expected a non-empty string")


def gift_totals(ledger) -> dict[str, int]:
    totals: dict[str, int] = {}
    if not isinstance(ledger, list):
        return totals
    for entry in ledger:
        if isinstance(entry, dict) and entry.get("type") == "gift":
            ref = entry.get("refId")
            amount = entry.get("amount")
            if is_int(amount):
                totals[ref] = totals.get(ref, 0) + (-amount)
    return totals


def main() -> int:
    languages = load("languages.json")
    user = load("user_profile.json")
    hosts = load("hosts.json")
    wallet = load("wallet.json")
    ledger = load("ledger.json")
    calls = load("calls.json")
    gifts = load("gifts.json")
    levels = load("levels.json")
    earnings = load("host_earnings.json")
    config = load("config.json")
    if any(
        doc is None
        for doc in (languages, user, hosts, wallet, ledger, calls, gifts, levels, earnings, config)
    ):
        _report()
        return 1

    codes = check_languages(languages)
    check_levels(levels)
    check_user(user, levels)
    host_index = check_hosts(hosts)
    packs = check_wallet(wallet)
    gift_index = check_gifts(gifts)
    call_index = check_calls(calls, host_index)

    ids: dict[str, str] = {}
    if isinstance(user, dict):
        register(ids, user.get("id"), "user_profile")
    for host in hosts or []:
        if isinstance(host, dict):
            register(ids, host.get("id"), "hosts")
    for call in calls or []:
        if isinstance(call, dict):
            register(ids, call.get("id"), "calls")
    for gift in gifts or []:
        if isinstance(gift, dict):
            register(ids, gift.get("id"), "gifts")
    for pack in packs.values():
        register(ids, pack.get("id"), "wallet.packs")
    for method in wallet.get("paymentMethods") or []:
        if isinstance(method, dict):
            register(ids, method.get("id"), "wallet.paymentMethods")
    for plan in wallet.get("vipPlans") or []:
        if isinstance(plan, dict):
            register(ids, plan.get("id"), "wallet.vipPlans")
    for entry in ledger or []:
        if isinstance(entry, dict):
            register(ids, entry.get("id"), "ledger")
    for entry in (earnings or {}).get("entries") or []:
        if isinstance(entry, dict):
            register(ids, entry.get("id"), "host_earnings")

    documents = {
        "languages": languages,
        "user_profile": user,
        "hosts": hosts,
        "wallet": wallet,
        "ledger": ledger,
        "calls": calls,
        "gifts": gifts,
        "levels": levels,
        "host_earnings": earnings,
        "config": config,
    }
    for name, doc in documents.items():
        walk_languages(doc, codes, name)
        walk_refs(doc, ids, name)
        # config.features.vip is a feature switch, not the user's VIP state.
        if name not in {"user_profile", "levels", "config"}:
            walk_single_profile(doc, name)

    balance = user.get("diamondBalance") if isinstance(user, dict) else None
    check_ledger(ledger, packs, call_index, gift_index, balance if is_int(balance) else -1)
    check_earnings(earnings, call_index, gift_totals(ledger))
    check_config(config, codes, packs)

    _report()
    return 1 if errors else 0


def _report() -> None:
    if errors:
        print(f"mock validation failed ({len(errors)}):", file=sys.stderr)
        for message in errors:
            print(f"- {message}", file=sys.stderr)
    else:
        print("mock validation passed")


if __name__ == "__main__":
    sys.exit(main())
