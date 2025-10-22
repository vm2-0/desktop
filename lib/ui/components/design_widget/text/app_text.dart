import 'package:cached_network_image/cached_network_image.dart';
import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.text,
    required this.style,
    required this.iconUrl,
  });
  final String text;
  final TextStyle? style;
  final String iconUrl;

  List<Part> parseText(String text) {
    final parts = <Part>[];
    var currentText = '';
    var inAppTag = false;
    var appName = '';

    for (var i = 0; i < text.length; i++) {
      if (!inAppTag && text.startsWith('<app>', i)) {
        if (currentText.isNotEmpty) {
          parts.add(Part(type: PartType.text, content: currentText));
          currentText = '';
        }
        inAppTag = true;
        i += 4; // skip <app>
      } else if (inAppTag && text.startsWith('</app>', i)) {
        parts.add(Part(type: PartType.app, content: appName.trim()));
        appName = '';
        inAppTag = false;
        i += 5; // skip </app>
      } else if (inAppTag) {
        appName += text[i];
      } else {
        currentText += text[i];
      }
    }
    if (currentText.isNotEmpty) {
      parts.add(Part(type: PartType.text, content: currentText));
    }
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    final parts = parseText(text);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: parts.map((part) {
        if (part.type == PartType.text) {
          return Text(
            part.content,
            style: style,
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: iconUrl,
                  width: 16,
                  height: 16,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (_, __, ___) => Icon(
                    Icons.web,
                    size: 16,
                    color: ClonesColors.secondaryText,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  part.content,
                  style: style,
                ),
              ],
            ),
          );
        }
      }).toList(),
    );
  }
}

enum PartType { text, app }

class Part {
  Part({required this.type, required this.content});
  final PartType type;
  final String content;
}
