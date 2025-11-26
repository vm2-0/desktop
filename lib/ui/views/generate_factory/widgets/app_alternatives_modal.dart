import 'dart:ui';

import 'package:clones_desktop/application/apps.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppAlternativesModal extends ConsumerWidget {
  const AppAlternativesModal({
    required this.currentAppName,
    required this.currentAppDomain,
    required this.onSelectAlternative,
    this.filterCategories,
    super.key,
  });

  final String currentAppName;
  final String currentAppDomain;
  final void Function(String name, String domain, String description)
      onSelectAlternative;
  final List<String>? filterCategories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final alternativesAsync = ref.watch(
      getAppAlternativesProvider(
        identifier: currentAppName,
        categories: filterCategories,
      ),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: CardWidget(
            padding: CardPadding.large,
            child: SizedBox(
              width: mediaQuery.size.width * 0.5,
              height: mediaQuery.size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Replace App',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Current: $currentAppName',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: ClonesColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: ClonesColors.secondaryText,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: alternativesAsync.when(
                      data: (alternatives) {
                        if (alternatives.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.apps_outlined,
                                  size: 64,
                                  color: ClonesColors.secondaryText
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No alternatives available yet',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Alternative apps will be added soon',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: ClonesColors.secondaryText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: alternatives.length,
                          itemBuilder: (context, index) {
                            final alt = alternatives[index];
                            final name = alt['name'] as String? ?? 'Unknown';
                            final domain = alt['domain'] as String? ?? '';
                            final description = alt['description'] as String? ??
                                'No description available';
                            final categories =
                                (alt['categories'] as List?)?.cast<String>() ??
                                    [];
                            final relevanceScore =
                                alt['relevanceScore'] as int? ?? 50;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: CardWidget(
                                padding: CardPadding.small,
                                variant: CardVariant.secondary,
                                child: InkWell(
                                  onTap: () {
                                    onSelectAlternative(
                                      name,
                                      domain,
                                      description,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: theme
                                                        .textTheme.titleMedium,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    domain,
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      fontFamily: 'monospace',
                                                      color: ClonesColors
                                                          .secondaryText
                                                          .withValues(
                                                        alpha: 0.8,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getRelevanceColor(
                                                  relevanceScore,
                                                ).withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: _getRelevanceColor(
                                                    relevanceScore,
                                                  ).withValues(alpha: 0.5),
                                                ),
                                              ),
                                              child: Text(
                                                '$relevanceScore% match',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: _getRelevanceColor(
                                                    relevanceScore,
                                                  ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          description,
                                          style: theme.textTheme.bodySmall,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (categories.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 4,
                                            runSpacing: 4,
                                            children:
                                                categories.map((category) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme
                                                      .primaryContainer
                                                      .withValues(alpha: 0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  _formatCategory(category),
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_off_outlined,
                              color: ClonesColors.secondaryText
                                  .withValues(alpha: 0.5),
                              size: 64,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Unable to load alternatives',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Please check your connection and try again',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: ClonesColors.secondaryText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BtnPrimary(
                      buttonText: 'Cancel',
                      onTap: () => Navigator.of(context).pop(),
                      btnPrimaryType: BtnPrimaryType.outlinePrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getRelevanceColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatCategory(String category) {
    return category
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
