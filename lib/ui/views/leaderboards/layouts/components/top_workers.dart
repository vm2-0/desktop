import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/leaderboard/worker_leader_board.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopWorkers extends ConsumerStatefulWidget {
  const TopWorkers({
    super.key,
    required this.workers,
    this.showTitle = true,
    this.listHeight,
    this.onExpand,
  });

  final List<WorkerLeaderboard> workers;
  final bool showTitle;
  final double? listHeight;
  final VoidCallback? onExpand;

  @override
  ConsumerState<TopWorkers> createState() => _TopWorkersState();
}

class _TopWorkersState extends ConsumerState<TopWorkers> {
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
                    'Top Workers',
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
            child: _buildWorkersList(),
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
            child: Row(
              children: [
                Text(
                  'Address',
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
                  'Average Grade',
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
                  'Tasks Completed',
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
                  'Rewards',
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

  Widget _buildWorkersList() {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(4),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: widget.workers.length,
        itemBuilder: (context, index) {
          final worker = widget.workers[index];
          return Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _truncateAddress(worker.address),
                              style: const TextStyle(
                                color: ClonesColors.primaryText,
                              ),
                            ),
                            const TextSpan(
                              text: '',
                              style: TextStyle(
                                color: ClonesColors.secondary,
                              ),
                            ),
                          ],
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
                        '${worker.avgScore.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.green,
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
                        worker.tasks > 1
                            ? '${worker.tasks} Tasks'
                            : '${worker.tasks} Task',
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
                        _formatWorkerRewards(worker),
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

  String _truncateAddress(String address) {
    if (address.isEmpty) return '';
    return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
  }

  String _formatWorkerRewards(WorkerLeaderboard worker) {
    if (worker.totalUSD > 0) {
      return '\$${worker.totalUSD.toStringAsFixedLowValue(2, 5)}';
    }

    if (worker.tokens.isEmpty) {
      return '${worker.rewards?.toStringAsFixedLowValue(2, 5)} Tokens';
    }

    if (worker.tokens.length == 1) {
      final token = worker.tokens.first.token;
      return '${worker.rewards?.toStringAsFixedLowValue(2, 5)} ${token.symbol}';
    }

    // Multiple tokens - show total with "Mixed" indicator
    return '${worker.rewards?.toStringAsFixedLowValue(2, 5)} Mixed';
  }
}
