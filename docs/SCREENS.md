# Screen checklist

Status is `todo` until the screen is built. Routes are planned until then. `/` is still the themed placeholder. Onboarding routes are live.

U44 does not exist. The user set is U01–U43 and U45–U55 (54 screens). The host set is P01–P43 (43 screens).

Reference PNGs are 820×1728. That is the 390×844 phone plus a 10px bezel (`box-shadow: 0 0 0 10px`) at 2×. Corners of the PNG are the artboard colour `#E7E3EC` because the phone is rounded.

`config.json` string ids do not follow these screen ids. In that file `U01_title` is "Discover" and `U48_lowBalance` is the low-balance line. The design's U01 is the splash and U48 is App language. Do not rename either side in this PR.

## User app

| ID | Name | Artboard | Route | PR group | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| U01 | Splash | 01 Onboarding A | `/splash` | Onboarding | done | Radial splash behind the mark. |
| U02 | Choose language (first run) | 01 Onboarding A | `/onboarding/language` | Onboarding | done | Languages come from `languages.json`. Kannada is in that file and not on this picker. |
| U03 | Welcome / Login | 01 Onboarding A | `/welcome` | Onboarding | done | Hero image is a network asset, not bundled. The capture shows the design placeholder. |
| U04 | Phone number | 01 Onboarding A | `/onboarding/phone` | Onboarding | done | |
| U05 | OTP verification | 01 Onboarding A | `/onboarding/otp` | Onboarding | done | Six-cell code. |
| U06 | Country code picker | 02 Onboarding B | `/onboarding/country` | Onboarding | done | Country rows are the artboard list. They are not in `mock/`. |
| U07 | Age check & consent | 02 Onboarding B | `/onboarding/age` | Onboarding | done | |
| U08 | Profile setup | 02 Onboarding B | `/onboarding/profile` | Onboarding | done | Nickname and spoken languages come from `user_profile.json`. Interest chips are the artboard set. |
| U09 | Permissions primer | 02 Onboarding B | `/onboarding/permissions` | Onboarding | done | |
| U10 | First-run guide (coach marks) | 02 Onboarding B | `/onboarding/guide` | Onboarding | done | Coach marks over Discover. The discover tab label in config is Home, matching the artboard. The page title is still `U01_title` (Discover). |
| U11 | Home (Discover) | 03 Discover | `/discover` | Discover | todo | Host photos load from the network. |
| U12 | Filter sheet | 03 Discover | `/discover/filters` | Discover | todo | |
| U13 | Host profile | 03 Discover | `/hosts/:hostId` | Discover | todo | |
| U14 | Photo & intro-clip viewer | 03 Discover | `/hosts/:hostId/media` | Discover | todo | Full-bleed black viewer. |
| U15 | Quick Match (idle) | 04 Match & Live | `/match` | Match & Live | done | Balance, free matches, and Hindi/English come from the profile. The orbit and the 218-host line are artboard copy. |
| U16 | Match found (swipe card) | 04 Match & Live | `/match/found` | Match & Live | done | Riya is not in `hosts.json`. The card is artboard copy. |
| U17 | Live rooms list (V2) | 04 Match & Live | `/live` | Match & Live | todo | V2. Room grid. |
| U18 | Live room with PK battle (V2) | 04 Match & Live | `/live/:roomId` | Match & Live | todo | V2. Split PK bar (crimson / `#2563EB`), chat stack, gift and private-call buttons. |
| U19 | Messages inbox (Chats / Calls / Following) | 05 Messages | `/messages` | Messages | todo | |
| U20 | Chat conversation | 05 Messages | `/messages/:threadId` | Messages | todo | |
| U21 | Chat gift sheet | 05 Messages | `/messages/:threadId/gifts` | Messages | todo | |
| U22 | Me tab | 09 Me & engagement | `/me` | Me & engagement | todo | |
| U23 | Pre-call confirm sheet | 06 Calls A | `/call/confirm` | Calls | todo | |
| U24 | Outgoing call (connecting) | 06 Calls A | `/call/outgoing` | Calls | todo | Pulsing rings: 12px and 26px crimson shadows. |
| U25 | Incoming call from a real host | 06 Calls A | `/call/incoming` | Calls | todo | |
| U26 | In video call | 07 Calls B | `/call/video` | Calls | todo | Full-bleed video, self PIP, glass chips, interactive row, five round controls. |
| U27 | In-call gift panel | 07 Calls B | `/call/video/gifts` | Calls | todo | Gift sheet over the live call. Four-up grid and combo row. Does not end the call. |
| U28 | Low balance – top up without ending call | 07 Calls B | `/call/top-up` | Calls | todo | Pay sheet over the live call. |
| U29 | Voice call | 07 Calls B | `/call/voice` | Calls | todo | |
| U30 | Call summary & rate host | 07 Calls B | `/call/summary` | Calls | todo | |
| U31 | All hosts busy (real queue) | 06 Calls A | `/call/queue` | Calls | todo | |
| U32 | Diamond store | 08 Wallet | `/wallet` | Wallet | todo | Pack prices stay in `wallet.json` (PR #1). Config only lists pack ids. |
| U33 | Payment method chooser | 08 Wallet | `/wallet/pay` | Wallet | todo | |
| U34 | Recharge success | 08 Wallet | `/wallet/success` | Wallet | todo | |
| U35 | First-recharge offer popup | 08 Wallet | `/wallet/offer` | Wallet | todo | |
| U36 | VIP membership | 08 Wallet | `/wallet/vip` | Wallet | todo | |
| U37 | Wallet history (Recharges / Spending) | 08 Wallet | `/wallet/history` | Wallet | todo | |
| U38 | My level | 09 Me & engagement | `/me/level` | Me & engagement | todo | |
| U39 | Daily check-in | 09 Me & engagement | `/me/check-in` | Me & engagement | todo | 7-day grid. Day 7 spans two columns. |
| U40 | Events & leaderboard | 09 Me & engagement | `/me/events` | Me & engagement | todo | Event banner is server-driven. |
| U41 | Refer & earn | 09 Me & engagement | `/me/refer` | Me & engagement | todo | Invite code uses letter-spacing 2px. |
| U42 | Notifications centre | 05 Messages | `/notifications` | Messages | todo | |
| U43 | AI companion profile (labelled AI) | 09 Me & engagement | `/ai/:hostId` | Me & engagement | todo | Must stay labelled AI. |
| U45 | Settings | 10 Settings A | `/settings` | Settings | todo | |
| U46 | Edit profile | 10 Settings A | `/settings/profile` | Settings | todo | |
| U47 | Blocked users | 10 Settings A | `/settings/blocked` | Settings | todo | |
| U48 | App language | 10 Settings A | `/settings/language` | Settings | todo | |
| U49 | Help & feedback | 10 Settings A | `/settings/help` | Settings | todo | |
| U50 | Report a host | 11 Settings B | `/settings/report` | Settings | todo | |
| U51 | Rate the app (official review card) | 11 Settings B | `/settings/rate` | Settings | todo | Google Play card uses `#202124` / `#5F6368` / `#9AA0A6`. |
| U52 | About & legal | 11 Settings B | `/settings/about` | Settings | todo | |
| U53 | Delete account | 11 Settings B | `/settings/delete-account` | Settings | todo | |
| U54 | Force update (remote-config driven) | 11 Settings B | `/force-update` | Settings | todo | `features.forceUpdate.minVersion` in config. |
| U55 | No connection / maintenance | 11 Settings B | `/offline` | Settings | todo | `features.maintenance` in config. |

User PR order: Onboarding (U01–U10), Discover (U11–U14), Calls (U23–U31), Wallet (U32–U37), Messages (U19–U21, U42), Match & Live (U15–U18), Me & engagement (U22, U38–U43), Settings (U45–U55).

## Host app

| ID | Name | Artboard | Route | PR group | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| P01 | Splash | 01 Partner onboarding | `/splash` | Partner onboarding | todo | |
| P02 | Choose language | 01 Partner onboarding | `/onboarding/language` | Partner onboarding | todo | |
| P03 | Phone login | 01 Partner onboarding | `/onboarding/phone` | Partner onboarding | todo | |
| P04 | OTP | 01 Partner onboarding | `/onboarding/otp` | Partner onboarding | todo | |
| P05 | Agency or referral code | 01 Partner onboarding | `/onboarding/agency` | Partner onboarding | todo | |
| P06 | Basic information | 02 Partner application | `/apply/info` | Partner application | todo | |
| P07 | Profile photos | 02 Partner application | `/apply/photos` | Partner application | todo | Photos are network assets. |
| P08 | Record intro video | 02 Partner application | `/apply/intro` | Partner application | todo | Camera preview, dashed face oval, record / stop. |
| P09 | ID verification (KYC) | 02 Partner application | `/apply/kyc` | Partner application | todo | |
| P10 | Live selfie check | 02 Partner application | `/apply/selfie` | Partner application | todo | Oval camera preview and liveness steps (look straight, turn left, blink). |
| P11 | Payout details (UPI / bank) | 03 Partner approval | `/apply/payout` | Partner approval | todo | |
| P12 | Host agreement | 03 Partner approval | `/apply/agreement` | Partner approval | todo | |
| P13 | Application status | 03 Partner approval | `/apply/status` | Partner approval | todo | |
| P14 | Training & rules quiz | 03 Partner approval | `/apply/training` | Partner approval | todo | |
| P15 | Home dashboard (offline) | 04 Going online | `/home` | Going online | todo | |
| P16 | Pre-check before going online | 04 Going online | `/go-online/check` | Going online | todo | Camera preview plus a checklist. |
| P17 | Beauty filter settings | 04 Going online | `/go-online/beauty` | Going online | todo | Smooth, brighten, face slim, and eyes controls over the preview. The design draws them as progress bars, not native sliders. |
| P18 | Online and waiting for calls | 04 Going online | `/go-online/waiting` | Going online | todo | Live camera preview while waiting, plus the guarantee bar. |
| P19 | Incoming call | 05 Partner calls | `/call/incoming` | Partner calls | todo | |
| P20 | In call (host view) | 05 Partner calls | `/call` | Partner calls | todo | |
| P21 | Call summary & rate user | 05 Partner calls | `/call/summary` | Partner calls | todo | |
| P22 | Callers list (call back real users) | 05 Partner calls | `/callers` | Partner calls | todo | |
| P23 | Calling a user back | 05 Partner calls | `/callers/dial` | Partner calls | todo | |
| P24 | Messages inbox | 06 Partner messages | `/messages` | Partner messages | todo | |
| P25 | Chat with a user | 06 Partner messages | `/messages/:threadId` | Partner messages | todo | |
| P26 | Quick-reply templates | 06 Partner messages | `/messages/templates` | Partner messages | todo | |
| P27 | Announcements & notifications | 06 Partner messages | `/announcements` | Partner messages | todo | |
| P28 | Earnings overview | 07 Partner earnings | `/earnings` | Partner earnings | todo | Seven-bar daily chart. Bar heights are layout; amounts come from host earnings data. `sharePercent`, `tds`, and `inrAmount` are null until those rules are decided. |
| P29 | Earnings transactions | 07 Partner earnings | `/earnings/transactions` | Partner earnings | todo | |
| P30 | Withdraw | 07 Partner earnings | `/earnings/withdraw` | Partner earnings | todo | |
| P31 | Payout history & statements | 07 Partner earnings | `/earnings/payouts` | Partner earnings | todo | |
| P32 | Host level & income share | 07 Partner earnings | `/earnings/level` | Partner earnings | todo | Share percent is unset. |
| P33 | Schedule & peak shifts | 08 Partner performance | `/schedule` | Partner performance | todo | |
| P34 | Online-hours log | 08 Partner performance | `/hours` | Partner performance | todo | |
| P35 | Quality score & strikes | 08 Partner performance | `/quality` | Partner performance | todo | |
| P36 | Interactive gifts setup | 08 Partner performance | `/gifts` | Partner performance | todo | |
| P37 | Me tab | 09 Partner profile & support | `/me` | Partner profile & support | todo | |
| P38 | Profile & media manager | 09 Partner profile & support | `/me/media` | Partner profile & support | todo | |
| P39 | Help & host support | 09 Partner profile & support | `/help` | Partner profile & support | todo | |
| P40 | Safety centre | 09 Partner profile & support | `/safety` | Partner profile & support | todo | |
| P41 | Settings | 09 Partner profile & support | `/settings` | Partner profile & support | todo | |
| P42 | Invite hosts & agency | 09 Partner profile & support | `/invite` | Partner profile & support | todo | Invite code uses letter-spacing 2px. |
| P43 | Leave Kinkstar | 09 Partner profile & support | `/leave` | Partner profile & support | todo | |

Host PR order follows the artboards: Partner onboarding, Partner application, Partner approval, Going online, Partner calls, Partner messages, Partner earnings, Partner performance, Partner profile & support.

The sample `config.json` tabs are the user app's (Home, Match, Live, Messages, Me). The discover tab id is still `discover`. Host tab labels are not in that file yet.
