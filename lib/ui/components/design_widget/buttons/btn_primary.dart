import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

enum BtnPrimaryType { primary, outlinePrimary, dark, important }

class BtnPrimary extends StatelessWidget {
  const BtnPrimary({
    required this.buttonText,
    required this.onTap,
    this.btnPrimaryType = BtnPrimaryType.primary,
    this.isLocked = false,
    this.widthExpanded = false,
    this.isLoading = false,
    this.icon,
    super.key,
  });
  final String buttonText;
  final Function()? onTap;
  final BtnPrimaryType btnPrimaryType;
  final bool isLocked;
  final bool widthExpanded;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isLocked ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLocked ? null : onTap,
        child: widthExpanded
            ? _button(context)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [_button(context)],
              ),
      ),
    );
  }

  Widget _button(
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 40),
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8.5),
          alignment: Alignment.center,
          decoration: _getButtonDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding:
                      EdgeInsets.only(right: buttonText.isNotEmpty ? 8 : 0),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
              if (buttonText.isNotEmpty)
                Text(
                  buttonText,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: isLocked
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration? _getButtonDecoration() {
    switch (btnPrimaryType) {
      case BtnPrimaryType.primary:
        return BoxDecoration(
          gradient: ClonesColors.gradientBtnPrimary,
          borderRadius: BorderRadius.circular(8),
        );
      case BtnPrimaryType.outlinePrimary:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: GradientBoxBorder(
            gradient: ClonesColors.gradientBtnPrimary,
            width: 2,
          ),
        );
      case BtnPrimaryType.dark:
        return BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        );
      case BtnPrimaryType.important:
        return BoxDecoration(
          color: ClonesColors.important,
          borderRadius: BorderRadius.circular(8),
        );
    }
  }
}
