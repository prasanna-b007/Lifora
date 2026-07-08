import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/providers/app_settings_provider.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

/// Root widget for the Lifora app.
///
/// Configures Material 3 theme (light + dark, system-aware),
/// named routes, and the initial screen.
class LiforaApp extends StatelessWidget {
  const LiforaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lifora',

          // ── Theme ─────────────────────────────────────────────────────
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,

          // ── Navigation ────────────────────────────────────────────────
          initialRoute: AppRoutes.home,
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
