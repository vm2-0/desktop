import 'dart:ui';

import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/leaderboard/forge_leader_board.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopForges extends ConsumerStatefulWidget {
  const TopForges({
    super.key,
    required this.forges,
    this.onExpand,
    this.showTitle = true,
    this.listHeight,
  });

  final List<ForgeLeaderboard> forges;
  final VoidCallback? onExpand;
  final bool showTitle;
  final double? listHeight;

  @override
  ConsumerState<TopForges> createState() => _TopForgesState();
}

class _TopForgesState extends ConsumerState<TopForges> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      variant: CardVariant.black,
      padding: CardPadding.none,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showTitle)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Forges',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ClonesColors.primary,
                    ),
                  ),
                  if (widget.onExpand != null)
                    IconButton(
                      icon: const Icon(
                        Icons.fullscreen,
                        color: ClonesColors.secondary,
                      ),
                      onPressed: widget.onExpand,
                      tooltip: 'Fullscreen',
                    ),
                ],
              ),
            ),
          _buildTableHeader(context),
          SizedBox(
            height: widget.listHeight ?? 300,
            child: _buildForgesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ClonesColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tasks Created',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ClonesColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Paid Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ClonesColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgesList() {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(4),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: widget.forges.length,
        itemBuilder: (context, index) {
          final forge = widget.forges[index];
          return Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    forge.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ClonesColors.primaryText,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        forge.tasks > 1
                            ? '${forge.tasks} Tasks'
                            : '${forge.tasks} Task',
                        style: TextStyle(
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatForgePayout(forge),
                        style: TextStyle(
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.3),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatForgePayout(ForgeLeaderboard forge) {
    if (forge.payoutUSD > 0) {
      return '\$${forge.payoutUSD.toStringAsFixedLowValue(2, 5)}';
    }

    if (forge.token != null) {
      return '${forge.payout.toStringAsFixedLowValue(2, 5)} ${forge.token!.symbol}';
    }
    return '${forge.payout.toStringAsFixedLowValue(2, 5)} Tokens';
  }
}

class TopForgesFullscreen extends StatelessWidget {
  const TopForgesFullscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),
        ),
        Center(
          child: Container(
            width: mediaQuery.size.width * 0.9,
            height: mediaQuery.size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: TopForges(
                      forges: (ModalRoute.of(context)?.settings.arguments
                              as List<ForgeLeaderboard>?) ??
                          [],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 24,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_fullscreen,
                        color: ClonesColors.secondary,
                        size: 32,
                      ),
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Positioned(
                    top: 16,
                    left: 32,
                    child: Text(
                      'Top Forges',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ClonesColors.primary,
                      ),
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
}
