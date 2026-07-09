import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/domain/entities/wearable_event.dart';
import 'device_connection_service.dart';

/// Centralized state and simulation engine for a virtual Lifora wearable.
///
/// Implements [DeviceConnectionService] and extends [ChangeNotifier] to provide
/// a single reactive source of truth for the entire app.
class VirtualWearableService extends DeviceConnectionService {
  final String deviceId = 'lifora-virtual-001';
  final List<WearableEvent> _eventLog = [];
  final StreamController<WearableEvent> _eventController = StreamController<WearableEvent>.broadcast();

  int? _forcedEscalationLayer;
  int _rssi = -65;

  Device _currentDevice;

  VirtualWearableService()
      : _currentDevice = Device(
          id: 'lifora-virtual-001',
          name: 'Lifora Band',
          model: 'ESP32-C3',
          batteryLevel: 78,
          firmwareVersion: 'v1.2.0',
          isConnected: true,
          lastSynced: DateTime.now(),
        );

  // --- DeviceConnectionService Implementation ---

  @override
  bool get isConnected => _currentDevice.isConnected;

  @override
  int get batteryLevel => _currentDevice.batteryLevel;

  @override
  Device get device => _currentDevice;

  @override
  Stream<WearableEvent> get events => _eventController.stream;

  @override
  Future<void> connect(String targetDeviceId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _rssi = -65;
    _updateDevice(isConnected: true, lastSynced: DateTime.now());
    _emitEvent(WearableEventType.connected);
  }

  @override
  Future<void> disconnect() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _rssi = -100;
    _updateDevice(isConnected: false);
    _emitEvent(WearableEventType.disconnected);
  }

  @override
  Future<void> sendSosAlert() async {
    _emitEvent(WearableEventType.manualSos);
  }

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }

  // --- Internal State Management ---

  void _updateDevice({
    bool? isConnected,
    int? batteryLevel,
    String? firmwareVersion,
    DateTime? lastSynced,
  }) {
    _currentDevice = _currentDevice.copyWith(
      isConnected: isConnected,
      batteryLevel: batteryLevel,
      firmwareVersion: firmwareVersion,
      lastSynced: lastSynced,
    );
    notifyListeners();
  }

  void _emitEvent(WearableEventType type, {Map<String, dynamic>? additionalPayload}) {
    final payload = <String, dynamic>{
      'batteryLevel': _currentDevice.batteryLevel,
      'rssi': _rssi,
      'isConnected': _currentDevice.isConnected,
      if (additionalPayload != null) ...additionalPayload,
    };
    
    if ((type == WearableEventType.tripleTap || 
         type == WearableEventType.longPress || 
         type == WearableEventType.fall || 
         type == WearableEventType.whistle) && 
         _forcedEscalationLayer != null) {
      payload['forcedOutcomeLayer'] = _forcedEscalationLayer;
      _forcedEscalationLayer = null;
    }

    final event = WearableEvent(
      deviceId: deviceId,
      type: type,
      timestamp: DateTime.now(),
      payload: payload,
    );
    
    _eventLog.add(event);
    _eventController.add(event);
  }

  // --- Developer Mode API ---

  int get rssi => _rssi;

  void triggerTripleTap() => _emitEvent(WearableEventType.tripleTap);
  void triggerLongPress() => _emitEvent(WearableEventType.longPress);
  void triggerFall() => _emitEvent(WearableEventType.fall);
  void triggerWhistle() => _emitEvent(WearableEventType.whistle);

  void setBatteryLevel(int level) {
    final clamped = level.clamp(0, 100);
    if (_currentDevice.batteryLevel != clamped) {
      _updateDevice(batteryLevel: clamped);
      _emitEvent(WearableEventType.batteryChanged, additionalPayload: {'newLevel': clamped});
    }
  }

  void setRssi(int newRssi) {
    if (_rssi != newRssi) {
      _rssi = newRssi;
      notifyListeners(); // Notify UI that RSSI changed
    }
  }

  void simulateFirmwareUpdate(String version) {
    if (_currentDevice.firmwareVersion != version) {
      _updateDevice(firmwareVersion: version);
      _emitEvent(WearableEventType.firmwareUpdated, additionalPayload: {'newVersion': version});
    }
  }

  void forceEscalationOutcome(int layer) {
    _forcedEscalationLayer = layer;
  }

  List<WearableEvent> getLog() => List.unmodifiable(_eventLog);

  void clearLog() => _eventLog.clear();

  String exportLogAsJson() {
    final list = _eventLog.map((e) => {
      'deviceId': e.deviceId,
      'type': e.type.name,
      'timestamp': e.timestamp.toIso8601String(),
      'payload': e.payload,
    }).toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }
}
