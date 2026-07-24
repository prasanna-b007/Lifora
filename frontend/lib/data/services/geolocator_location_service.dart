import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lifora/data/services/location_service.dart';

class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationResult> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled at OS level
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('GeolocatorLocationService: Location services are disabled.');
      throw Exception('Location services are disabled.');
    }

    // 2. Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('GeolocatorLocationService: Location permissions are denied.');
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('GeolocatorLocationService: Location permissions are permanently denied.');
      throw Exception('Location permissions are permanently denied.');
    }

    // 3. Fetch location
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );
      
      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
        isMockLocation: false,
      );
    } catch (e, stackTrace) {
      debugPrint('GeolocatorLocationService: Exception during getCurrentPosition: $e\n$stackTrace');
      throw Exception('Failed to get location: $e');
    }
  }

  @override
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude).timeout(const Duration(seconds: 8));
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
