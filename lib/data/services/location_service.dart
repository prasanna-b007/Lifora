/// Represents a geographic location snapshot.
class LocationResult {
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });
}

/// Abstract interface for obtaining the user's current geographic location.
abstract class LocationService {
  /// Attempts to retrieve the current location.
  /// Handles permission requests if necessary.
  /// Throws or returns default/mock location if permissions are permanently denied.
  Future<LocationResult> getCurrentLocation();
}
