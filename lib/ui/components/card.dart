import 'dart:ui';

import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

enum CardVariant { primary, secondary, black, transparent }

enum CardPadding { none, small, medium, large }

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    this.variant = CardVariant.primary,
    this.padding = CardPadding.medium,
    required this.child,
    this.className,
  });
  final CardVariant variant;
  final CardPadding padding;
  final Widget child;
  final String? className;

  EdgeInsets _getPadding() {
    switch (padding) {
      case CardPadding.none:
        return EdgeInsets.zero;
      case CardPadding.small:
        return const EdgeInsets.all(8);
      case CardPadding.medium:
        return const EdgeInsets.all(16);
      case CardPadding.large:
        return const EdgeInsets.all(24);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: _getPadding(),
            decoration: BoxDecoration(
              color: variant == CardVariant.primary
                  ? ClonesColors.primary.withValues(alpha: 0.1)
                  : variant == CardVariant.secondary
                      ? ClonesColors.secondary.withValues(alpha: 0.1)
                      : variant == CardVariant.black
                          ? Colors.black.withValues(alpha: 0.5)
                          : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: variant == CardVariant.primary
                    ? ClonesColors.primary.withValues(alpha: 0.2)
                    : variant == CardVariant.secondary
                        ? ClonesColors.secondary.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
