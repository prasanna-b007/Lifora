/// App-wide constants for Lifora.
///
/// BLE UUIDs, trigger thresholds, and configuration values.
/// Keep this file free of Flutter imports — pure Dart only.
class AppConstants {
  AppConstants._();

  // ── App Info ────────────────────────────────────────────────────────
  static const String appName = 'Lifora';
  static const String appVersion = '1.0.0';
  static const String appTagline =
      'Smart Wearable Emergency Communication System';

  // ── Mock User ──────────────────────────────────────────────────────
  static const String mockUserName = 'Prasanna B';

  // ── BLE Configuration ──────────────────────────────────────────────
  static const String bleServiceUuid =
      '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String bleCharacteristicUuid =
      'beb5483e-36e1-4688-b7f5-ea07361b26a8';

  // ── Trigger Thresholds ─────────────────────────────────────────────
  static const int tapThreshold = 3;
  static const Duration tapTimeWindow = Duration(seconds: 2);
  static const Duration longPressThreshold = Duration(seconds: 3);

  // ── Contact Limits ─────────────────────────────────────────────────
  static const int maxEmergencyContacts = 5;

  // ── Mock Location (Coimbatore, Tamil Nadu) ─────────────────────────
  /// Replace with real GPS integration when hardware is connected.
  static const double mockLatitude = 11.0168;
  static const double mockLongitude = 76.9558;

  // ── SOS Simulation Timing ──────────────────────────────────────────
  /// Duration for each layer attempt during simulated SOS.
  static const Duration layerAttemptDuration = Duration(seconds: 3);
}
