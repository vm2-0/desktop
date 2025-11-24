import 'package:auto_size_text/auto_size_text.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/forge/bloc/provider.dart';
import 'package:clones_desktop/ui/views/forge/bloc/state.dart';
import 'package:clones_desktop/ui/views/forge/layouts/components/forge_existing_factory_card.dart';
import 'package:clones_desktop/ui/views/forge/layouts/components/forge_filter_panel.dart';
import 'package:clones_desktop/ui/views/forge/layouts/components/forge_new_factory_card.dart';
import 'package:clones_desktop/ui/views/generate_factory/layouts/generate_factory_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _searchControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

class ForgeView extends ConsumerStatefulWidget {
  const ForgeView({super.key});

  static const String routeName = '/forge';

  @override
  ConsumerState<ForgeView> createState() => _ForgeViewState();
}

class _ForgeViewState extends ConsumerState<ForgeView> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeIfNeeded();
    });
  }

  void _initializeIfNeeded() {
    if (_hasInitialized) return;

    final session = ref.read(sessionNotifierProvider);
    final forgeState = ref.read(forgeNotifierProvider);
    
    if (session.address != null && !forgeState.isLoading) {
      ref.read(forgeNotifierProvider.notifier).loadFactories();
      _hasInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchController = ref.watch(_searchControllerProvider);

    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));
    if (isConnected == false) {
      return const WalletNotConnected();
    }

    final forgeState = ref.watch(forgeNotifierProvider);
    final forgeNotifier = ref.read(forgeNotifierProvider.notifier);

    // Load factories when wallet address changes
    ref.listen(sessionNotifierProvider.select((s) => s.address), (prev, next) {
      if (next != null && prev != next) {
        _hasInitialized = false;
        forgeNotifier.loadFactories();
        _hasInitialized = true;
      }
    });
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification &&
                  !forgeState.isLoading &&
                  !forgeState.isLoadingMore &&
                  forgeState.hasMoreFactories &&
                  scrollInfo.metrics.pixels > 0 &&
                  scrollInfo.metrics.maxScrollExtent > 0 &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.85) {
                forgeNotifier.loadMoreFactories();
              }
              return false;
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Manage your factories and create new ones to start earning.',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          minFontSize: 14,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildHeader(context, forgeState, forgeNotifier),
                  if (forgeState.showFilters)
                    ForgeFilterPanel(
                      searchController: searchController,
                      allSkills: forgeState.allSkills,
                      selectedSkills: forgeState.selectedSkills,
                      selectedStatus: forgeState.selectedStatus,
                      onSkillSelected: forgeNotifier.onSkillSelected,
                      onSelectAllSkills: forgeNotifier.selectAllSkills,
                      onStatusChanged: forgeNotifier.setSelectedStatus,
                      onApplyFilters: () {
                        forgeNotifier
                          ..setSearchTerm(searchController.text)
                          ..applyFilters();
                      },
                      onResetFilters: () {
                        searchController.clear();
                        forgeNotifier.resetFilters();
                      },
                    ),
                  if (forgeState.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 0.5,
                        ),
                      ),
                    )
                  else
                    _buildFactoriesGrid(forgeState, forgeNotifier, context),
                ],
              ),
            ),
          ),
        ),
        if (ref.watch(forgeNotifierProvider).showGenerateFactoryModal)
          GenerateFactoryModal(
            onClose: () {
              ref
                  .read(forgeNotifierProvider.notifier)
                  .setShowGenerateFactoryModal(false);
            },
          ),
      ],
    );
  }

  Widget _buildFactoriesGrid(
    ForgeState forgeState,
    ForgeNotifier forgeNotifier,
    BuildContext context,
  ) {
    final allItems = [null, ...forgeState.allFactories];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.9,
          ),
          itemCount: allItems.length,
          itemBuilder: (context, index) {
            final factory = allItems[index];
            if (factory == null) {
              return const ForgeNewFactoryCard();
            }
            return ForgeExistingFactoryCard(
              factory: factory,
              onTap: () {
                context.go(
                  '/forge/${factory.id}/general',
                  extra: factory,
                );
              },
            );
          },
        ),
        if (forgeState.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 0.5),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ForgeState forgeState,
    ForgeNotifier forgeNotifier,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Your Factories',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ClonesColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${forgeState.allFactories.length} Available',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  forgeNotifier.setShowFilters(!forgeState.showFilters);
                },
                icon: Icon(
                  forgeState.showFilters
                      ? Icons.keyboard_arrow_up
                      : Icons.filter_list,
                  color: ClonesColors.secondary,
                ),
                label: Text(
                  'Filters',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ClonesColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
