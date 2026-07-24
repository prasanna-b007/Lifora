import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lifora/core/api_constants.dart';
import 'package:lifora/domain/entities/emergency_packet.dart';

abstract class EmergencyCommunicationService {
  Future<void> sendPacket(EmergencyPacket packet);
}

class TelegramCommunicationService
    implements EmergencyCommunicationService {

  @override
  Future<void> sendPacket(EmergencyPacket packet) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.sendEmergency),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(packet.toJson()),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Failed to send emergency packet");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}