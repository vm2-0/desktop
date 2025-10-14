import 'dart:ui';

import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class PopupTemplate extends StatelessWidget {
  const PopupTemplate({
    super.key,
    required this.popupContent,
    required this.popupTitle,
    this.popupHeight,
    this.warningCloseLabel = '',
    this.warningCloseFunction,
    this.displayCloseButton = true,
  });

  final Widget popupContent;
  final String popupTitle;
  final double? popupHeight;
  final String warningCloseLabel;
  final Function? warningCloseFunction;
  final bool displayCloseButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent.withAlpha(120),
            body: AlertDialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 30, right: 15, left: 8),
                        padding: const EdgeInsets.all(20),
                        height: popupHeight,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: ClonesColors.secondary,
                          ),
                        ),
                        child: popupHeight == null
                            ? SingleChildScrollView(
                                child: Wrap(
                                  children: [popupContent],
                                ),
                              )
                            : popupContent,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: SelectionArea(
                              child: Text(
                                popupTitle,
                                style: theme.textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (displayCloseButton)
                    Positioned(
                      top: -7,
                      right: 4,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_outlined,
                          size: 16,
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
