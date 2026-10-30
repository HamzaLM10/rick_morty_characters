import 'package:flutter/material.dart';
import 'package:rick_morty_characters/core/error/app_exception.dart';

/// Shared error screen: icon + message + Retry.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.exception, required this.onRetry});

  final AppException exception;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = switch (exception) {
      NoInternetException() ||
      RequestTimeoutException() => Icons.wifi_off_rounded,
      _ => Icons.error_outline_rounded,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 96, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              exception.message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
