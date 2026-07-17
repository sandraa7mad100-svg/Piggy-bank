# Piggy Bank 🐷

A fun, colorful Flutter app that teaches kids saving, spending, budgeting, and the
difference between needs and wants — with an AI buddy ("Penny") to help along the way.

This is a production-architected app, not a UI prototype: clean architecture, offline-first
local storage, a Firebase backend that's fully optional to get started, and a
provider-agnostic AI assistant layer.

## Status at a glance

| Area | Depth |
|---|---|
| Splash, Onboarding, Auth (email/password, Google, Kid Mode) | Fully built |
| Home + Piggy Bank Balance | Fully built |
| Spending & Income Tracker (charts, needs/wants, search/filter) | Fully built |
| AI Chat Assistant (Penny) | Fully built, provider-agnostic |
| Savings Goals, Statistics, Achievements, Rewards, Notifications, Settings, Profile | Built and functional, lighter visual polish than the set above |
| Firebase (Auth/Firestore/Storage/FCM/Crashlytics/Analytics) | Fully wired, gracefully falls back to local/offline mode until you configure a real project |
| AI providers (OpenAI/Gemini/Claude) | Fully wired behind one interface, falls back to a local rule-based assistant until you add an API key |
| i18n (easy_localization) | Infrastructure + language switcher wired up; only a representative subset of strings are translated (see `assets/translations`) — most UI text is still hardcoded English and would need a pass to route every string through `.tr()` |
| Tests | Unit tests (core utils, entities, providers with fakes, mock AI), widget tests (key reusable widgets + a real feature widget), one integration smoke test |

Nothing here is a placeholder screen — every screen renders real data and works end to end
against local storage, even with zero configuration.

---

## Architecture

Feature-first Clean Architecture:

```
lib/
  core/                   # Cross-cutting: theme, DI, router, storage, network, utils
  features/
    <feature>/
      domain/             # Entities, repository interfaces, use cases — no Flutter imports
      data/                # Models, data sources (local/remote), repository implementations
      presentation/        # Riverpod providers, pages, widgets
```

- **State management**: Riverpod (`flutter_riverpod`), hand-written providers (no code
  generation, to keep the build fast and dependency-light).
- **Navigation**: GoRouter, with a `redirect` driven by auth state + onboarding-seen flag.
- **DI**: GetIt, configured once in `core/di/injection.dart`.
- **Local storage**: Hive (offline-first source of truth for transactions/goals/chat/
  notifications) with hand-written `TypeAdapter`s, plus `flutter_secure_storage` for
  anything sensitive (auth tokens, local password hashes).
- **Networking**: Dio, used for the AI provider HTTP calls.
- **Charts**: `fl_chart` — savings progress, monthly spending, weekly spending, category
  breakdown, and goal completion.

### Why everything works without a backend

Every Firebase-backed repository (`AuthRepositoryImpl` today; the pattern generalizes) checks
`FirebaseBootstrap.isAvailable` — set once at startup after attempting
`Firebase.initializeApp`. If it's `false` (no real project configured yet), the repository
transparently falls back to a local implementation instead of crashing:

- Auth falls back to on-device accounts, with salted+hashed passwords in secure storage
  (never plaintext) and cached profiles in Hive.
- The AI assistant falls back to `MockAiProvider`, a rule-based responder that still reads
  real financial data (balance, weekly spending, active goal) to answer questions like
  "how much have I saved?" or "what's the difference between needs and wants?".

This means you can `flutter run` immediately and use every screen — sign up, log
transactions, set goals, chat with Penny — before ever touching Firebase or an AI API key.

---

## Getting started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Environment configuration

```bash
cp .env.example .env
```

Leave everything blank to run in local/offline/mock mode, or fill in:

```
AI_PROVIDER=openai        # mock | openai | gemini | claude
AI_MODEL=gpt-4o-mini
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...
CLAUDE_API_KEY=...
```

`.env` is gitignored — never commit real keys.

### 3. Run it

```bash
flutter run
```

That's it — no Firebase project required for local development.

---

## Firebase setup (optional, for a real backend)

1. Create a Firebase project at https://console.firebase.google.com.
2. Enable **Authentication** (Email/Password, Google, Anonymous), **Cloud Firestore**,
   **Storage**, **Cloud Messaging**, **Crashlytics**, and **Analytics**.
3. Install the FlutterFire CLI and generate real config:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This overwrites the placeholder `lib/firebase_options.dart` with your real project's
   config and adds `android/app/google-services.json` /
   `ios/Runner/GoogleService-Info.plist`.
4. Deploy the security rules in `firebase/`:
   ```bash
   firebase deploy --only firestore:rules,storage:rules
   ```
   (`firebase.json` at the repo root already points at `firebase/firestore.rules` and
   `firebase/storage.rules`.)
5. For Google Sign-In on Android, add your SHA-1/SHA-256 fingerprints in the Firebase
   console; on iOS, add the reversed client ID URL scheme to `Info.plist`.

Once `flutterfire configure` has run, `FirebaseBootstrap.isAvailable` becomes `true`
automatically and every repository starts using the real backend — no other code changes
needed.

### Firestore data model

```
users/{uid}
  { id, email, displayName, isChildMode, currency, createdAt }
  transactions/{transactionId}
  goals/{goalId}
  chatMessages/{messageId}
  notifications/{notificationId}   (server/Cloud-Function-written only)
```

See `firebase/firestore.rules` — every path is owner-only (`request.auth.uid == uid`),
denied by default otherwise.

---

## AI Assistant

The assistant is abstracted behind `AiProvider` (`lib/features/ai_chat/data/providers/`):

- `MockAiProvider` — offline, rule-based, zero configuration.
- `OpenAiProvider`, `GeminiAiProvider`, `ClaudeAiProvider` — real LLM backends, selected via
  `.env`'s `AI_PROVIDER` and picked up automatically by `AiProviderFactory`.

All four share one system persona (`kAiSystemPrompt`) and are handed the same
`FinancialSnapshot` (balance, weekly income/spending, needs vs. wants totals, top category,
active goal) so replies are grounded in the child's real data regardless of which backend
answers. Swapping providers is a one-line `.env` change — no UI or repository code changes.

---

## Testing

```bash
flutter test                                   # unit + widget tests
flutter test integration_test/app_test.dart -d <device-id>   # end-to-end, needs a device/emulator
```

- `test/unit/` — pure logic: `Result`, `Validators`, entities, Riverpod providers (against
  in-memory fakes, no Hive/Firebase involved), the mock AI provider's rule-based replies.
- `test/widget/` — reusable widgets (`PrimaryButton`, `EmptyState`) and a real feature widget
  (`TransactionTile`).
- `integration_test/app_test.dart` — boots the real app (Hive, Firebase bootstrap, DI,
  EasyLocalization) exactly like `main.dart` does, and checks it reaches past the splash
  screen. Requires a connected device/emulator, since Hive/secure-storage need real platform
  channels.

---

## Project structure

```
piggy_bank/
  android/, ios/, web/, ...   # Flutter platform folders (from `flutter create`)
  assets/
    images/, icons/            # (empty placeholders — drop in real art/icons)
    translations/              # en.json, ar.json (easy_localization)
  firebase/
    firestore.rules
    storage.rules
    firestore.indexes.json
  lib/
    core/                       # theme, DI, router, storage, network, services, widgets
    features/                   # one folder per feature, see Architecture above
    app.dart, main.dart, firebase_options.dart
  test/
    unit/, widget/
  integration_test/
  firebase.json
  .env.example
  pubspec.yaml
```

## Known gaps / where to go next

- **Fonts**: typography uses `google_fonts` (Baloo 2 + Nunito), fetched from Google's CDN
  and cached on first use. For guaranteed offline first-launch typography, bundle the `.ttf`
  files under `assets/fonts/` and declare them in `pubspec.yaml` instead.
- **i18n coverage**: the easy_localization pipeline is fully wired (language switcher in
  Settings, `en.json`/`ar.json`), but only a representative set of strings has been routed
  through `.tr()`. Full coverage means replacing the remaining hardcoded `Text('...')`
  literals across screens.
- **Illustrations/Lottie**: animations are built with Flutter's own animation APIs
  (`flutter_animate`, `TweenAnimationBuilder`, `Hero`) rather than bundled Lottie files —
  there are no hand-authored `.json` animation assets included.
- **Cloud sync**: transactions/goals/chat are Hive-first by design (an allowance app
  shouldn't lose data to a flaky connection). The Firestore schema and rules are ready for a
  sync layer, but the repositories currently write to Hive only — wiring bidirectional sync
  is the natural next step once you have a real Firebase project.
