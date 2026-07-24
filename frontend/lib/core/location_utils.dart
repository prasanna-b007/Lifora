import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationUtils {
  LocationUtils._();

  static bool isValidCoordinates(double latitude, double longitude) {
    if (latitude.isNaN || longitude.isNaN) {
      return false;
    }

    if (latitude == 0.0 && longitude == 0.0) {
      return false;
    }

    return latitude >= -90.0 && latitude <= 90.0 && longitude >= -180.0 && longitude <= 180.0;
  }

  static Uri googleMapsSearchUri(double latitude, double longitude) {
    return Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': '${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}',
      },
    );
  }

  static Future<void> openGoogleMaps(
    BuildContext context,
    double latitude,
    double longitude,
  ) async {
    final uri = googleMapsSearchUri(latitude, longitude);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        if (context.mounted) {
          _showLaunchError(context);
        }
      }
    } catch (_) {
      if (context.mounted) {
        _showLaunchError(context);
      }
    }
  }

  static void _showLaunchError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unable to open Google Maps.'),
      ),
    );
  }
}
