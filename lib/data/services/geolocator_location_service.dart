import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lifora/data/services/location_service.dart';
import 'package:lifora/data/services/mock_location_service.dart';

class GeolocatorLocationService implements LocationService {
  final LocationService _fallback = MockLocationService();

  @override
  Future<LocationResult> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return fallback
      return _fallback.getCurrentLocation();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return fallback
        return _fallback.getCurrentLocation();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, return fallback
      return _fallback.getCurrentLocation();
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      final position = await Geolocator.getCurrentPosition();
      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
        isMockLocation: false,
      );
    } catch (e) {
      return _fallback.getCurrentLocation();
    }
  }

  @override
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) {
        return 'Address unavailable';
      }

      final place = placemarks.first;
      final addressParts = [
        place.name,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((part) => part != null && part.isNotEmpty).join(', ');

      return addressParts.isNotEmpty ? addressParts : 'Address unavailable';
    } catch (_) {
      return 'Address unavailable';
    }
  }
}
