import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/entities/layer_status.dart';
import 'package:lifora/domain/repositories/alert_repository.dart';
import 'package:lifora/domain/repositories/contact_repository.dart';
import 'package:lifora/data/services/device_connection_service.dart';

/// View model for the Live Alert Screen.
///
/// Handles the state of an active SOS alert, simulating the escalation
/// through the 3 fallback layers:
/// 1. BLE to Phone
/// 2. GSM / SMS Fallback
/// 3. BLE Mesh Relay
class LiveAlertProvider extends ChangeNotifier {
  LiveAlertProvider({
    required DeviceConnectionService connectionService,
    required AlertRepository alertRepository,
    required ContactRepository contactRepository,
  })  : _connectionService = connectionService,
        _alertRepository = alertRepository,
        _contactRepository = contactRepository;

  final DeviceConnectionService _connectionService;
  final AlertRepository _alertRepository;
  final ContactRepository _contactRepository;

  Alert? _currentAlert;
  Alert? get currentAlert => _currentAlert;

  Timer? _escalationTimer;
  int _currentLayerIndex = 0;

  /// Starts a new SOS alert sequence.
  void startAlert() {
    if (_currentAlert != null && _currentAlert!.status == AlertStatus.inProgress) {
      return; // Already running
    }

    // Initialize the alert state
    _currentAlert = Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      status: AlertStatus.inProgress,
      resolvedAtLayer: 0,
      latitude: 11.0168, // Coimbatore mock location
      longitude: 76.9558,
      notifiedContactIds: [],
      layers: const [
        LayerStatus(layer: 1, label: 'BLE to Phone', state: LayerState.pending),
        LayerStatus(layer: 2, label: 'GSM / SMS Fallback', state: LayerState.pending),
        LayerStatus(layer: 3, label: 'BLE Mesh Relay', state: LayerState.pending),
      ],
    );

    _currentLayerIndex = 0;
    notifyListeners();

    // Trigger the actual hardware/service (simulated here)
    _connectionService.sendSosAlert();

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
    
    // Save to history
    _alertRepository.addAlert(_currentAlert!);
    notifyListeners();
  }

  void _processNextLayer() {
    if (_currentAlert == null || _currentAlert!.status != AlertStatus.inProgress) return;
    if (_currentLayerIndex >= _currentAlert!.layers.length) return;

    // Set current layer to attempting
    _updateLayerState(_currentLayerIndex, LayerState.attempting);

    // Simulate delay for the current layer
    _escalationTimer = Timer(const Duration(seconds: 3), () {
      if (_currentAlert == null || _currentAlert!.status != AlertStatus.inProgress) return;

      // Logic to determine success/failure for the simulation
      bool layerSucceeded = false;
      String? detail;

      if (_currentLayerIndex == 0) {
        // Layer 1 (BLE): Succeeds if the device is connected
        if (_connectionService.isConnected) {
          layerSucceeded = true;
          detail = 'Delivered via connected phone.';
        } else {
          detail = 'Phone out of BLE range or disconnected.';
        }
      } else if (_currentLayerIndex == 1) {
        // Layer 2 (GSM): Simulating high chance of success
        layerSucceeded = true;
        detail = 'Delivered via cellular network.';
      } else {
        // Layer 3 (Mesh): Fallback
        layerSucceeded = true;
        detail = 'Delivered via nearby node.';
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
    _escalationTimer?.cancel();
    super.dispose();
  }
}
