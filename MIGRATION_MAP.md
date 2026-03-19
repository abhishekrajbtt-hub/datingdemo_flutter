# DatingDemo Migration Map (Android -> Flutter)

This file tracks migration from the native Android app (`DatingDemo`) to Flutter (`datingdemo_flutter`).

## Legend

- Status:
  - `DONE` = Implemented in Flutter
  - `PARTIAL` = Basic scaffold done, feature incomplete
  - `TODO` = Not yet started
- Priority:
  - `P0` Critical launch path
  - `P1` Core feature
  - `P2` Nice-to-have / enhancement

## Foundation

| Area | Android Reference | Flutter Target | Priority | Status | Notes |
|---|---|---|---|---|---|
| App bootstrap + Firebase init | `MainActivity.kt`, `DatingDemoApp.kt` | `lib/main.dart` | P0 | DONE | Firebase initialized via `firebase_options.dart` |
| Auth state routing | `MainActivity.kt` route logic | `AuthGate` in `lib/main.dart` | P0 | DONE | Logged-in -> Home, logged-out -> Auth |
| Base app shell (tabs) | `AppScaffold.kt` | `lib/features/home/home_screen.dart` | P0 | PARTIAL | Tabs exist; Matches/Chat/Profile are placeholders |

## Authentication

| Area | Android Reference | Flutter Target | Priority | Status | Notes |
|---|---|---|---|---|---|
| Google Sign-In (login/signup) | `GoogleAuthHelper.kt`, auth screens | `lib/features/auth/auth_service.dart` + `auth_screen.dart` | P0 | DONE | Firebase auth session created on success |
| Email OTP send | `AuthMethodScreen.kt`, `EmailOtpScreen.kt` | `AuthService.sendEmailOtp()` | P0 | DONE | Calls Cloud Function `sendEmailOtp` |
| Email OTP verify | Same | `AuthService.verifyEmailOtp()` | P0 | PARTIAL | Verification works; session linkage flow to finalize |
| Phone OTP login | `OtpLoginScreen.kt` | `lib/features/auth/*` | P0 | TODO | Not yet started in Flutter |
| Sign-out | App top-bar/menu | `AuthService.signOut()` | P0 | DONE | Works via AppBar action |

## Profile

| Area | Android Reference | Flutter Target | Priority | Status | Notes |
|---|---|---|---|---|---|
| Profile model/service | `ProfileModel.kt`, profile helpers | `lib/features/profile/profile_service.dart` | P0 | PARTIAL | Basic upsert + exists check only |
| Multi-step profile setup | `ProfileSetUpScreen.kt` + steps files | `lib/features/profile/setup/*` | P0 | TODO | Next implementation block |
| Profile preview (self) | `ProfilePreviewScreen.kt` | `lib/features/profile/preview/*` | P1 | TODO | Pending |
| Other user profile view | `OtherProfileScreen.kt` | `lib/features/profile/other_profile/*` | P1 | TODO | Pending |
| Interests/lifestyle text parity | `ProfilePreviewScreen.kt` | Profile UI migration | P1 | TODO | Preserve same typography and labels |

## Discover / Matching

| Area | Android Reference | Flutter Target | Priority | Status | Notes |
|---|---|---|---|---|---|
| Discover list stream | `MatchEngine.kt`, `SwipeScreen.kt` | `lib/features/discover/discover_service.dart` + `discover_screen.dart` | P0 | PARTIAL | Reads `profiles` stream, basic card list |
| Swipe actions / like-pass | `SwipeActionBar.kt`, repositories | `lib/features/discover/swipe/*` | P0 | TODO | Not started |
| Match generation and persistence | `LikeRepository.kt`, `MatchEngine.kt` | `lib/features/match/data/*` | P0 | TODO | Not started |
| Unmatch confirmation | `MatchListScreen.kt`, `AppScaffold.kt` | `lib/features/match/ui/*` | P1 | TODO | Not started |

## Matches / Chat

| Area | Android Reference | Flutter Target | Priority | Status | Notes |
|---|---|---|---|---|---|
| Match list UI | `MatchListScreen.kt` | `lib/features/match/match_list_screen.dart` | P0 | TODO | Tab currently placeholder |
| Chat screen core | `ui/chat/ChatScreen.kt` | `lib/features/chat/chat_screen.dart` | P0 | TODO | Tab currently placeholder |
| Auto-scroll behavior | Android chat logic | Flutter chat message list behavior | P1 | TODO | Preserve near-bottom only auto-scroll |
| GIF picker fixed list | Android chat GIF logic | Flutter GIF picker service/UI | P1 | TODO | Must use approved list only |
| Message reactions/media | Android chat + media funcs | Flutter chat modules | P1 | TODO | Pending |

## Media / Storage

| Area | Android Reference | Flutter Target | Priority | Status | Notes |
|---|---|---|---|---|---|
| Profile photo upload | `MediaPicker.kt`, `MediaGrid.kt` | `lib/features/media/profile_photo_service.dart` | P0 | TODO | Must match storage path/rules |
| Camera + crop flow | Android camera/UCrop flow | Flutter image_picker + cropper flow | P0 | TODO | Pending |
| Verification note/dialog text | Profile media UI | Flutter profile media UI | P1 | TODO | Keep final approved wording |

## Cloud Functions / Reporting / Moderation

| Area | Android Reference | Flutter Target | Priority | Status | Notes |
|---|---|---|---|---|---|
| Report profile/message email | `notifyReportEmail` usage | `lib/features/reporting/report_service.dart` | P0 | TODO | Must send to Contact Us email |
| Email OTP mode handling | `functions/index.js` | Flutter function payload parity | P0 | DONE | Sends `mode` as `login/signup` |
| Photo/chat moderation calls | Existing functions | Flutter moderation service | P1 | TODO | Pending |

## Settings / Compliance / Other

| Area | Android Reference | Flutter Target | Priority | Status | Notes |
|---|---|---|---|---|---|
| Settings page | `SettingsScreen.kt` | `lib/features/settings/settings_screen.dart` | P1 | TODO | Pending |
| Terms + DPDP consent | related screens | `lib/features/legal/*` | P1 | TODO | Pending |
| Landing screen visuals | `LandingScreen.kt`, components | `lib/features/landing/*` | P2 | TODO | Optional for logged-out UX |
| Background music behavior | profile screens | Flutter audio lifecycle handling | P2 | TODO | Pending |

## Recommended Build Order

1. `P0` Profile setup module (multi-step, save to Firestore)
2. `P0` Phone OTP auth
3. `P0` Discover swipe + likes + match persistence
4. `P0` Matches list + Chat core
5. `P0` Media upload/crop/profile-photo selection
6. `P0` Reporting email flow
7. `P1/P2` polish, legal, animation parity

## Current Sprint (Now)

- [x] Firebase init + auth gate
- [x] Google sign-in
- [x] Email OTP function calls (send/verify)
- [x] Base tab shell
- [x] Discover Firestore basic stream/list
- [ ] Profile setup flow (next)

