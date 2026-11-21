# Kinkstar mock data

Phase 1 UI fixtures. Both apps read these files. `config.json` is the single app config (this local file now, Remote Config or the server later). There is one language list and one current user. Do not copy Rahul's level or VIP onto another file. `config.json` `features.vip` is only the VIP feature switch.

Run the checker from the repo root:

```bash
python3 mock/validate.py
```

## Pending decisions

These are stored as `null` or omitted. Do not invent numbers for them.

- **Host share %** is not decided. `levels.json` host bands and every `host_earnings.json` row leave `sharePercent` null.
- **Commission** is not decided and is not stored.
- **TDS** is not decided. `host_earnings.json` leaves `tds` null.
- **Free-call rule** is not decided. Rahul has 2 of 3 free matches left. `config.json` caps free matches at 3 per day, and still does not say when a match consumes one.
- **INR conversion** depends on the three money decisions above. Earnings rows leave `inrAmount` null. VIP prices below are INR list prices, not a Diamond conversion.

`userLevels[].diamonds` in `levels.json` is only a wealth-level threshold. It is not a rate.

## languages.json

The only language list. Every `languages` array in the other files uses these `code` values.

| code | name |
| --- | --- |
| hi | Hindi |
| en | English |
| bn | Bengali |
| ta | Tamil |
| te | Telugu |
| mr | Marathi |
| kn | Kannada |

Fields: `code`, `name`.

## user_profile.json

The current user for the user app and the host app.

| field | value / meaning |
| --- | --- |
| id | `user_rahul` |
| username | `Rahul_K` |
| avatar | `placeholder/avatars/rahul.png` |
| languages | codes from `languages.json` |
| level | `2` |
| levelProgress.current | `320` Diamonds of progress inside this level |
| levelProgress.required | `500` Diamonds to reach the next level |
| levelProgress.nextLevel | `3` |
| levelProgress.percent | `64` (`320 / 500`) |
| vip.active | `false` |
| diamondBalance | `120` spendable Diamonds. This is not level progress. |
| followsCount | hosts he follows. There is no follow-list file. |
| freeMatchesLeft | `2` |
| freeMatchesTotal | `3` (2 of 3 left) |
| freeMessages.left | `3` |
| freeMessages.priceAfter | `5` Diamonds per message after the free ones are used |

He still has free messages, so the ledger has no `message` row.

## hosts.json

Eight human hosts plus the AI companion. `callsCount` and `followers` are that host's lifetime totals, not a count of rows in `calls.json`.

Fields: `id`, `name`, `age`, `city`, `languages`, `rating`, `callsCount`, `followers`, `charmLevel`, `tier` (`A`, `B`, or `C`), `videoRatePerMin`, `voiceRatePerMin`, `status` (`online`, `busy`, `offline`), `isAI`.

**Priya** (`host_priya`) is the host on the profile, call, and call-back screens: 24, Lucknow, charm level 12, tier B, online, not AI. Tier B is 40 Diamonds/min video and 20 Diamonds/min voice. The same object is the only Priya record. Charm level 12 sits in the `11-15` host band.

Display rates for the other human tiers, so the list has a spread: tier A is 60/30, tier C is 20/10. Only tier B was specified.

**Aria** (`host_aria`) is the AI companion. `isAI` is true, `label` is `AI Companion`, and both rates are 15. `age`, `city`, `rating`, `charmLevel`, and `tier` are null. Human hosts do not have `label`.

## wallet.json

- `packs`: 6 Diamond packs. Fields `id`, `diamonds`, `bonus`, `priceINR`, `tags`. Tags are only `MOST_POPULAR` (`pack_700`) and `BEST_VALUE` (`pack_9000`).
- `firstRechargeOffer`: `expiresAt` (ISO-8601 UTC) and `validOnce` (`true`). No extra Diamond amount was specified, so none is stored.
- `paymentMethods`: `google_play`, `upi_razorpay_alt_billing`. Fields `id`, `label`.
- `vipPlans`: 1 week 129, 1 month 399, 3 months 999 INR. Fields `id`, `duration`, `priceINR`.
- `vipPerks`, on every plan: 15% off calls, 30 free Diamonds/day, priority match, unlimited free messages.

Rahul's `vip.active` is false. Buying VIP is priced in INR, and no Diamond price was specified, so the ledger has no `vip` row.

## gifts.json

Gift catalog. Fields: `id`, `name`, `price` (10–999 Diamonds), `category` (`popular`, `interactive`, `luxury`, `event`), `animation` (placeholder path).

| name | price | category |
| --- | --- | --- |
| Rose | 10 | popular |
| Wave | 20 | interactive |
| Sing for me | 99 | interactive |
| Dance | 199 | luxury |
| Diya | 49 | event |
| Crown | 999 | luxury |

The 8:42 call sends Rose and Sing for me.

## levels.json

`userLevels` is wealth levels 1–30. `diamonds` is the cumulative number required to reach that level, ending at 200000 on level 30. The gap from level 2 (500) to level 3 (1000) is 500, which matches `user_profile.levelProgress.required`. Level 30 is capped at 200000, so the last step is shorter than the one before it.

Perks: level 10 is `5% call discount`. Level 20 is `dedicated support`. Other levels have an empty `perks` list.

`hostLevels` bands: `1-5`, `6-10`, `11-15`, `16+`. Fields `band`, `fromLevel`, `toLevel` (`null` on `16+`), `sharePercent`. Every `sharePercent` is null until host share is decided.

## calls.json

Rahul's calls with Priya. Same host id as `hosts.json`. Fields: `id`, `hostId`, `userId`, `type` (`video` or `voice`), `startedAt`, `durationSec`, `ratePerMin`, `diamondsCharged`, `giftsCount`, `status` (`completed`, `missed`, `dropped`, `refunded`).

| id | what it is for |
| --- | --- |
| `call_priya_842` | Call screen. Video, 8:42 (522s) at 40/min, 349 Diamonds, 2 gifts, completed. |
| `call_priya_missed` | Call-back screen. Missed video, no charge. |
| `call_priya_voice` | Completed voice call, 606s at 20/min = 202 Diamonds. |
| `call_priya_dropped` | Dropped video, 30s at 40/min = 20 Diamonds. |
| `call_priya_refunded` | 60s video charged 40, then refunded in the ledger. |

`ratePerMin` is the host's video or voice rate. Other sample calls divide evenly (`durationSec * ratePerMin / 60`). The 8:42 call does not: `522 * 40 / 60` is 348 exactly. Phase 1 stores the specified rounded per-second charge of **349** on this call and on its ledger row so the screens match each other.

## ledger.json

Append-only Diamond history for Rahul. File order is the order entries were applied. Fields: `id`, `type` (`recharge`, `call`, `gift`, `message`, `vip`, `bonus`, `refund`), `amount` (signed), `balanceAfter`, `createdAt`, `refId`, `meta`.

`refId` points at a pack, a call, or the ledger row a refund reverses. Gift `meta.giftId` points at `gifts.json`. Call `meta` repeats host, duration, and rate. The running balance starts at 0 and ends at 120:

`700 + 100 − 40 + 40 − 20 − 202 − 10 − 99 − 349 = 120`

The two gifts (Rose 10, Sing for me 99) are inside `call_priya_842`, before the call charge is posted at hangup. The single refund (`led_04`) reverses `led_03`, the refunded call, in full.

## host_earnings.json

Priya's view of the same calls. `entries[].callId` is exactly the id set in `calls.json`.

Fields: `id`, `callId`, `userDiamonds` (the user-side call charge, same as `calls.diamondsCharged`, including a charge that was later refunded), `giftUserDiamonds` (user-side gifts on that call; 109 on the 8:42 call), `inrAmount`, `sharePercent`, `tds`. The last three are null.

## config.json

The only app config. Prices stay in `wallet.json`. This file points at pack ids and does not repeat `diamonds`, `bonus`, or `priceINR`.

| field | meaning |
| --- | --- |
| version | App version string. Sample is `1.0.0`. |
| assetBaseUrl | Placeholder CDN origin (`https://cdn.example.com/kinkstar/`) for host photos and gift animations. The app prefixes this onto those asset paths. |
| strings | Copy keyed by screen id, then by language code. Sample keys: `U01_title` and `U01_subtitle` (Discover), `U32_title` and `U32_subtitle` (Recharge), `U48_lowBalance` (call screen, tied to the 60s low-balance warning). Every string has all seven codes from `languages.json`. |
| rechargePackIds | Pack ids in `wallet.json` order: `pack_100`, `pack_300`, `pack_700`, `pack_1500`, `pack_4000`, `pack_9000`. |
| homeBanners | `id`, `imageUrl` (absolute URL on `assetBaseUrl`), `deeplink`, `startAt`, `endAt`, `serverDriven` (`true`). `banner_recharge` opens `kinkstar://recharge`. `banner_discover` opens `kinkstar://discover`. |
| tabs | Bottom tabs in order: Discover, Match, Live, Messages, Me. Fields `id`, `label`, `enabled`. All five are enabled in this sample. |
| features.quickMatch | `true` |
| features.liveRooms | `true` |
| features.aiCompanion | `true` (Aria) |
| features.vip | `true` means VIP plans can be shown. It is not Rahul's VIP state. |
| features.chatPaidMessages | `true`. The price after free messages is still `user_profile.freeMessages.priceAfter`. |
| features.forceUpdate.minVersion | `1.0.0`. This build is not below it. |
| features.maintenance | `on` is `false`. `message` is copy for every language code, used only when maintenance is on. |
| limits.freeMatchesPerDay | `3` |
| limits.freeMessagesPerHost | `3` |
| limits.lowBalanceWarningSec | `60` |
