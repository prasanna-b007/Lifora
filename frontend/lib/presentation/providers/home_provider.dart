import 'package:flutter/material.dart';

import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/entities/contact.dart';
import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/domain/repositories/alert_repository.dart';
import 'package:lifora/domain/repositories/contact_repository.dart';
import 'package:lifora/data/services/device_connection_service.dart';

/// View model for the Home / Dashboard screen.
///
/// Aggregates data from the device, contact, and alert repositories
/// into a single observable state for the home screen.
class HomeProvider extends ChangeNotifier {
  HomeProvider({
    required DeviceConnectionService connectionService,
    required ContactRepository contactRepository,
    required AlertRepository alertRepository,
  })  : _connectionService = connectionService,
        _contactRepository = contactRepository,
        _alertRepository = alertRepository {
    _connectionService.addListener(notifyListeners);
  }

  final DeviceConnectionService _connectionService;
  final ContactRepository _contactRepository;
  final AlertRepository _alertRepository;

  // ── Device ──────────────────────────────────────────────────────────

  /// Current device state.
  Device get device => _connectionService.device;

  // ── Contacts ────────────────────────────────────────────────────────

  /// First 3 emergency contacts for the quick-view section.
  List<Contact> get quickContacts {
    final all = _contactRepository.getContacts();
    return all.length <= 3 ? all : all.sublist(0, 3);
  }

  /// Total number of emergency contacts.
  int get totalContactCount => _contactRepository.getContacts().length;

  // ── Alerts ──────────────────────────────────────────────────────────

  /// The most recent alert, or null if no alerts exist.
  Alert? get latestAlert {
    final alerts = _alertRepository.getAlerts();
    return alerts.isEmpty ? null : alerts.first;
  }

  /// Refreshes all data and notifies listeners.
  void refresh() {
    debugPrint("Refreshing Home Screen...");
    notifyListeners();
  }

  @override
  void dispose() {
    _connectionService.removeListener(notifyListeners);
    super.dispose();
  }
}
