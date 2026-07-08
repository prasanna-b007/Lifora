import 'dart:async';

import 'package:lifora/domain/entities/device.dart';

/// Abstract interface for managing the BLE connection to a Lifora wearable.
///
/// All application code accesses device connectivity through this interface,
/// enabling easy swapping between:
///   - [MockDeviceConnectionService] for development and testing
///   - [BleDeviceConnectionService] for real hardware integration
///
/// The interface exposes connection state, battery level, a reactive device
/// stream, and commands for connecting, disconnecting, and sending SOS alerts.
abstract class DeviceConnectionService {
  /// Whether the device is currently connected.
  bool get isConnected;

  /// The current battery level of the connected device (0–100).
  int get batteryLevel;

  /// A stream that emits updated [Device] state whenever it changes.
  ///
  /// Subscribers receive the latest device info including connection
  /// status, battery level, and last sync time.
  Stream<Device> get deviceStream;

  /// Initiates a connection to the device with the given [deviceId].
  ///
  /// The returned future completes when the connection is established
  /// (or fails with an error).
  Future<void> connect(String deviceId);

  /// Disconnects from the currently connected device.
  ///
  /// The returned future completes when the disconnection is confirmed.
  Future<void> disconnect();

  /// Sends an SOS alert through the connected device.
  ///
  /// This triggers the hardware alert sequence on the wearable.
  /// The returned future completes when the alert has been acknowledged
  /// by the device.
  Future<void> sendSosAlert();
}
