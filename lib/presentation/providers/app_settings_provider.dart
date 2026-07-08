import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages application-wide settings such as Theme and Notifications.
class AppSettingsProvider extends ChangeNotifier {
  AppSettingsProvider(this._prefs) {
    _loadSettings();
  }

  final SharedPreferences _prefs;

  // Theme settings
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // Notification settings (local mock state)
  bool _emergencyAlerts = true;
  bool get emergencyAlerts => _emergencyAlerts;

  bool _pushNotifications = true;
  bool get pushNotifications => _pushNotifications;

  bool _sound = true;
  bool get sound => _sound;

  bool _vibration = true;
  bool get vibration => _vibration;

  void _loadSettings() {
    final themeIndex = _prefs.getInt('themeMode');
    if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeIndex];
    }
    _emergencyAlerts = _prefs.getBool('emergencyAlerts') ?? true;
    _pushNotifications = _prefs.getBool('pushNotifications') ?? true;
    _sound = _prefs.getBool('sound') ?? true;
    _vibration = _prefs.getBool('vibration') ?? true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setEmergencyAlerts(bool value) async {
    if (_emergencyAlerts == value) return;
    _emergencyAlerts = value;
    await _prefs.setBool('emergencyAlerts', value);
    notifyListeners();
  }

  Future<void> setPushNotifications(bool value) async {
    if (_pushNotifications == value) return;
    _pushNotifications = value;
    await _prefs.setBool('pushNotifications', value);
    notifyListeners();
  }

  Future<void> setSound(bool value) async {
    if (_sound == value) return;
    _sound = value;
    await _prefs.setBool('sound', value);
    notifyListeners();
  }

  Future<void> setVibration(bool value) async {
    if (_vibration == value) return;
    _vibration = value;
    await _prefs.setBool('vibration', value);
    notifyListeners();
  }
}
