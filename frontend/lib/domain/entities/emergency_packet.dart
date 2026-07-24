import 'package:flutter/foundation.dart';
import 'package:lifora/domain/entities/contact.dart';

enum PacketStatus { pending, ready, sent, delivered, failed, cancelled }

@immutable
class EmergencyPacket {
  final String packetId;
  final DateTime timestamp;
  final String triggerType;
  final double latitude;
  final double longitude;
  final String address;
  final int batteryLevel;
  final String deviceId;
  final String connectionType;
  final List<Contact> contacts;
  final PacketStatus status;
  final String firmwareVersion;
  final String deviceModel;

  const EmergencyPacket({
    required this.packetId,
    required this.timestamp,
    required this.triggerType,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.batteryLevel,
    required this.deviceId,
    required this.connectionType,
    required this.contacts,
    this.status = PacketStatus.pending,
    required this.firmwareVersion,
    required this.deviceModel,
  });

  EmergencyPacket copyWith({
    String? packetId,
    DateTime? timestamp,
    String? triggerType,
    double? latitude,
    double? longitude,
    String? address,
    int? batteryLevel,
    String? deviceId,
    String? connectionType,
    List<Contact>? contacts,
    PacketStatus? status,
    String? firmwareVersion,
    String? deviceModel,
  }) {
    return EmergencyPacket(
      packetId: packetId ?? this.packetId,
      timestamp: timestamp ?? this.timestamp,
      triggerType: triggerType ?? this.triggerType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      deviceId: deviceId ?? this.deviceId,
      connectionType: connectionType ?? this.connectionType,
      contacts: contacts ?? this.contacts,
      status: status ?? this.status,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      deviceModel: deviceModel ?? this.deviceModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packetId': packetId,
      'timestamp': timestamp.toIso8601String(),
      'triggerType': triggerType,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'batteryLevel': batteryLevel,
      'deviceId': deviceId,
      'connectionType': connectionType,
      'contacts': contacts.map((e) => {'id': e.id, 'name': e.name, 'phoneNumber': e.phoneNumber}).toList(),
      'status': status.name,
      'firmwareVersion': firmwareVersion,
      'deviceModel': deviceModel,
    };
  }
}
