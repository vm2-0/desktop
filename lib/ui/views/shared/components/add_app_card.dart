import 'package:clones_desktop/ui/components/card.dart';
import 'package:flutter/material.dart';

class AddAppCard extends StatelessWidget {
  const AddAppCard({
    super.key,
    required this.onAddApp,
    this.enabled = true,
  });

  final VoidCallback onAddApp;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: enabled ? onAddApp : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(12),
          child: CardWidget(
            padding: CardPadding.small,
            variant: CardVariant.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '+ Add a new app',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: enabled
                        ? theme.textTheme.bodyMedium?.color
                        : theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
