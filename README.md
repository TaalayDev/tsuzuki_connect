# Tsuzuki Connect

A Flutter-based visual novel language-learning game that blends interactive story content with Japanese study features.

## What This Project Includes

- Story-driven visual novel experience rendered from bundled web assets (`assets/js`, `assets/css`, `assets/index.html`) inside `InAppWebView`.
- Multi-language app UI support:
- In-app purchase flow for premium unlock using `in_app_purchase`.
- Firebase initialization for analytics integration.
- Cross-platform Flutter project structure (`ios`, `android`, `macos`, `windows`, `linux`, `web`).

## Tech Stack

- Flutter / Dart (`sdk: >=3.10.3 <4.0.0`)
- Riverpod + GoRouter
- `flutter_inappwebview`
- `in_app_purchase`
- `firebase_core`, `firebase_analytics`
- `shared_preferences`, `url_launcher`, `window_manager`

## Project Structure

- `lib/main.dart`: app bootstrap, orientation/window setup, Firebase init.
- `lib/app.dart`: root app widget, localization delegates, router setup.
- `lib/presentation/screens/game_screen.dart`: game webview host + purchase sheet UI.
- `lib/services/subscription_service.dart`: IAP querying, purchase/restore flow, premium state.
- `assets/`: web game content (JS engine, stories, graphics, audio, CSS/HTML).
- `manage.sh`: helper script for run/build tasks.

## Prerequisites

- Flutter SDK installed and in `PATH`
- Xcode (for iOS/macOS builds), Android Studio + SDK (for Android builds)
- Valid Firebase config files, create them at https://console.firebase.google.com/ and add them to the project.

## Getting Started

```bash
flutter pub get
flutter run
```

To run on a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

## Using the Helper Script

Make executable once:

```bash
chmod +x manage.sh
```

Build release artifacts:

```bash
./manage.sh build apk
./manage.sh build appbundle
./manage.sh build ipa
./manage.sh build macos
```

## In-App Purchase Notes

- Service: `lib/services/subscription_service.dart`
- The purchase sheet fetches localized store price at runtime from product details.
- Android / iOS / macOS use `in_app_purchase`.
- Windows uses native Microsoft Store APIs through a `MethodChannel` (`tsuzuki/windows_iap`) and requires running as a packaged MSIX app.
- For real purchase testing, configure matching products in the relevant store dashboards and use sandbox/test accounts.
- Windows product ID can be overridden at build/run time:
  - `flutter run -d windows --dart-define=WINDOWS_UNLOCK_ALL_STORE_ID=<your-store-id>`

## Screenshots

| Screenshot 1 | Screenshot 2 |
|---|---|
| ![Screenshot 2](https://is2-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/25/ab/74/25ab74bf-7a56-7e29-704b-5d6e7dbdd2c7/_U041d_U043e_U0432_U044b_U0438_U0306__U043f_U0440_U043e_U0435_U043a_U0442__U002810_U0029.jpg/0x0ss.png) | ![Screenshot 3](https://is2-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/24/9e/4c/249e4c25-77e3-dd70-f12e-7709b8afe4b7/_U041d_U043e_U0432_U044b_U0438_U0306__U043f_U0440_U043e_U0435_U043a_U0442__U002811_U0029.jpg/0x0ss.png) |
