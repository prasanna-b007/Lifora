import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'data/repositories/mock_alert_repository.dart';
import 'data/repositories/mock_contact_repository.dart';
import 'data/repositories/mock_device_repository.dart';
import 'data/services/device_connection_service.dart';
import 'data/services/mock_device_connection_service.dart';
import 'domain/repositories/alert_repository.dart';
import 'domain/repositories/contact_repository.dart';
import 'domain/repositories/device_repository.dart';
import 'presentation/providers/home_provider.dart';
import 'presentation/providers/contacts_provider.dart';
import 'presentation/providers/alert_history_provider.dart';
import 'presentation/providers/device_settings_provider.dart';
import 'presentation/providers/live_alert_provider.dart';
import 'presentation/providers/app_settings_provider.dart';

/// Lifora — Smart Wearable Emergency Communication System
///
/// Entry point. Sets up dependency injection via Provider:
/// - All repositories use mock implementations (no backend).
/// - DeviceConnectionService uses MockDeviceConnectionService
///   (swap to BleDeviceConnectionService when hardware is ready).
/// - No login/signup — app opens straight into HomeScreen.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        // ── App Settings ─────────────────────────────────────────
        ChangeNotifierProvider<AppSettingsProvider>(
          create: (_) => AppSettingsProvider(prefs),
        ),

        // ── Device Connection Service ────────────────────────────
        // Swap MockDeviceConnectionService → BleDeviceConnectionService
        // when the ESP32-C3 hardware is ready. No other code changes needed.
        Provider<DeviceConnectionService>(
          create: (_) => MockDeviceConnectionService(),
          dispose: (_, service) {
            if (service is MockDeviceConnectionService) {
              service.dispose();
            }
          },
        ),

        // ── Repositories ─────────────────────────────────────────
        Provider<DeviceRepository>(
          create: (_) => MockDeviceRepository(),
        ),
        Provider<ContactRepository>(
          create: (_) => MockContactRepository(),
        ),
        Provider<AlertRepository>(
          create: (_) => MockAlertRepository(),
        ),

        // ── View Models ──────────────────────────────────────────
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(
            deviceRepository: context.read<DeviceRepository>(),
            contactRepository: context.read<ContactRepository>(),
            alertRepository: context.read<AlertRepository>(),
          ),
        ),
        ChangeNotifierProvider<ContactsProvider>(
          create: (context) => ContactsProvider(
            contactRepository: context.read<ContactRepository>(),
          ),
        ),
        ChangeNotifierProvider<AlertHistoryProvider>(
          create: (context) => AlertHistoryProvider(
            alertRepository: context.read<AlertRepository>(),
          ),
        ),
        ChangeNotifierProvider<DeviceSettingsProvider>(
          create: (context) => DeviceSettingsProvider(
            connectionService: context.read<DeviceConnectionService>(),
            deviceRepository: context.read<DeviceRepository>(),
          ),
        ),
        ChangeNotifierProvider<LiveAlertProvider>(
          create: (context) => LiveAlertProvider(
            connectionService: context.read<DeviceConnectionService>(),
            alertRepository: context.read<AlertRepository>(),
            contactRepository: context.read<ContactRepository>(),
          ),
        ),
      ],
      child: const LiforaApp(),
    ),
  );
}