
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lifora/app/app.dart';
import 'package:lifora/data/repositories/mock_alert_repository.dart';
import 'package:lifora/data/repositories/mock_contact_repository.dart';
import 'package:lifora/data/repositories/mock_device_repository.dart';
import 'package:lifora/data/services/device_connection_service.dart';
import 'package:lifora/data/services/mock_device_connection_service.dart';
import 'package:lifora/data/services/mock_location_service.dart';
import 'package:lifora/data/services/notification_service.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/repositories/alert_repository.dart';
import 'package:lifora/domain/repositories/contact_repository.dart';
import 'package:lifora/domain/repositories/device_repository.dart';
import 'package:lifora/presentation/providers/home_provider.dart';
import 'package:lifora/presentation/providers/contacts_provider.dart';
import 'package:lifora/presentation/providers/alert_history_provider.dart';
import 'package:lifora/presentation/providers/device_settings_provider.dart';
import 'package:lifora/presentation/providers/live_alert_provider.dart';
import 'package:lifora/presentation/providers/app_settings_provider.dart';

void main() {
  testWidgets('App launches to HomeScreen with greeting',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final deviceRepo = MockDeviceRepository();
    final contactRepo = MockContactRepository();
    final alertRepo = MockAlertRepository();
    final connectionService = MockDeviceConnectionService();
    final locationService = MockLocationService();
    final notificationService = MockNotificationService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppSettingsProvider>(
            create: (_) => AppSettingsProvider(prefs),
          ),
          Provider<DeviceConnectionService>(
            create: (_) => connectionService,
          ),
          Provider<DeviceRepository>(create: (_) => deviceRepo),
          Provider<ContactRepository>(create: (_) => contactRepo),
          Provider<AlertRepository>(create: (_) => alertRepo),
          ChangeNotifierProvider<HomeProvider>(
            create: (_) => HomeProvider(
              deviceRepository: deviceRepo,
              contactRepository: contactRepo,
              alertRepository: alertRepo,
            ),
          ),
          ChangeNotifierProvider<ContactsProvider>(
            create: (_) => ContactsProvider(
              contactRepository: contactRepo,
            ),
          ),
          ChangeNotifierProvider<AlertHistoryProvider>(
            create: (_) => AlertHistoryProvider(
              alertRepository: alertRepo,
            ),
          ),
          ChangeNotifierProvider<DeviceSettingsProvider>(
            create: (_) => DeviceSettingsProvider(
              connectionService: connectionService,
              deviceRepository: deviceRepo,
            ),
          ),
          ChangeNotifierProvider<LiveAlertProvider>(
            create: (_) => LiveAlertProvider(
              connectionService: connectionService,
              alertRepository: alertRepo,
              contactRepository: contactRepo,
              locationService: locationService,
              notificationService: notificationService,
            ),
          ),
        ],
        child: const LiforaApp(),
      ),
    );

    // Verify the app launches and shows the greeting.
    expect(find.text('Lifora'), findsOneWidget);
    expect(find.text('Hello, Prasanna B'), findsOneWidget);
  });
}

class MockNotificationService implements NotificationService {
  @override
  Future<void> notifySosCancelled(Alert alert) async {}

  @override
  Future<void> notifySosDelivered(Alert alert) async {}

  @override
  Future<void> notifySosTriggered(Alert alert) async {}
}
