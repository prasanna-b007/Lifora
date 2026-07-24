import 'package:flutter/foundation.dart';
import 'package:lifora/domain/entities/emergency_packet.dart';
import 'package:lifora/core/builders/emergency_packet_builder.dart';
import 'package:lifora/domain/entities/wearable_event.dart';
import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/domain/entities/contact.dart';
import 'package:lifora/presentation/providers/event_log_provider.dart';
import 'package:lifora/domain/entities/event_log.dart';
import 'package:lifora/data/services/emergency_communication_service.dart';

class EmergencyPacketProvider extends ChangeNotifier {
  final EmergencyCommunicationService _communicationService;
  final EventLogProvider? _eventLogger;

  EmergencyPacketProvider({
    required EmergencyCommunicationService communicationService,
    EventLogProvider? eventLogger,
  })  : _communicationService = communicationService,
        _eventLogger = eventLogger;

  EmergencyPacket? _latestPacket;
  EmergencyPacket? get latestPacket => _latestPacket;

  void generatePacket({
    required Device device,
    required WearableEventType triggerType,
    required double latitude,
    required double longitude,
    required String address,
    required List<Contact> contacts,
  }) {
    final builder = EmergencyPacketBuilder()
        .withDevice(device)
        .withTrigger(triggerType)
        .withLocation(latitude, longitude)
        .withAddress(address)
        .withContacts(contacts);

    _latestPacket = builder.build();

    // Log the event
    _eventLogger?.addLog(
      'Emergency Packet Created',
      'Packet ID: ${_latestPacket!.packetId}\nTrigger: ${_latestPacket!.triggerType}',
      EventCategory.system,
    );

    // Pass it to the communication service for further processing
    _communicationService.sendPacket(_latestPacket!);

    notifyListeners();
  }

  void clearPacket() {
    _latestPacket = null;
    notifyListeners();
  }
}
