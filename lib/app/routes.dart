import 'package:flutter/material.dart';

import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/live_alert/live_alert_screen.dart';
import '../presentation/screens/contacts/contacts_screen.dart';
import '../presentation/screens/alert_history/alert_history_screen.dart';
import '../presentation/screens/alert_history/alert_detail_screen.dart';
import '../presentation/screens/device_settings/lifora_band_screen.dart';
import '../presentation/screens/settings/app_settings_screen.dart';
import '../presentation/screens/developer/developer_mode_screen.dart';

/// Named route constants for Lifora.
///
/// All navigation goes through these constants — no magic strings
/// scattered through widgets.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String liveAlert = '/live-alert';
  static const String contacts = '/contacts';
  static const String alertHistory = '/alert-history';
  static const String alertDetail = '/alert-detail';
  static const String liforaBand = '/lifora-band';
  static const String appSettings = '/app-settings';
  static const String developerMode = '/developer-mode';
}

/// Generates routes from [AppRoutes] constants.
///
/// Pass this to [MaterialApp.onGenerateRoute].
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: settings,
      );

    case AppRoutes.liveAlert:
      return MaterialPageRoute(
        builder: (_) => const LiveAlertScreen(),
        settings: settings,
      );

    case AppRoutes.contacts:
      return MaterialPageRoute(
        builder: (_) => const ContactsScreen(),
        settings: settings,
      );

    case AppRoutes.alertHistory:
      return MaterialPageRoute(
        builder: (_) => const AlertHistoryScreen(),
        settings: settings,
      );

    case AppRoutes.alertDetail:
      // Expects an alert ID passed as route arguments.
      final alertId = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (_) => AlertDetailScreen(alertId: alertId ?? ''),
        settings: settings,
      );

    case AppRoutes.liforaBand:
      return MaterialPageRoute(
        builder: (_) => const LiforaBandScreen(),
        settings: settings,
      );

    case AppRoutes.appSettings:
      return MaterialPageRoute(
        builder: (_) => const AppSettingsScreen(),
        settings: settings,
      );

    case AppRoutes.developerMode:
      return MaterialPageRoute(
        builder: (_) => const DeveloperModeScreen(),
        settings: settings,
      );

    default:
      // Fallback — should never happen if all routes are registered.
      return MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: settings,
      );
  }
}
