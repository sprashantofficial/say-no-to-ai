# No-AI Coding Gym

Android-first Flutter app for structured Java interview problem-solving practice.

> **Important:** This app is a thinking simulator, not a compiler.

## Features

- Dark-only Material 3 UI
- Daily challenge + 10-problem catalog from Firebase Realtime Database
- Submission flow with structured fields and validation
- Staged reveal flow (Hint 1 → Hint 2 → Final Approach → Sample Java Code)
- AdMob monetization (banner + interstitial)
- One-time premium unlock via in-app purchase (ad removal)
- Local streak and usage tracking with SharedPreferences

---

## Project Structure

```text
lib/
 ├── core/
 │     ├── theme/
 │     ├── utils/
 │     ├── services/
 │     └── ads/
 ├── features/
 │     ├── home/
 │     ├── problem/
 │     ├── submission/
 │     ├── reveal/
 │     └── premium/
 ├── data/
 │     ├── models/
 │     ├── repositories/
 │     └── datasources/
 ├── shared/
 └── main.dart
```

---

## Prerequisites

Install these before running:

1. **Flutter SDK (latest stable)**
2. **Android Studio** with:
   - Android SDK
   - Android SDK Platform tools
   - Android Emulator
   - Flutter and Dart plugins
3. **JDK 17** (recommended for current Android Gradle toolchains)
4. A **Firebase project**
5. (Optional) A physical Android phone with USB debugging enabled

Check your setup:

```bash
flutter doctor -v
```

Resolve any red errors before continuing.

---

## 1) Get dependencies

From project root:

```bash
flutter pub get
```

---

## 2) Generate Freezed/JSON files

This project uses Freezed + json_serializable models.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

If you edit model classes later, re-run this command.

---

## 3) Firebase Android setup

This app reads problem data from **Firebase Realtime Database**.

1. Create Firebase project.
2. Add Android app with package name matching your Flutter app (configure in `android/app/build.gradle` if needed).
3. Download `google-services.json`.
4. Place it at:

```text
android/app/google-services.json
```

5. Ensure Gradle Firebase plugin setup is present (project + app level).

### Realtime Database seed

Use the provided seed file:

```text
assets/data/firebase_seed.json
```

Upload JSON to your Realtime Database root.

Expected top-level nodes:

- `problems`
- `dailyChallenges`

---

## 4) AdMob setup (for real ads)

Current code uses Google test ad unit IDs by default.

For production:

1. Create AdMob app + ad units.
2. Replace unit IDs in:

- `lib/core/ads/ad_service.dart`

3. Add your AdMob app ID metadata in Android manifest (`AndroidManifest.xml`).

---

## 5) In-App Purchase setup

Current product id:

- `no_ai_coding_gym_premium_unlock`

To test and use real billing:

1. Create app in Google Play Console.
2. Configure **one-time product** with same product ID (or update code to match).
3. Add license testers in Play Console.
4. Upload at least internal testing build.
5. Install app from Play internal test track for billing tests.

---

## 6) Run in Android Studio (emulator)

1. Open Android Studio.
2. Open this Flutter project folder.
3. Wait for indexing/Gradle sync.
4. Start an Android Virtual Device (AVD).
5. Run:
   - via green Run button, or
   - terminal:

```bash
flutter run
```

---

## 7) Run on physical Android phone

1. Enable **Developer options** and **USB debugging** on phone.
2. Connect phone with USB.
3. Verify device is visible:

```bash
flutter devices
```

4. Run app:

```bash
flutter run -d <device_id>
```

If prompted on phone, accept RSA fingerprint trust dialog.

---

## 8) Recommended smoke test checklist

After app launches:

1. Home screen loads title and daily challenge card.
2. Problem list displays all 10 problems.
3. Open a problem and verify details (title, difficulty, topic, description).
4. Submission form validation blocks empty/short approach (<20 chars).
5. Valid submission navigates to reveal flow.
6. Reveal progression works in order.
7. Reattempt resets submission + reveal state.
8. Streak and attempt counters update locally.
9. Premium flow button appears (non-premium).
10. Banner appears only for non-premium users.

---

## 9) Useful commands

```bash
# Analyze
flutter analyze

# Run tests (if/when added)
flutter test

# Run app
flutter run

# Build debug APK
flutter build apk --debug
```

---

## Troubleshooting

### `flutter doctor` shows issues
Fix all toolchain/dependency issues first.

### Firebase data not loading
- Verify `google-services.json` location.
- Check Realtime Database rules and data path names.
- Confirm keys are exactly `problems` and `dailyChallenges`.

### Billing not working on local debug build
Real IAP generally requires Play-distributed build (internal testing track) and tester accounts.

### Build runner errors
Delete generated conflicts and rerun:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Notes

- No authentication is implemented by design.
- No analytics, notifications, offline mode, or leaderboard by design.
- Android-first target; iOS setup is not included in this README.
