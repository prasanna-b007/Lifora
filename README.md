# Lifora

Lifora — Smart Wearable Emergency Communication System

Lifora is a Flutter application prototype that demonstrates emergency
communication features for wearable devices. It provides a small, well-
architected codebase that integrates Bluetooth, location, local
notifications, persistent storage (Hive), and mapping to model a real
world emergency alert flow.

Why this README is useful
- Quick project orientation for new contributors
- Clear setup and run commands for local development
- Notes about architecture, key modules, and troubleshooting tips

## Key Features
- Simulated wearable device connection (swap to BLE implementation when ready)
- Location capture using `geolocator` and `geocoding`
- Local notifications and permission handling
- Persisted contacts and alerts using `hive`
- Map support with `google_maps_flutter` / `flutter_map`

## Architecture Overview
- Entry point: `lib/main.dart` — initializes services, Hive boxes, and
	wires providers with `provider`/`ChangeNotifier`.
- Layers:
	- Domain: entities and repository interfaces (`lib/domain/`)
	- Data: concrete Hive repositories, services (location, notifications)
	- Presentation: providers and UI widgets (`lib/presentation/`)

The app uses `MultiProvider` for dependency injection and state
management. `VirtualWearableService` is used as a device connection
placeholder; replace with a BLE-backed service (`BleDeviceConnectionService`)
when integrating with hardware.

## Quick Start (Development)
Prerequisites

- Flutter SDK (matching Dart SDK >= 3.10.0). Run `flutter --version`.
- Android SDK / Xcode (for mobile targets) or a supported desktop target.

Clone and install dependencies

```bash
flutter pub get
```

Run on a connected device or emulator

```bash
flutter run
```

Build release APK (Android)

```bash
flutter build apk --release
```

Run tests

```bash
flutter test
```

## Important Files & Where to Look
- `lib/main.dart` — app bootstrap, Hive adapter registration, providers
- `lib/app/app.dart` — app widget and routing
- `lib/data/services/` — location, notification, and device connection
- `lib/data/repositories/` — Hive-backed repos for contacts & alerts
- `lib/presentation/` — UI screens and providers
- `pubspec.yaml` — dependency list (notable: `flutter_blue_plus`, `hive`, `geolocator`, `google_maps_flutter`)

## Troubleshooting
- If `flutter run` fails with exit code 1:
	- Run `flutter doctor -v` to check SDK and device issues.
	- Inspect Gradle logs for Android build failures (`android/` build output).
	- Ensure Hive model adapters are generated if missing: `flutter pub run build_runner build`.
	- For notification permission issues on Android 13+, verify runtime permissions are handled.

## Contributing
- Fork the repo and open a pull request for fixes or features.
- Keep commits focused and add tests for new behavior.

## Next Steps / Ideas
- Replace `VirtualWearableService` with BLE implementation when hardware is available.
- Add end-to-end tests for alert flow.
- Improve CI workflow to run `flutter test` and `flutter analyze`.

## License & Contact
This repository contains example/demo code. Check with the project owner
for licensing and distribution preferences.

---
Generated on 2026-07-20 — created by a repository scan and README rewrite.
