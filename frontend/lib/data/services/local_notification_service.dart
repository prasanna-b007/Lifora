import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/data/services/notification_service.dart';

class LocalNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  LocalNotificationService() {
    _init();
  }

  Future<void> _init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _plugin.initialize(settings: initializationSettings);
  }

  @override
  Future<void> notifySosTriggered(Alert alert) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sos_channel_id',
      'SOS Alerts',
      channelDescription: 'High priority alerts for SOS triggers.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'SOS Triggered',
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: 0,
      title: 'Lifora SOS Triggered',
      body: 'Escalating to emergency contacts',
      notificationDetails: platformDetails,
    );
  }

  @override
  Future<void> notifySosDelivered(Alert alert) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sos_channel_id',
      'SOS Alerts',
      channelDescription: 'High priority alerts for SOS triggers.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: 1,
      title: 'Lifora SOS Delivered',
      body: 'Alert delivered to emergency contacts',
      notificationDetails: platformDetails,
    );
  }

  @override
  Future<void> notifySosCancelled(Alert alert) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sos_channel_id',
      'SOS Alerts',
      channelDescription: 'High priority alerts for SOS triggers.',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: false,
      enableVibration: false,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    // Cancel ongoing triggered/delivered notifications if any, then show cancelled.
    await _plugin.cancel(id: 0);
    await _plugin.cancel(id: 1);

    await _plugin.show(
      id: 2,
      title: 'Lifora SOS Cancelled',
      body: 'Alert was cancelled',
      notificationDetails: platformDetails,
    );
  }
}
