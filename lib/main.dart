import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/app.dart';
import 'data/repositories/mock_device_repository.dart';

import 'data/repositories/hive_alert_repository.dart';
import 'data/repositories/hive_contact_repository.dart';
import 'data/models/contact_hive_model.dart';
import 'data/models/layer_status_hive_model.dart';
import 'data/models/alert_hive_model.dart';

import 'data/services/device_connection_service.dart';
import 'data/services/mock_device_connection_service.dart';
import 'data/services/location_service.dart';
import 'data/services/geolocator_location_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/local_notification_service.dart';

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
/// - Contact & Alert repositories use Hive implementations.
/// - Location & Notification use real OS-level services.
/// - DeviceConnectionService uses MockDeviceConnectionService
///   (swap to BleDeviceConnectionService when hardware is ready).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  await Hive.initFlutter();
  Hive.registerAdapter(ContactHiveModelAdapter());
  Hive.registerAdapter(LayerStateHiveModelAdapter());
  Hive.registerAdapter(LayerStatusHiveModelAdapter());
  Hive.registerAdapter(AlertStatusHiveModelAdapter());
  Hive.registerAdapter(AlertHiveModelAdapter());

  final contactsBox = await Hive.openBox<ContactHiveModel>('contacts');
  final alertsBox = await Hive.openBox<AlertHiveModel>('alerts');

  // Request notification permission (needed for Android 13+)
  await Permission.notification.request();

  runApp(
    MultiProvider(
      providers: [
        // ── App Settings ─────────────────────────────────────────
        ChangeNotifierProvider<AppSettingsProvider>(
          create: (_) => AppSettingsProvider(prefs),
        ),

        // ── Services ─────────────────────────────────────────────
        Provider<DeviceConnectionService>(
          create: (_) => MockDeviceConnectionService(),
          dispose: (_, service) {
            if (service is MockDeviceConnectionService) {
              service.dispose();
            }
          },
        ),
        Provider<LocationService>(
          create: (_) => GeolocatorLocationService(),
        ),
        Provider<NotificationService>(
          create: (_) => LocalNotificationService(),
        ),

        // ── Repositories ─────────────────────────────────────────
        Provider<DeviceRepository>(
          create: (_) => MockDeviceRepository(),
        ),
        Provider<ContactRepository>(
          create: (_) => HiveContactRepository(contactsBox),
        ),
        Provider<AlertRepository>(
          create: (_) => HiveAlertRepository(alertsBox),
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
            locationService: context.read<LocationService>(),
            notificationService: context.read<NotificationService>(),
          ),
        ),
      ],
      child: const LiforaApp(),
    ),
  );
}