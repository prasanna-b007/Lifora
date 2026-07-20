import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapCard extends StatelessWidget {
  const LocationMapCard({
    super.key,
    required this.latitude,
    required this.longitude,
    this.address,
    this.isAddressLoading = false,
    this.isLoading = false,
    this.errorMessage,
    this.addressErrorMessage,
    this.onOpenMaps,
    this.isMapButtonEnabled = false,
  });

  final double latitude;
  final double longitude;
  final String? address;
  final bool isAddressLoading;
  final bool isLoading;
  final String? errorMessage;
  final String? addressErrorMessage;
  final void Function()? onOpenMaps;
  final bool isMapButtonEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Location',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              SizedBox(
                height: 220,
                child: Center(
                  child: Text(
                    'Loading location...',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else if (errorMessage != null)
              SizedBox(
                height: 220,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '📍 Location Unavailable',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        errorMessage!,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(latitude, longitude),
                      initialZoom: 14.2,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.lifora',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(latitude, longitude),
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.location_on,
                              color: colorScheme.primary,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (!isLoading && errorMessage == null) ...[
              const SizedBox(height: 16),
              Text(
                'Current Address',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              if (isAddressLoading)
                Text(
                  'Loading address...',
                  style: theme.textTheme.bodyMedium,
                )
              else if (addressErrorMessage != null)
                Text(
                  addressErrorMessage!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                )
              else if (address != null)
                Text(
                  address!,
                  style: theme.textTheme.bodyMedium,
                )
              else
                Text(
                  'Address unavailable',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Latitude',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                latitude.toStringAsFixed(5),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Longitude',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                longitude.toStringAsFixed(5),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isMapButtonEnabled ? onOpenMaps : null,
                  icon: const Icon(Icons.map),
                  label: const Text('Open in Google Maps'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              if (!isMapButtonEnabled)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Location unavailable',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
