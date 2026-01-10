import 'dart:ui';

import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/create_dataset/bloc/provider.dart';
import 'package:clones_desktop/ui/views/create_dataset/layouts/create_dataset_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateDatasetModalContainer extends ConsumerWidget {
  const CreateDatasetModalContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              ref.read(createDatasetNotifierProvider.notifier).reset();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        Center(
          child: RepaintBoundary(
            child: CardWidget(
              padding: CardPadding.large,
              child: SizedBox(
                width: mediaQuery.size.width * 0.5,
                height: mediaQuery.size.height * 0.8,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create Dataset',
                        style: theme.textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(createDatasetNotifierProvider.notifier).reset();
                        },
                        icon: Icon(
                          Icons.close,
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Expanded(
                    child: CreateDatasetModal(),
                  ),
                ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
