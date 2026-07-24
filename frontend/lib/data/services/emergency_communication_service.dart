import 'dart:async';
import 'package:lifora/domain/entities/emergency_packet.dart';

/// Abstract interface for the Emergency Communication Module.
///
/// This serves as the boundary between the internal app state (generating
/// the emergency packet) and the external communication mechanisms
/// (BLE, GSM, Mesh networking) that will transmit it.
abstract class EmergencyCommunicationService {
  /// Sends the provided [packet] through the communication layer.
  Future<void> sendPacket(EmergencyPacket packet);
}

/// Mock implementation of [EmergencyCommunicationService] that simply logs
/// the packet transmission. Future implementations (e.g., BleCommunicationService)
/// will handle actual hardware transmission.
class MockEmergencyCommunicationService implements EmergencyCommunicationService {
  @override
  Future<void> sendPacket(EmergencyPacket packet) async {
    // In a real implementation, this is where the packet would be transmitted.
    // For now, we simulate a slight delay and do nothing.
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
