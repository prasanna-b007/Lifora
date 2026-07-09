import 'package:lifora/data/services/location_service.dart';

/// Mock implementation that returns a fixed coordinate (Coimbatore).
class MockLocationService implements LocationService {
  @override
  Future<LocationResult> getCurrentLocation() async {
    return LocationResult(
      latitude: 11.0168,
      longitude: 76.9558,
      accuracy: 0.0,
      timestamp: DateTime.now(),
    );
  }
}
