import 'package:cached_network_image/cached_network_image.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/utils/fav_tools.dart';
import 'package:flutter/material.dart';

class AppChipWidget extends StatelessWidget {
  const AppChipWidget({
    super.key,
    required this.appName,
    required this.domain,
    required this.index,
  });

  final String appName;
  final String domain;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColors = [
      ClonesColors.containerIcon1,
      ClonesColors.containerIcon2,
      ClonesColors.containerIcon3,
      ClonesColors.containerIcon4,
      ClonesColors.containerIcon5,
      ClonesColors.containerIcon6,
    ];

    final color = chipColors[index % chipColors.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withAlpha(60),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: domain == 'desktop'
                ? Icon(
                    Icons.desktop_mac_sharp,
                    size: 16,
                    color: color.withValues(alpha: 0.4),
                  )
                : CachedNetworkImage(
                    imageUrl: getFaviconUrl(domain),
                    width: 16,
                    height: 16,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
          ),
          Text(
            appName,
            style: theme.textTheme.bodySmall!.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
