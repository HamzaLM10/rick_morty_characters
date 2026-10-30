import 'package:flutter/material.dart';

/// Shared "nothing to show" screen (not an error).
class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 96,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
