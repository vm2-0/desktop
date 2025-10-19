import 'package:cached_network_image/cached_network_image.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/dialog.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/fav_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppHeaderWidget extends ConsumerStatefulWidget {
  const AppHeaderWidget({
    super.key,
    required this.app,
    required this.appIdx,
  });
  final FactoryApp app;
  final int appIdx;

  @override
  ConsumerState<AppHeaderWidget> createState() => _AppHeaderWidgetState();
}

class _AppHeaderWidgetState extends ConsumerState<AppHeaderWidget> {
  int? editingAppIdx;
  String? editingAppField; // 'name' or 'domain'
  String editValue = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // App icon
        if (widget.app.domain.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ClonesColors.containerIcon5.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CachedNetworkImage(
              imageUrl: getFaviconUrl(widget.app.domain),
              width: 24,
              height: 24,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => const Icon(
                Icons.apps,
                color: ClonesColors.primaryText,
                size: 24,
              ),
            ),
          ),
        const SizedBox(width: 10),
        // App name (editable)
        if (editingAppIdx == widget.appIdx && editingAppField == 'name')
          Row(
            children: [
              SizedBox(
                width: 120,
                child: TextField(
                  autofocus: true,
                  controller: TextEditingController(text: editValue),
                  onChanged: (v) => setState(() => editValue = v),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                // TODO(reddwarf03): Add edit app
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.close),
                // TODO(reddwarf03): Add edit app
                onPressed: () {},
              ),
            ],
          )
        else
          GestureDetector(
            // TODO(reddwarf03): Add edit app
            onTap: () {},
            child: Text(
              widget.app.name,
              style: theme.textTheme.titleMedium,
            ),
          ),
        const SizedBox(width: 8),
        // App domain (editable)
        if (editingAppIdx == widget.appIdx && editingAppField == 'domain')
          Row(
            children: [
              SizedBox(
                width: 120,
                child: TextField(
                  autofocus: true,
                  controller: TextEditingController(text: editValue),
                  onChanged: (v) => setState(() => editValue = v),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.check,
                  color: ClonesColors.primaryText,
                ),
                // TODO(reddwarf03): Add edit app
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.close),
                // TODO(reddwarf03): Add edit app
                onPressed: () {},
              ),
            ],
          )
        else
          GestureDetector(
            // TODO(reddwarf03): Add edit app
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                widget.app.domain,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        const Spacer(),
        // Delete app button
        InkWell(
          onTap: () async {
            await AppDialogs.showConfirmDialog(
              context,
              ref,
              'Confirm Deletion',
              'Are you sure you want to delete this app and all its tasks?',
              'Delete',
              () async {
                ref
                    .read(forgeDetailNotifierProvider.notifier)
                    .removeApp(widget.appIdx);
              },
            );
          },
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.red.withValues(alpha: 0.8),
              BlendMode.srcATop,
            ),
            child: Image.asset(
              Assets.deleteIcon,
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }
}
