import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/domain/entities/wearable_event.dart';

import 'device_connection_service.dart';

/// Real BLE implementation using flutter_blue_plus.
///
/// Currently a stub — will be fully implemented when the ESP32-C3
/// hardware is ready for integration.
///
/// **This is the ONLY file in the project that imports flutter_blue_plus.**
/// All other code accesses BLE through the [DeviceConnectionService] interface.
class BleDeviceConnectionService extends DeviceConnectionService {
  // Will be used once BLE logic is implemented.
  // ignore: unused_field
  FlutterBluePlus? _flutterBluePlus;

  @override
  bool get isConnected => throw UnimplementedError(
        'TODO: Read real BLE connection state from flutter_blue_plus.',
      );

  @override
  int get batteryLevel => throw UnimplementedError(
        'TODO: Read battery level characteristic from the connected device.',
      );

  @override
  Device get device => throw UnimplementedError(
        'TODO: Maintain the current Device state locally and return it here.',
      );

  @override
  Stream<WearableEvent> get events => throw UnimplementedError(
        'TODO: Parse incoming BLE notifications into WearableEvent stream.',
      );

  @override
  Future<void> connect(String deviceId) {
    // TODO: Scan for the device by ID, connect via flutter_blue_plus,
    //       discover services, and subscribe to characteristics.
    throw UnimplementedError(
      'TODO: Implement BLE device connection using flutter_blue_plus.',
    );
  }

  @override
  Future<void> disconnect() {
    // TODO: Disconnect from the currently connected BLE peripheral
    //       and clean up subscriptions.
    throw UnimplementedError(
      'TODO: Implement BLE device disconnection using flutter_blue_plus.',
    );
  }

  @override
  Future<void> sendSosAlert() {
    // TODO: Write the SOS trigger value to the appropriate BLE
    //       characteristic on the ESP32-C3 device.
    throw UnimplementedError(
      'TODO: Implement SOS alert transmission over BLE.',
    );
  }
}
