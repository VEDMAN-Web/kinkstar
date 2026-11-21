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

# U48 prints the native name. English is "English" on that artboard too.
NATIVE_NAMES = [
    ("hi", "हिन्दी"),
    ("en", "English"),
    ("bn", "বাংলা"),
    ("ta", "தமிழ்"),
    ("te", "తెలుగు"),
    ("mr", "मराठी"),
    ("kn", "ಕನ್ನಡ"),
]

# Tier B is the specified rate. A and C are the mock display ladder.
TIER_RATES = {"A": (60, 30), "B": (40, 20), "C": (20, 10)}

LEDGER_TYPES = {"recharge", "call", "gift", "message", "vip", "bonus", "refund"}
POSITIVE_TYPES = {"recharge", "bonus", "refund"}
NEGATIVE_TYPES = {"call", "gift", "message", "vip"}
REF_KEYS = {"hostId", "userId", "refId", "callId", "giftId"}
CALL_STATUSES = {"completed", "missed", "dropped", "refunded"}
GIFT_CATEGORIES = {"popular", "interactive", "luxury", "event"}
# U21 shows these names and prices, not a catalog category or animation.
ARTBOARD_GIFTS_WITHOUT_CATEGORY = {
    "Star",
    "Chocolate",
    "Kiss",
    "Fireworks",
    "Diamond ring",
    "Daily heart",
}

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


def require_keys(obj, keys: set[str], label: str) -> None:
    if not isinstance(obj, dict):
        fail(f"{label}: expected an object")
        return
    actual = set(obj)
    missing = keys - actual
    extra = actual - keys
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
    native = []
    for i, row in enumerate(languages):
        require_keys(row, {"code", "name", "nativeName"}, f"languages[{i}]")
        if isinstance(row, dict):
            rows.append((row.get("code"), row.get("name")))
            native.append((row.get("code"), row.get("nativeName")))
    if rows != LANGS:
        fail(f"languages.json: expected {LANGS}, found {rows}")
    if native != NATIVE_NAMES:
        fail(f"languages.json: native names must match U48, found {native}")
    return {code for code, _ in LANGS}


def check_user(user, levels) -> None:
    require_keys(
        user,
        {
            "id",
            "username",
            "dateOfBirth",
            "about",
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
    if user.get("dateOfBirth") != "14 Mar 1996":
        fail("user_profile: dateOfBirth must be the U46 value 14 Mar 1996")
    if user.get("about") != "Movie buff from Delhi":
        fail("user_profile: about must be the U46 value Movie buff from Delhi")
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
            require_keys(host, human_keys | {"label"}, label)
        else:
            require_keys(host, human_keys, label)
            humans += 1
        by_id[host.get("id")] = host
        statuses.add(host.get("status"))
        if host.get("status") not in {"online", "busy", "offline"}:
            fail(f"{label}: bad status {host.get('status')!r}")
        if host.get("isAI") is True:
            tiers_ok = host.get("tier") is None
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
    if humans != 8:
        fail(f"hosts.json: expected 8 human hosts, found {humans}")
    aria = by_id.get("host_aria")
    if not aria or aria.get("name") != "Aria" or aria.get("isAI") is not True:
        fail("hosts.json: missing AI companion Aria")
    elif (
        aria.get("label") != "AI Companion"
        or aria.get("videoRatePerMin") != 15
        or aria.get("voiceRatePerMin") != 15
    ):
        fail("Aria must be labelled AI Companion at 15/min video and voice")
    priya = by_id.get("host_priya")
    if not priya:
        fail("hosts.json: missing host_priya")
    else:
        expected = {
            "name": "Priya",
            "age": 24,
            "city": "Lucknow",
            "charmLevel": 12,
            "tier": "B",
            "videoRatePerMin": 40,
            "voiceRatePerMin": 20,
            "isAI": False,
        }
        for key, value in expected.items():
            if priya.get(key) != value:
                fail(f"host_priya.{key}: expected {value!r}, found {priya.get(key)!r}")
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
    tag_seen = {"MOST_POPULAR": 0, "BEST_VALUE": 0}
    for i, pack in enumerate(rows):
        require_keys(
            pack,
            {"id", "diamonds", "bonus", "priceINR", "tags"},
            f"wallet.packs[{i}]",
        )
        if not isinstance(pack, dict):
            continue
        packs[pack.get("id")] = pack
        for key in ("diamonds", "bonus", "priceINR"):
            if not is_int(pack.get(key)) or pack.get(key) < 0:
                fail(f"wallet.packs[{i}].{key}: expected a non-negative integer")
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
            {"id", "name", "price", "priceLabel", "tag", "category", "animation"},
            f"gifts[{i}]",
        )
        if not isinstance(gift, dict):
            continue
        where = f"gifts[{i}]"
        by_id[gift.get("id")] = gift
        name = gift.get("name")
        names[name] = gift.get("price")
        price = gift.get("price")
        price_label = gift.get("priceLabel")
        if name == "Daily heart":
            if price != 0 or price_label != "0 (1 left)":
                fail(f"{where}: Daily heart must be price 0 with label '0 (1 left)'")
        elif not is_int(price) or not 10 <= price <= 999 or price_label is not None:
            fail(f"{where}: price must be an integer from 10 to 999 with no priceLabel")
        category = gift.get("category")
        if category is None:
            if name not in ARTBOARD_GIFTS_WITHOUT_CATEGORY:
                fail(f"{where}: category is null")
        elif category not in GIFT_CATEGORIES:
            fail(f"{where}: bad category")
        else:
            categories.add(category)
        animation = gift.get("animation")
        if animation is None:
            if name not in ARTBOARD_GIFTS_WITHOUT_CATEGORY:
                fail(f"{where}: animation is null")
        elif not isinstance(animation, str) or not animation:
            fail(f"{where}: animation placeholder required")
        tag = gift.get("tag")
        if tag is not None and not isinstance(tag, str):
            fail(f"{where}: tag must be a string or null")
    expected = {
        "Rose": 10,
        "Wave": 20,
        "Sing for me": 99,
        "Dance": 199,
        "Crown": 500,
        "Star": 30,
        "Chocolate": 50,
        "Kiss": 99,
        "Fireworks": 199,
        "Diamond ring": 999,
        "Daily heart": 0,
    }
    for name, price in expected.items():
        if names.get(name) != price:
            fail(f"gifts: {name} must cost {price}")
    expected_tags = {"Crown": "HOT", "Daily heart": "FREE", "Sing for me": "SONG"}
    for gift in by_id.values():
        name = gift.get("name")
        if gift.get("tag") != expected_tags.get(name):
            fail(f"gifts: {name} tag must be {expected_tags.get(name)!r}")
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
            field = "diamonds" if kind == "recharge" else "bonus"
            if not pack or amount != pack.get(field):
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
            "build",
            "assetBaseUrl",
            "strings",
            "rechargePackIds",
            "homeBanners",
            "tabs",
            "features",
            "limits",
        },
        "config",
    )
    if not isinstance(config, dict):
        return
    version = config.get("version")
    if version != "1.0.0":
        fail("config.version: U45 and U52 show 1.0.0")
    if config.get("build") != "100":
        fail("config.build: U52 shows build 100")
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
    for i, banner in enumerate(banners):
        label = f"config.homeBanners[{i}]"
        require_keys(banner, banner_keys, label)
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

    tabs = config.get("tabs")
    expected_tabs = [
        ("discover", "Home"),
        ("match", "Match"),
        ("live", "Live"),
        ("messages", "Messages"),
        ("me", "Me"),
    ]
    if not isinstance(tabs, list) or len(tabs) != len(expected_tabs):
        fail("config.tabs: expected Discover, Match, Live, Messages, Me")
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
        require_keys(
            force,
            {
                "minVersion",
                "title",
                "body",
                "whatsNewTitle",
                "whatsNew",
                "updateButton",
                "softUpdateNote",
            },
            "config.features.forceUpdate",
        )
        if isinstance(force, dict):
            if force.get("minVersion") != "1.2.0":
                fail("config.features.forceUpdate.minVersion: U54 what's new is 1.2.0")
            if force.get("title") != "Update required":
                fail("config.features.forceUpdate.title: U54 says Update required")
            if force.get("whatsNewTitle") != "What's new in 1.2.0":
                fail("config.features.forceUpdate.whatsNewTitle must match U54")
            if force.get("whatsNew") != [
                "· HD video on slow networks",
                "· Festival gifts",
                "· Bug fixes",
            ]:
                fail("config.features.forceUpdate.whatsNew must match U54")
            if force.get("updateButton") != "Update on Google Play":
                fail("config.features.forceUpdate.updateButton must match U54")
            if force.get("body") != (
                "This version is no longer supported. Update for faster calls and new gifts."
            ):
                fail("config.features.forceUpdate.body must match U54")
            if force.get("softUpdateNote") != 'Soft-update variant shows "Later" as well':
                fail("config.features.forceUpdate.softUpdateNote must match U54")
        maintenance = features.get("maintenance")
        require_keys(maintenance, {"on", "message"}, "config.features.maintenance")
        if isinstance(maintenance, dict):
            if maintenance.get("on") is not False:
                fail("config.features.maintenance.on must be false")
            message = maintenance.get("message")
            _check_lang_map(message, codes, "config.features.maintenance.message")
            english = "We're upgrading Kinkstar Calls. Back at 4:00 am."
            if isinstance(message, dict):
                for code in codes:
                    if message.get(code) != english:
                        fail(
                            f"config.features.maintenance.message.{code}: "
                            "U55 has no translation, so fall back to the English copy"
                        )

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


def _ref_or_null(value, index: dict[str, str], label: str) -> None:
    if value is None:
        return
    if not isinstance(value, str) or value not in index:
        fail(f"{label}: {value!r} does not resolve")


def check_messages(messages, hosts: dict, gifts: dict, ids: dict[str, str]) -> None:
    """U19–U21 and U42. Names that are not already hosts stay hostId null."""
    require_keys(messages, {"inbox", "chat", "giftSheet", "notifications"}, "messages")
    if not isinstance(messages, dict):
        return
    inbox = messages.get("inbox")
    require_keys(
        inbox,
        {"title", "tabs", "selectedTab", "calls", "following", "threads"},
        "messages.inbox",
    )
    if not isinstance(inbox, dict):
        return
    if inbox.get("title") != "Messages" or inbox.get("selectedTab") != "Chats":
        fail("messages.inbox: U19 title is Messages and Chats is selected")
    if inbox.get("tabs") != ["Chats", "Calls", "Following"]:
        fail("messages.inbox.tabs: U19 tabs are Chats, Calls, Following")
    if inbox.get("calls") is not None or inbox.get("following") is not None:
        fail("messages.inbox: Calls and Following panels are not on U19")
    threads = inbox.get("threads")
    expected_threads = [
        ("thread_team", None, "Kinkstar Team", "Official", "Your free call is ready. Tap to start.", "now", None, None),
        ("thread_priya", "host_priya", "Priya", None, "Thanks for the rose! Call me later?", "9:42 pm", 2, True),
        ("thread_anjali", None, "Anjali", None, "[Gift] Chocolate x1", "9:10 pm", None, True),
        ("thread_aria", "host_aria", "Aria", "AI", "Good evening! How was your day?", "8:01 pm", None, None),
        ("thread_neha", None, "Neha", None, "You: Hi Neha", "Yesterday", None, None),
        ("thread_sana", None, "Sana", None, "[Missed call] 2 min ago", "Mon", None, None),
    ]
    if not isinstance(threads, list) or len(threads) != len(expected_threads):
        fail("messages.inbox.threads: U19 has 6 threads")
        threads = []
    thread_keys = {"id", "hostId", "name", "badge", "preview", "time", "unread", "online"}
    for i, (thread_id, host_id, name, badge, preview, time, unread, online) in enumerate(expected_threads):
        if i >= len(threads):
            break
        thread = threads[i]
        label = f"messages.inbox.threads[{i}]"
        require_keys(thread, thread_keys, label)
        if not isinstance(thread, dict):
            continue
        actual = (
            thread.get("id"),
            thread.get("hostId"),
            thread.get("name"),
            thread.get("badge"),
            thread.get("preview"),
            thread.get("time"),
            thread.get("unread"),
            thread.get("online"),
        )
        if actual != (thread_id, host_id, name, badge, preview, time, unread, online):
            fail(f"{label}: expected U19 row {name!r}")
        register(ids, thread.get("id"), label)
        _ref_or_null(thread.get("hostId"), {k: "hosts" for k in hosts}, f"{label}.hostId")
        if host_id and isinstance(hosts.get(host_id), dict):
            if hosts[host_id].get("name") != name:
                fail(f"{label}: name does not match {host_id}")

    chat = messages.get("chat")
    require_keys(
        chat,
        {"hostId", "status", "safetyNote", "dayLabel", "lines", "freeNote", "why", "placeholder"},
        "messages.chat",
    )
    if isinstance(chat, dict):
        if chat.get("hostId") != "host_priya":
            fail("messages.chat.hostId must be host_priya")
        if chat.get("status") != "Online · replies in ~2 min":
            fail("messages.chat.status must match U20")
        if chat.get("safetyNote") != (
            "For your safety, never share phone numbers, UPI IDs or money outside the app."
        ):
            fail("messages.chat.safetyNote must match U20")
        if chat.get("dayLabel") != "Today 9:30 pm":
            fail("messages.chat.dayLabel must match U20")
        if chat.get("freeNote") != "3 free messages left · then 5 each" or chat.get("why") != "Why?":
            fail("messages.chat free-message line must match U20")
        if chat.get("placeholder") != "Type a message":
            fail("messages.chat.placeholder must match U20")
        lines = chat.get("lines")
        expected_lines = [
            ("chat_1", "text", True, "Hi Priya! Loved your intro clip", None, None),
            ("chat_2", "text", False, "Hi! Thank you. Where are you from?", None, None),
            ("chat_3", "text", True, "Delhi. Want to video call?", None, None),
            ("chat_4", "gift", True, "You sent Rose x1", "gift_rose", 1),
            ("chat_5", "text", False, "Thanks for the rose! Call me later?", None, None),
        ]
        if not isinstance(lines, list) or len(lines) != len(expected_lines):
            fail("messages.chat.lines: U20 has 5 lines")
            lines = []
        line_keys = {"id", "kind", "mine", "text", "giftId", "quantity"}
        for i, expected in enumerate(expected_lines):
            if i >= len(lines):
                break
            line = lines[i]
            label = f"messages.chat.lines[{i}]"
            require_keys(line, line_keys, label)
            if not isinstance(line, dict):
                continue
            actual = (
                line.get("id"),
                line.get("kind"),
                line.get("mine"),
                line.get("text"),
                line.get("giftId"),
                line.get("quantity"),
            )
            if actual != expected:
                fail(f"{label}: expected U20 line {expected[3]!r}")
            register(ids, line.get("id"), label)
            _ref_or_null(line.get("giftId"), gifts, f"{label}.giftId")

    sheet = messages.get("giftSheet")
    require_keys(
        sheet,
        {
            "title",
            "contextLine",
            "categories",
            "selectedCategory",
            "giftIds",
            "selectedGiftId",
            "quantities",
            "selectedQuantity",
            "topUp",
            "sendLabel",
        },
        "messages.giftSheet",
    )
    if isinstance(sheet, dict):
        if sheet.get("title") != "Send a gift" or sheet.get("contextLine") != "Thanks for the rose!":
            fail("messages.giftSheet title must match U21")
        if sheet.get("categories") != ["Popular", "Luxury", "Interactive", "VIP"]:
            fail("messages.giftSheet.categories must match U21")
        if sheet.get("selectedCategory") != "Popular" or sheet.get("selectedGiftId") != "gift_rose":
            fail("messages.giftSheet: U21 selects Popular and Rose")
        if sheet.get("giftIds") != [
            "gift_rose",
            "gift_star",
            "gift_chocolate",
            "gift_crown",
            "gift_kiss",
            "gift_fireworks",
            "gift_diamond_ring",
            "gift_daily_heart",
        ]:
            fail("messages.giftSheet.giftIds must be the U21 grid")
        for gift_id in sheet.get("giftIds") or []:
            if gift_id not in gifts:
                fail(f"messages.giftSheet.giftIds: unknown {gift_id!r}")
        if sheet.get("quantities") != [1, 10, 99] or sheet.get("selectedQuantity") != 10:
            fail("messages.giftSheet: U21 selects x10")
        if sheet.get("topUp") != "Top up" or sheet.get("sendLabel") != "Send · 100":
            fail("messages.giftSheet: U21 button is Send · 100")

    notes = messages.get("notifications")
    require_keys(notes, {"title", "readAll", "groups"}, "messages.notifications")
    if not isinstance(notes, dict):
        return
    if notes.get("title") != "Notifications" or notes.get("readAll") != "Read all":
        fail("messages.notifications: U42 title and Read all")
    groups = notes.get("groups")
    expected_groups = [
        (
            "TODAY",
            [
                ("notice_priya_online", "host_priya", "Priya is online now", "You follow her · tap to call", "2m"),
                ("notice_daily_reward", None, "Daily reward ready", "Day 3 streak · +15 Diamonds", "1h"),
                ("notice_level", None, "You reached Level 3", "New avatar frame unlocked", "5h"),
            ],
        ),
        (
            "EARLIER",
            [
                ("notice_diwali", None, "Diwali gift festival starts", "Limited gifts · 3 days", "2d"),
                ("notice_report", None, "Report update", "Action taken on your report #4821", "3d"),
                ("notice_recharge", None, "Recharge successful", "+1,200 Diamonds · ₹249", "4d"),
            ],
        ),
    ]
    if not isinstance(groups, list) or len(groups) != len(expected_groups):
        fail("messages.notifications.groups: U42 has TODAY and EARLIER")
        return
    item_keys = {"id", "hostId", "title", "detail", "time"}
    for i, (group_label, items) in enumerate(expected_groups):
        group = groups[i]
        label = f"messages.notifications.groups[{i}]"
        require_keys(group, {"label", "items"}, label)
        if not isinstance(group, dict) or group.get("label") != group_label:
            fail(f"{label}: expected {group_label}")
            continue
        rows = group.get("items")
        if not isinstance(rows, list) or len(rows) != len(items):
            fail(f"{label}: unexpected notice count")
            continue
        for j, expected in enumerate(items):
            item = rows[j]
            item_label = f"{label}.items[{j}]"
            require_keys(item, item_keys, item_label)
            if not isinstance(item, dict):
                continue
            actual = (
                item.get("id"),
                item.get("hostId"),
                item.get("title"),
                item.get("detail"),
                item.get("time"),
            )
            if actual != expected:
                fail(f"{item_label}: expected U42 notice {expected[2]!r}")
            register(ids, item.get("id"), item_label)
            _ref_or_null(item.get("hostId"), hosts, f"{item_label}.hostId")


def check_settings(settings, config: dict, hosts: dict, ids: dict[str, str]) -> None:
    """U45–U53 and U55. U54 copy lives on config.features.forceUpdate."""
    require_keys(
        settings,
        {"U45", "U46", "U47", "U48", "U49", "U50", "U51", "U52", "U53", "U55"},
        "settings",
    )
    if not isinstance(settings, dict) or not isinstance(config, dict):
        return
    screen = settings.get("U45")
    require_keys(screen, {"title", "sections"}, "settings.U45")
    if isinstance(screen, dict):
        if screen.get("title") != "Settings":
            fail("settings.U45.title must be Settings")
        sections = screen.get("sections")
        expected_sections = [
            (
                "CALLS",
                [
                    ("Camera on when call starts", True, None),
                    ("Microphone on when call starts", True, None),
                    ("Allow host call-backs", True, None),
                    ("Confirm price before calls", True, None),
                ],
            ),
            (
                "NOTIFICATIONS",
                [
                    ("Followed hosts online", True, None),
                    ("Offers and events", False, None),
                ],
            ),
            (
                "ACCOUNT",
                [
                    ("App language", None, "English"),
                    ("Privacy & data", None, None),
                    ("About", None, "v1.0.0"),
                    ("Sign out", None, None),
                    ("Delete account", None, None),
                ],
            ),
        ]
        if not isinstance(sections, list) or len(sections) != len(expected_sections):
            fail("settings.U45.sections: expected CALLS, NOTIFICATIONS, ACCOUNT")
        else:
            for i, (section_label, rows) in enumerate(expected_sections):
                section = sections[i]
                label = f"settings.U45.sections[{i}]"
                require_keys(section, {"label", "rows"}, label)
                if not isinstance(section, dict) or section.get("label") != section_label:
                    fail(f"{label}: expected {section_label}")
                    continue
                actual_rows = section.get("rows")
                if not isinstance(actual_rows, list) or len(actual_rows) != len(rows):
                    fail(f"{label}: unexpected rows")
                    continue
                for j, expected in enumerate(rows):
                    row = actual_rows[j]
                    row_label = f"{label}.rows[{j}]"
                    require_keys(row, {"label", "on", "trailing"}, row_label)
                    if isinstance(row, dict) and (
                        row.get("label"),
                        row.get("on"),
                        row.get("trailing"),
                    ) != expected:
                        fail(f"{row_label}: expected {expected[0]!r}")
        version = config.get("version")
        about = None
        if isinstance(sections, list) and len(sections) == 3:
            account = sections[2].get("rows") if isinstance(sections[2], dict) else None
            if isinstance(account, list) and len(account) >= 3 and isinstance(account[2], dict):
                about = account[2].get("trailing")
        if about != f"v{version}":
            fail("settings.U45 About trailing must be v plus config.version")

    edit = settings.get("U46")
    require_keys(
        edit,
        {
            "title",
            "save",
            "nicknameLabel",
            "dateOfBirthLabel",
            "aboutLabel",
            "languagesLabel",
            "add",
            "photoNote",
        },
        "settings.U46",
    )
    if isinstance(edit, dict) and (
        edit.get("title") != "Edit profile"
        or edit.get("save") != "Save"
        or edit.get("add") != "+ Add"
        or edit.get("photoNote")
        != "Photos are checked automatically. Nudity or contact details in profiles lead to a ban."
    ):
        fail("settings.U46 must match the edit-profile artboard")

    blocked = settings.get("U47")
    require_keys(
        blocked,
        {"title", "warning", "action", "emptyState", "users"},
        "settings.U47",
    )
    if isinstance(blocked, dict):
        if blocked.get("warning") != (
            "Blocked hosts can't call, message or see that you're online."
        ):
            fail("settings.U47.warning must match U47")
        if blocked.get("action") != "Unblock":
            fail("settings.U47.action must be Unblock")
        if blocked.get("emptyState") != 'Empty state: "No blocked users"':
            fail("settings.U47.emptyState must match U47, including the Empty state prefix")
        users = blocked.get("users")
        expected_users = [
            ("blocked_disha", None, "Disha", "D"),
            ("blocked_mona", None, "Mona", "M"),
        ]
        if not isinstance(users, list) or len(users) != len(expected_users):
            fail("settings.U47.users: U47 lists Disha and Mona")
        else:
            for i, expected in enumerate(expected_users):
                user = users[i]
                label = f"settings.U47.users[{i}]"
                require_keys(user, {"id", "hostId", "name", "initial"}, label)
                if isinstance(user, dict):
                    actual = (user.get("id"), user.get("hostId"), user.get("name"), user.get("initial"))
                    if actual != expected:
                        fail(f"{label}: expected {expected[2]!r}")
                    register(ids, user.get("id"), label)
                    _ref_or_null(user.get("hostId"), hosts, f"{label}.hostId")

    language = settings.get("U48")
    require_keys(
        language,
        {"title", "autoTranslate", "autoTranslateOn", "rows"},
        "settings.U48",
    )
    if isinstance(language, dict):
        if language.get("autoTranslate") != "Auto-translate chat messages":
            fail("settings.U48.autoTranslate must match U48")
        if language.get("autoTranslateOn") is not True:
            fail("settings.U48.autoTranslateOn must be true")
        expected_rows = [
            ("Same as phone", None, False),
            ("English", "en", True),
            ("हिन्दी", "hi", False),
            ("বাংলা", "bn", False),
            ("தமிழ்", "ta", False),
            ("తెలుగు", "te", False),
            ("मराठी", "mr", False),
            ("ಕನ್ನಡ", "kn", False),
        ]
        rows = language.get("rows")
        if not isinstance(rows, list) or len(rows) != len(expected_rows):
            fail("settings.U48.rows: expected the U48 language list")
        else:
            selected = []
            for i, expected in enumerate(expected_rows):
                row = rows[i]
                label = f"settings.U48.rows[{i}]"
                require_keys(row, {"label", "code", "selected"}, label)
                if isinstance(row, dict):
                    actual = (row.get("label"), row.get("code"), row.get("selected"))
                    if actual != expected:
                        fail(f"{label}: expected {expected[0]!r}")
                    if row.get("selected") is True:
                        selected.append(row.get("code"))
            if selected != ["en"]:
                fail("settings.U48: U48 selects English only")

    help_screen = settings.get("U49")
    require_keys(
        help_screen,
        {
            "title",
            "searchLabel",
            "searchPlaceholder",
            "topics",
            "stillNeedHelp",
            "replyTime",
            "chat",
            "email",
            "grievance",
        },
        "settings.U49",
    )
    if isinstance(help_screen, dict):
        if help_screen.get("searchPlaceholder") != "e.g. Diamonds not received":
            fail("settings.U49.searchPlaceholder must match U49")
        if help_screen.get("topics") != [
            "Diamonds not received after paying",
            "How call billing works",
            "Request a refund",
            "Calls not connecting",
            "Report a host",
            "Delete my account",
        ]:
            fail("settings.U49.topics must match U49")
        if help_screen.get("replyTime") != "Average reply time: 2 hours":
            fail("settings.U49.replyTime must match U49")
        if help_screen.get("grievance") != (
            "Grievance Officer: [NAME], [EMAIL] · IT Rules 2021"
        ):
            fail("settings.U49.grievance must keep the artboard placeholders")

    report = settings.get("U50")
    require_keys(
        report,
        {
            "hostId",
            "title",
            "privacy",
            "reasons",
            "detailsLabel",
            "details",
            "alsoBlock",
            "alsoBlockOn",
            "submit",
        },
        "settings.U50",
    )
    if isinstance(report, dict):
        if report.get("hostId") != "host_priya" or report.get("title") != "Report Priya":
            fail("settings.U50 must report Priya")
        _ref_or_null(report.get("hostId"), hosts, "settings.U50.hostId")
        if report.get("details") is not None:
            fail("settings.U50.details: the artboard field is empty")
        if report.get("alsoBlock") != "Also block Priya" or report.get("alsoBlockOn") is not True:
            fail("settings.U50.alsoBlock must be checked")
        reasons = report.get("reasons")
        expected_reasons = [
            ("Nudity or sexual content", False),
            ("Camera off / not showing face", True),
            ("Asked for money or contact details", False),
            ("Fake profile photos", False),
            ("Rude or abusive", False),
            ("Looks under 18", False),
        ]
        if not isinstance(reasons, list) or [
            (row.get("label"), row.get("checked")) if isinstance(row, dict) else None
            for row in reasons
        ] != expected_reasons:
            fail("settings.U50.reasons: U50 checks Camera off / not showing face")

    rate = settings.get("U51")
    require_keys(
        rate,
        {"backdropTitle", "tiles", "title", "subtitle", "starCount", "rating", "body"},
        "settings.U51",
    )
    if isinstance(rate, dict) and (
        rate.get("backdropTitle") != "Discover"
        or rate.get("tiles") != ["Host", "Host"]
        or rate.get("title") != "Rate Kinkstar Calls"
        or rate.get("subtitle") != "Google Play · public review"
        or rate.get("starCount") != 5
        or rate.get("rating") is not None
    ):
        fail("settings.U51 must match the review card; the stars have no selected score")

    about = settings.get("U52")
    require_keys(
        about,
        {"title", "appName", "versionLabel", "links", "operator"},
        "settings.U52",
    )
    if isinstance(about, dict):
        version_label = f"Version {config.get('version')} ({config.get('build')})"
        if about.get("versionLabel") != version_label or version_label != "Version 1.0.0 (100)":
            fail("settings.U52.versionLabel must be Version 1.0.0 (100)")
        if about.get("appName") != "Kinkstar Calls":
            fail("settings.U52.appName must be Kinkstar Calls")
        if about.get("links") != [
            "Terms of Service",
            "Privacy Policy",
            "Community Rules",
            "Refund Policy",
            "Grievance Redressal",
            "Open-source licences",
        ]:
            fail("settings.U52.links must match U52")
        if about.get("operator") != (
            "Operated by SparkBeta Tech, Cyber City, Utran, Surat, Gujarat, India"
        ):
            fail("settings.U52.operator must match U52")

    delete = settings.get("U53")
    require_keys(
        delete,
        {
            "title",
            "whatHappensTitle",
            "whatHappens",
            "balanceLine",
            "refund",
            "refundTail",
            "why",
            "reasons",
            "delete",
            "keep",
        },
        "settings.U53",
    )
    if isinstance(delete, dict):
        if delete.get("balanceLine") != "You have 120 Diamonds.":
            fail("settings.U53.balanceLine must match U53 and the profile balance")
        if delete.get("whatHappens") != (
            "Your profile, chats and call history are deleted within 30 days. "
            "Payment records are kept as required by law."
        ):
            fail("settings.U53.whatHappens must match U53")
        reasons = delete.get("reasons")
        if not isinstance(reasons, list) or [
            (row.get("label"), row.get("checked")) if isinstance(row, dict) else None
            for row in reasons
        ] != [
            ("Too expensive", False),
            ("Not enough hosts", False),
            ("Privacy concerns", False),
            ("Other", False),
        ]:
            fail("settings.U53.reasons: none of the four reasons is checked")
        if delete.get("delete") != "Delete my account" or delete.get("keep") != "Keep my account":
            fail("settings.U53 buttons must match U53")

    offline = settings.get("U55")
    require_keys(
        offline,
        {"title", "body", "retry", "maintenanceTitle", "maintenanceNote"},
        "settings.U55",
    )
    if isinstance(offline, dict):
        if offline.get("title") != "No internet" or offline.get("retry") != "Try again":
            fail("settings.U55 must be the no-internet screen")
        if offline.get("body") != "Check your connection. Your balance and chats are safe.":
            fail("settings.U55.body must match U55")
        note = offline.get("maintenanceNote")
        message = (
            config.get("features", {}).get("maintenance", {}).get("message", {}).get("en")
        )
        if not isinstance(note, str) or message not in note:
            fail("settings.U55.maintenanceNote must quote config.features.maintenance.message.en")
        if note != (
            '"We\'re upgrading Kinkstar Calls. Back at 4:00 am." '
            "Message and time come from Remote Config."
        ):
            fail("settings.U55.maintenanceNote must match U55")


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
    messages = load("messages.json")
    settings = load("settings.json")
    if any(
        doc is None
        for doc in (
            languages,
            user,
            hosts,
            wallet,
            ledger,
            calls,
            gifts,
            levels,
            earnings,
            config,
            messages,
            settings,
        )
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
    check_messages(messages, host_index, gift_index, ids)
    check_settings(settings, config, host_index, ids)

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
