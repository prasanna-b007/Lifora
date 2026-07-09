import 'package:lifora/domain/entities/alert.dart';

/// Abstract interface for system notifications.
abstract class NotificationService {
  /// Called when an SOS is initially triggered.
  Future<void> notifySosTriggered(Alert alert);

  /// Called when an SOS successfully delivered via any layer.
  Future<void> notifySosDelivered(Alert alert);

  /// Called when an SOS is cancelled by the user.
  Future<void> notifySosCancelled(Alert alert);
}
