import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifora/app/theme/app_colors.dart';
import 'package:lifora/core/location_utils.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/presentation/providers/live_alert_provider.dart';
import 'package:lifora/presentation/widgets/location_map_card.dart';
import 'package:lifora/presentation/widgets/sos_status_ladder.dart';

/// Screen displayed when an SOS alert is active.
///
/// Shows the real-time escalation through the fallback layers.
class LiveAlertScreen extends StatefulWidget {
  const LiveAlertScreen({super.key});

  @override
  State<LiveAlertScreen> createState() => _LiveAlertScreenState();
}

class _LiveAlertScreenState extends State<LiveAlertScreen> {
  @override
  void initState() {
    super.initState();
    // Alert is started automatically by LiveAlertProvider listening to events.
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveAlertProvider>();
    final alert = provider.currentAlert;
    final theme = Theme.of(context);

    // Default state if alert hasn't initialized yet
    if (alert == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isFinished = alert.status == AlertStatus.delivered ||
        alert.status == AlertStatus.cancelled;

    return PopScope(
      canPop: isFinished, // Prevent back navigation while alert is active
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please cancel the alert first.')),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: LiforaColors.alert.withValues(alpha: 0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: LiforaColors.alert.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isFinished
                          ? (alert.status == AlertStatus.delivered
                              ? Icons.check_circle_outline
                              : Icons.cancel_outlined)
                          : Icons.crisis_alert,
                      size: 64,
                      color: isFinished
                          ? (alert.status == AlertStatus.delivered
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.onSurfaceVariant)
                          : LiforaColors.alert,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isFinished
                          ? (alert.status == AlertStatus.delivered
                              ? 'Alert Delivered'
                              : 'Alert Cancelled')
                          : 'SOS Active',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: isFinished
                            ? (alert.status == AlertStatus.delivered
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.onSurfaceVariant)
                            : LiforaColors.alert,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isFinished
                          ? (alert.status == AlertStatus.delivered
                              ? 'Emergency contacts have been notified.'
                              : 'The alert sequence was stopped.')
                          : 'Notifying emergency contacts...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Live alert details
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      LocationMapCard(
                        latitude: provider.latitude,
                        longitude: provider.longitude,
                        address: provider.address,
                        isAddressLoading: provider.isAddressLoading,
                        isLoading: provider.isLocationLoading,
                        errorMessage: provider.locationErrorMessage,
                        addressErrorMessage: provider.addressErrorMessage,
                        onRetry: () {
                          provider.retryLocation();
                        },
                        onOpenMaps: () {
                          LocationUtils.openGoogleMaps(
                            context,
                            provider.latitude,
                            provider.longitude,
                          );
                        },
                        isMapButtonEnabled: LocationUtils.isValidCoordinates(
                          provider.latitude,
                          provider.longitude,
                        ) && !provider.isLocationLoading && provider.locationErrorMessage == null,
                      ),
                      const SizedBox(height: 24),
                      SosStatusLadder(layers: alert.layers),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Padding(
                padding: const EdgeInsets.all(24),
                child: isFinished
                    ? SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: const Text('Return to Home'),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: TextButton.icon(
                          onPressed: () {
                            provider.cancelAlert();
                          },
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel Alert'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
