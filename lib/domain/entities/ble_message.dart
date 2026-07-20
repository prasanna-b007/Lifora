import 'package:lifora/domain/entities/packet_type.dart';

class BleMessage {
  final PacketType type;

  final List<int> payload;

  const BleMessage({
    required this.type,
    required this.payload,
  });
}