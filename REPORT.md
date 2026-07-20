# Lifora — Project Report

## Overview
- **Name:** lifora
- **Description:** Smart Wearable Emergency Communication System
- **Type:** Flutter mobile app (multi-platform project with Android/iOS/web/desktop folders present)
- **Version:** 1.0.0+1

## Important Files
- `pubspec.yaml`: project metadata and dependencies
- `README.md`: basic project README
- `lib/main.dart`: application entrypoint and DI setup
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`: platform targets available in the repo
- `test/widget_test.dart`: example widget test present

## Dependencies (from `pubspec.yaml`)
- flutter (sdk)
- cupertino_icons ^1.0.8
- flutter_blue_plus ^1.35.5
- geolocator ^11.1.0
- permission_handler ^11.3.1
- provider ^6.1.2
- google_fonts ^6.2.1
- google_maps_flutter ^2.10.0
- shared_preferences ^2.5.5
- hive ^2.2.3
- hive_flutter ^1.1.0
- path_provider ^2.1.6
- flutter_local_notifications ^22.0.1
- flutter_map ^8.2.1
- latlong2 ^0.9.1
- geocoding ^4.0.0
- url_launcher ^6.3.2

Dev dependencies:
- flutter_test (sdk)
- flutter_lints ^6.0.0
- build_runner ^2.4.13
- hive_generator ^2.0.1

## Entrypoint and Architecture
- Entrypoint: `lib/main.dart` — initializes `SharedPreferences`, Hive, registers adapters, opens Hive boxes, requests notification permission, and runs the app.
- Uses `provider` for dependency injection and state management (`MultiProvider`).
- Services and repositories are wired to Hive concrete implementations; `VirtualWearableService` is used as a placeholder for device connection.

## Build & Run
- Typical local run:
  - `flutter pub get`
  - `flutter run` (select target device)
- Common build commands:
  - `flutter build apk` (Android)
  - `flutter build ios` (iOS)
  - `flutter build web`
- Note: Terminal history shows a recent `flutter run` that exited with code 1 — investigate local device logs if encountering failures.

## Tests
- `test/widget_test.dart` exists; run `flutter test` to execute tests.

## Notes & Recommendations
- The project is configured for multiple platforms; verify SDK constraints (`sdk: ^3.10.0`) match local Flutter/Dart versions.
- Hive adapters are registered in `main.dart`; ensure generated model adapters (if using codegen) are up-to-date (`build_runner` + `hive_generator`).
- The app requests notification permission at startup — on Android 13+ ensure runtime permission flow works during testing.
- If `flutter run` fails, run `flutter doctor -v` and check device/emulator availability and Gradle build logs.

## Where to Inspect Next
- App app widget: `lib/app/app.dart`
- Domain entities: `lib/domain/` (e.g., `domain/entities/event_log.dart`)
- Data layer and services: `lib/data/services/`, `lib/data/repositories/`

---
Generated on 2026-07-20 by repository scan.
