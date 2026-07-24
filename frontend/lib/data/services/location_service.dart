/// Represents a geographic location snapshot.
class LocationResult {
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;
  final bool isMockLocation;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    this.isMockLocation = false,
  });
}

/// Abstract interface for obtaining the user's current geographic location.
abstract class LocationService {
  /// Attempts to retrieve the current location.
  /// Handles permission requests if necessary.
  /// Throws or returns default/mock location if permissions are permanently denied.
  Future<LocationResult> getCurrentLocation();

  /// Returns a human-readable postal address for the provided coordinates.
  ///
  /// If reverse geocoding fails, implementations should return a readable
  /// fallback string such as 'Address unavailable'.
  Future<String> getAddressFromCoordinates(double latitude, double longitude);
}
