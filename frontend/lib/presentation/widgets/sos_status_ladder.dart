import 'package:flutter/material.dart';
import 'package:lifora/app/theme/app_colors.dart';
import 'package:lifora/domain/entities/layer_status.dart';

/// A widget that displays the real-time progression of the SOS fallback layers.
class SosStatusLadder extends StatelessWidget {
  const SosStatusLadder({super.key, required this.layers});

  final List<LayerStatus> layers;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(layers.length, (index) {
        final layer = layers[index];
        final isLast = index == layers.length - 1;
        return _LayerNode(layer: layer, isLast: isLast);
      }),
    );
  }
}

class _LayerNode extends StatelessWidget {
  const _LayerNode({required this.layer, required this.isLast});

  final LayerStatus layer;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline graphics
          SizedBox(
            width: 32,
            child: Column(
              children: [
                _buildIndicator(theme),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: _getLineColor(theme),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Layer ${layer.layer}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: _getTextColor(theme),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _buildStateBadge(theme),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    layer.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: _getTextColor(theme),
                    ),
                  ),
                  if (layer.detail != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      layer.detail!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: layer.state == LayerState.failed
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(ThemeData theme) {
    if (layer.state == LayerState.attempting) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: LiforaColors.alert.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(4),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(LiforaColors.alert),
        ),
      );
    }

    Color color;
    IconData? icon;

    switch (layer.state) {
      case LayerState.succeeded:
        color = theme.colorScheme.secondary;
        icon = Icons.check;
        break;
      case LayerState.failed:
        color = theme.colorScheme.error;
        icon = Icons.close;
        break;
      case LayerState.pending:
      default:
        color = theme.colorScheme.outlineVariant;
        icon = null;
        break;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: icon != null ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: icon != null ? color : theme.colorScheme.outlineVariant,
          width: 2,
        ),
      ),
      child: icon != null
          ? Icon(icon, size: 14, color: theme.colorScheme.onPrimary)
          : null,
    );
  }

  Color _getLineColor(ThemeData theme) {
    if (layer.state == LayerState.succeeded || layer.state == LayerState.failed) {
      return theme.colorScheme.outlineVariant;
    }
    return theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
  }

  Color _getTextColor(ThemeData theme) {
    if (layer.state == LayerState.pending) {
      return theme.colorScheme.onSurfaceVariant;
    }
    return theme.colorScheme.onSurface;
  }

  Widget _buildStateBadge(ThemeData theme) {
    String text;
    Color color;

    switch (layer.state) {
      case LayerState.succeeded:
        text = 'Succeeded';
        color = theme.colorScheme.secondary;
        break;
      case LayerState.failed:
        text = 'Failed';
        color = theme.colorScheme.error;
        break;
      case LayerState.attempting:
        text = 'Attempting';
        color = LiforaColors.alert;
        break;
      case LayerState.pending:
        text = 'Pending';
        color = theme.colorScheme.onSurfaceVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
