import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/entities/layer_status.dart';
import 'package:lifora/domain/repositories/alert_repository.dart';
import 'package:lifora/domain/repositories/contact_repository.dart';
import 'package:lifora/domain/entities/wearable_event.dart';
import 'package:lifora/data/services/device_connection_service.dart';
import 'package:lifora/data/services/location_service.dart';
import 'package:lifora/data/services/notification_service.dart';
import 'package:lifora/domain/entities/event_log.dart';
import 'package:lifora/presentation/providers/event_log_provider.dart';
import 'package:lifora/presentation/providers/emergency_packet_provider.dart';

/// View model for the Live Alert Screen.
///
/// Handles the state of an active SOS alert, simulating the escalation
/// through the 3 fallback layers:
/// 1. BLE to Phone
/// 2. GSM / SMS Fallback
/// 3. BLE Mesh Relay
class LiveAlertProvider extends ChangeNotifier {
  final DeviceConnectionService _connectionService;
  final AlertRepository _alertRepository;
  final ContactRepository _contactRepository;
  final LocationService _locationService;
  final NotificationService _notificationService;
  final EmergencyPacketProvider? _emergencyPacketProvider;
  final EventLogProvider? eventLogger;

  StreamSubscription<WearableEvent>? _eventSub;
  int? _forcedEscalationLayerForCurrentAlert;

  LiveAlertProvider({
    required DeviceConnectionService connectionService,
    required AlertRepository alertRepository,
    required ContactRepository contactRepository,
    required LocationService locationService,
    required NotificationService notificationService,
    EmergencyPacketProvider? emergencyPacketProvider,
    this.eventLogger,
  })  : _connectionService = connectionService,
        _alertRepository = alertRepository,
        _contactRepository = contactRepository,
        _locationService = locationService,
        _notificationService = notificationService,
        _emergencyPacketProvider = emergencyPacketProvider {
    _eventSub = _connectionService.events.listen(_onWearableEvent);
  }

  Alert? _currentAlert;
  Alert? get currentAlert => _currentAlert;

  bool _isLocationLoading = false;
  String? _locationErrorMessage;
  bool _isAddressLoading = false;
  String? _address;
  String? _addressErrorMessage;

  bool get isLocationLoading => _isLocationLoading;
  bool get isAddressLoading => _isAddressLoading;
  bool get hasLocation =>
      _currentAlert != null &&
      !_isLocationLoading &&
      _locationErrorMessage == null &&
      _currentAlert!.latitude != 0.0 &&
      _currentAlert!.longitude != 0.0;
  String? get locationErrorMessage => _locationErrorMessage;
  String? get address => _address;
  String? get addressErrorMessage => _addressErrorMessage;
  double get latitude => _currentAlert?.latitude ?? 0.0;
  double get longitude => _currentAlert?.longitude ?? 0.0;

  Timer? _escalationTimer;
  int _currentLayerIndex = 0;

  void _onWearableEvent(WearableEvent event) {
    if (event.type == WearableEventType.tripleTap ||
        event.type == WearableEventType.longPress ||
        event.type == WearableEventType.fall ||
        event.type == WearableEventType.whistle ||
        event.type == WearableEventType.manualSos) {
      _startAlertFromEvent(event);
    }
  }

  /// Starts a new SOS alert sequence from a triggered wearable event.
  Future<void> _startAlertFromEvent(WearableEvent event) async {
    if (_currentAlert != null && _currentAlert!.status == AlertStatus.inProgress) {
      return; // Already running
    }

    _escalationTimer?.cancel();
    
    int? batteryAtTrigger = event.payload['batteryLevel'] as int?;
    _forcedEscalationLayerForCurrentAlert = event.payload['forcedOutcomeLayer'] as int?;

    // Fetch location
    _isLocationLoading = true;
    _locationErrorMessage = null;
    notifyListeners();
    eventLogger?.addLog('Location Requested', 'Requesting current GPS location.', EventCategory.gps);
    
    double lat = 0.0;
    double lng = 0.0;
    double accuracy = 0.0;
    String addr = 'Unknown';
    
    try {
      final locationResult = await _locationService.getCurrentLocation().timeout(const Duration(seconds: 5));
      if (locationResult.isMockLocation) {
        _locationErrorMessage = 'Please enable location services.';
        eventLogger?.addLog('Location Failed', 'GPS location unavailable; using fallback.', EventCategory.gps);
      } else {
        lat = locationResult.latitude;
        lng = locationResult.longitude;
        accuracy = locationResult.accuracy;
        _locationErrorMessage = null;
        
        try {
          final addressResult = await _locationService
              .getAddressFromCoordinates(lat, lng)
              .timeout(const Duration(seconds: 8));
          addr = addressResult;
        } catch (e) {
          debugPrint('Address lookup failed: $e');
        }
        
        eventLogger?.addLog('Location Acquired', 'GPS location successfully acquired.', EventCategory.gps);
      }
    } catch (e) {
      _locationErrorMessage = 'Please enable location services.';
      eventLogger?.addLog('Location Failed', 'Failed to acquire GPS location.', EventCategory.gps);
      debugPrint('Location fetch failed or timed out: $e');
    }
    
    _isLocationLoading = false;
    _isAddressLoading = false;
    
    final contacts = _contactRepository.getContacts();
    
    // GENERATE PACKET BEFORE ALERT STARTS
    _emergencyPacketProvider?.generatePacket(
      device: _connectionService.device,
      triggerType: event.type,
      latitude: lat,
      longitude: lng,
      address: addr,
      contacts: contacts,
    );
    
    eventLogger?.addLog('SOS Started', 'SOS sequence initiated.', EventCategory.alert);

    // Initialize the alert state
    _currentAlert = Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      status: AlertStatus.inProgress,
      resolvedAtLayer: 0,
      latitude: lat,
      longitude: lng,
      accuracy: accuracy,
      batteryAtTrigger: batteryAtTrigger,
      notifiedContactIds: [],
      layers: const [
        LayerStatus(layer: 1, label: 'BLE to Phone', state: LayerState.pending),
        LayerStatus(layer: 2, label: 'GSM / SMS Fallback', state: LayerState.pending),
        LayerStatus(layer: 3, label: 'BLE Mesh Relay', state: LayerState.pending),
      ],
    );

    _currentLayerIndex = 0;
    _address = addr;
    if (addr == 'Address unavailable') {
      _addressErrorMessage = 'Unable to resolve address.';
    } else {
      _addressErrorMessage = null;
    }
    
    notifyListeners();

    try {
      await _notificationService.notifySosTriggered(_currentAlert!);
      eventLogger?.addLog('Notification Sent', 'SOS triggered notification sent.', EventCategory.notification);
    } catch (e) {
      eventLogger?.addLog('Notification Failed', 'Failed to send SOS notification.', EventCategory.notification);
    }

    // Begin the escalation simulation
    _processNextLayer();
  }

  /// Cancels an ongoing alert.
  void cancelAlert() {
    if (_currentAlert == null || _currentAlert!.status != AlertStatus.inProgress) {
      return;
    }

    _escalationTimer?.cancel();

    _currentAlert = _currentAlert!.copyWith(
      status: AlertStatus.cancelled,
    );
    
    eventLogger?.addLog('SOS Cancelled', 'SOS sequence cancelled by user.', EventCategory.alert);

    _notificationService.notifySosCancelled(_currentAlert!).then((_) {
      eventLogger?.addLog('Notification Sent', 'SOS cancelled notification sent.', EventCategory.notification);
    }).catchError((_) {
      eventLogger?.addLog('Notification Failed', 'Failed to send cancel notification.', EventCategory.notification);
    });
    
    // Save to history
    _alertRepository.addAlert(_currentAlert!);
    notifyListeners();
  }

  void _processNextLayer() {
    if (_currentAlert == null || _currentAlert!.status != AlertStatus.inProgress) return;
    
    // If we've exhausted all layers, the alert has failed entirely.
    if (_currentLayerIndex >= _currentAlert!.layers.length) {
      _currentAlert = _currentAlert!.copyWith(status: AlertStatus.cancelled); // Terminal state
      _alertRepository.addAlert(_currentAlert!);
      notifyListeners();
      return;
    }

    // Set current layer to attempting
    _updateLayerState(_currentLayerIndex, LayerState.attempting);

    // Simulate delay for the current layer
    _escalationTimer = Timer(const Duration(seconds: 3), () {
      if (_currentAlert == null || _currentAlert!.status != AlertStatus.inProgress) return;

      // Logic to determine success/failure for the simulation
      bool layerSucceeded = false;
      String? detail;

      if (_forcedEscalationLayerForCurrentAlert != null) {
        if (_currentLayerIndex + 1 == _forcedEscalationLayerForCurrentAlert) {
          layerSucceeded = true;
          detail = 'Delivered via forced layer ${_currentLayerIndex + 1}.';
        } else {
          layerSucceeded = false;
          detail = 'Failed due to forced escalation simulation.';
        }
      } else {
        if (_currentLayerIndex == 0) {
          // Layer 1 (BLE): Succeeds if the device is connected
          if (_connectionService.isConnected) {
            layerSucceeded = true;
            detail = 'Delivered via connected phone.';
            eventLogger?.addLog('BLE Success', 'Delivered via BLE.', EventCategory.alert);
          } else {
            detail = 'Phone out of BLE range or disconnected.';
            eventLogger?.addLog('BLE Failed', 'BLE fallback failed.', EventCategory.alert);
          }
        } else if (_currentLayerIndex == 1) {
          // Layer 2 (GSM): Simulating high chance of success
          layerSucceeded = true;
          detail = 'Delivered via cellular network.';
          eventLogger?.addLog('GSM Success', 'Delivered via GSM.', EventCategory.alert);
        } else {
          // Layer 3 (Mesh): Fallback
          layerSucceeded = true;
          detail = 'Delivered via nearby node.';
          eventLogger?.addLog('Mesh Success', 'Delivered via Mesh network.', EventCategory.alert);
        }
      }

      if (layerSucceeded) {
        // Mark as succeeded and finish alert
        _updateLayerState(_currentLayerIndex, LayerState.succeeded, detail: detail);
        
        final contacts = _contactRepository.getContacts();
        final notifiedIds = contacts.map((c) => c.id).toList();

        _currentAlert = _currentAlert!.copyWith(
          status: AlertStatus.delivered,
          resolvedAtLayer: _currentLayerIndex + 1,
          notifiedContactIds: notifiedIds,
        );
        
        eventLogger?.addLog('Alert Delivered', 'SOS successfully delivered.', EventCategory.alert);

        _notificationService.notifySosDelivered(_currentAlert!).then((_) {
          eventLogger?.addLog('Notification Sent', 'SOS delivered notification sent.', EventCategory.notification);
        }).catchError((_) {
          eventLogger?.addLog('Notification Failed', 'Failed to send delivery notification.', EventCategory.notification);
        });

        // Save to history
        _alertRepository.addAlert(_currentAlert!);
        notifyListeners();
      } else {
        // Mark as failed and move to next
        _updateLayerState(_currentLayerIndex, LayerState.failed, detail: detail);
        _currentLayerIndex++;
        _processNextLayer();
      }
    });
  }



  void _updateLayerState(int index, LayerState state, {String? detail}) {
    final updatedLayers = List<LayerStatus>.from(_currentAlert!.layers);
    updatedLayers[index] = updatedLayers[index].copyWith(
      state: state,
      detail: detail,
    );
    _currentAlert = _currentAlert!.copyWith(layers: updatedLayers);
    notifyListeners();
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _escalationTimer?.cancel();
    super.dispose();
  }
}

