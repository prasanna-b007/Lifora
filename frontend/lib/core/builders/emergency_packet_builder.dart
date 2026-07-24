import 'package:lifora/domain/entities/emergency_packet.dart';
import 'package:lifora/domain/entities/contact.dart';
import 'package:lifora/domain/entities/wearable_event.dart';
import 'package:lifora/domain/entities/device.dart';

class EmergencyPacketBuilder {
  String? _triggerType;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _address = 'Unknown';
  int _batteryLevel = 0;
  String? _deviceId;
  String _connectionType = 'Unknown';
  List<Contact> _contacts = [];
  String _firmwareVersion = 'Unknown';
  String _deviceModel = 'Unknown';

  EmergencyPacketBuilder withDevice(Device device) {
    _deviceId = device.id;
    _batteryLevel = device.batteryLevel;
    _firmwareVersion = device.firmwareVersion;
    _deviceModel = device.name;
    _connectionType = device.isConnected ? 'BLE' : 'Disconnected';
    return this;
  }

  EmergencyPacketBuilder withTrigger(WearableEventType type) {
    _triggerType = type.name;
    return this;
  }

  EmergencyPacketBuilder withLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    return this;
  }

  EmergencyPacketBuilder withAddress(String address) {
    _address = address;
    return this;
  }

  EmergencyPacketBuilder withContacts(List<Contact> contacts) {
    _contacts = contacts;
    return this;
  }

  EmergencyPacket build() {
    return EmergencyPacket(
      packetId: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      triggerType: _triggerType ?? 'Unknown',
      latitude: _latitude,
      longitude: _longitude,
      address: _address,
      batteryLevel: _batteryLevel,
      deviceId: _deviceId ?? 'Unknown',
      connectionType: _connectionType,
      contacts: _contacts,
      firmwareVersion: _firmwareVersion,
      deviceModel: _deviceModel,
      status: PacketStatus.pending,
    );
  }
}
