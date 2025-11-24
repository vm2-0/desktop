import 'package:clones_desktop/domain/models/factory/factory.dart';

import 'package:flutter/material.dart';

class FactoryStatusBadge extends StatelessWidget {
  const FactoryStatusBadge({super.key, required this.status});
  final FactoryStatus status;

  @override
  Widget build(BuildContext context) {
    Color badgeColor = Colors.grey;
    Color textColor = Colors.grey;
    var statusText = '';

    switch (status) {
      case FactoryStatus.active:
        badgeColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        statusText = 'ACTIVE';
        break;
      case FactoryStatus.paused:
        badgeColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        statusText = 'PAUSED';
        break;
      case FactoryStatus.error:
        badgeColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        statusText = 'ERROR';
        break;
      case FactoryStatus.noFunds:
        badgeColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        statusText = 'NO FUNDS';
        break;
      case FactoryStatus.archived:
        badgeColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        statusText = 'ARCHIVED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
