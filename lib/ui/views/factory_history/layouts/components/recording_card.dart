import 'package:clones_desktop/application/recording.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/upload/provider.dart';
import 'package:clones_desktop/application/upload/state.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/recording/api_recording.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/dialog.dart';
import 'package:clones_desktop/ui/components/memory_image_tauri.dart';
import 'package:clones_desktop/ui/components/score_indicator.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Check if the recording has already been claimed on-chain
/// Ignore CLAIMING_ markers (temporary locks)
// TODO: Doublon. Extract to a utility function.
bool _isAlreadyClaimed(ApiRecording recording) {
  final txHash = recording.submission?.onChainReward?.txHash;
  if (txHash == null || txHash.isEmpty) {
    return false;
  }
  // Ignore temporary CLAIMING_ markers
  return !txHash.startsWith('CLAIMING_');
}

class RecordingCard extends ConsumerWidget {
  const RecordingCard({super.key, required this.recording});

  final ApiRecording recording;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadQueue = ref.watch(uploadQueueProvider);
    final uploadItem = uploadQueue[recording.id];

    final maxReward = recording.demonstration?.reward?.maxReward ??
        recording.submission?.meta.demonstration.reward?.maxReward ??
        0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          context.push(DemoDetailView.routeName, extra: recording.id);
        },
        child: CardWidget(
          padding: CardPadding.none,
          variant: CardVariant.secondary,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildIcon(context),
                const SizedBox(width: 10),
                Expanded(child: _buildTitleAndMeta(context)),
                _buildStatus(context, uploadItem),
                _buildActions(context, ref, uploadItem, maxReward),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final iconUrl = recording.demonstration?.iconUrl ??
        recording.submission?.meta.demonstration.iconUrl;
    return SizedBox(
      width: 32,
      height: 32,
      child: iconUrl != null
          ? MemoryImageTauri(
              imageUrl: iconUrl,
              width: 32,
              height: 32,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.apps,
                color: ClonesColors.primaryText,
                size: 24,
              ),
            )
          : Icon(Icons.apps, color: ClonesColors.secondaryText),
    );
  }

  Widget _buildTitleAndMeta(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recording.title,
          style: theme.textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.schedule, size: 12, color: ClonesColors.secondaryText),
            const SizedBox(width: 4),
            Text(
              formatDurationFromSeconds(recording.durationSeconds),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today,
              size: 12,
              color: ClonesColors.secondaryText,
            ),
            const SizedBox(width: 4),
            Text(
              '${DateFormat.yMd().format(DateTime.parse(recording.timestamp))} ${DateFormat.jm().format(DateTime.parse(recording.timestamp))}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Icon(
              recording.location == 'local'
                  ? Icons.folder_outlined
                  : Icons.cloud_outlined,
              size: 12,
              color: ClonesColors.secondaryText,
            ),
            const SizedBox(width: 4),
            Text(
              recording.location == 'local' ? 'Local' : 'Cloud',
              style: theme.textTheme.bodySmall?.copyWith(
                color: ClonesColors.secondaryText,
              ),
            ),
          ],
        ),
        _rewardClaimedBadge(context),
      ],
    );
  }

  Widget _buildStatus(BuildContext context, UploadTaskState? uploadItem) {
    final status = recording.submission?.status ?? recording.status;
    if (uploadItem?.uploadStatus == UploadStatus.error || status == 'failed') {
      return _statusChip(
        context,
        'Upload Failed',
        Icons.error_outline,
        Colors.red,
      );
    }
    if (status == 'processing' ||
        status == 'pending' ||
        uploadItem?.uploadStatus == UploadStatus.processing) {
      return _statusChip(
        context,
        'Processing',
        Icons.info_outline,
        Colors.orange,
      );
    }
    if (uploadItem?.uploadStatus == UploadStatus.uploading) {
      return _statusChip(context, 'Uploading', Icons.upload_file, Colors.blue);
    }

    if (recording.submission?.clampedScore != null) {
      return Row(
        children: [
          _ratingDisplay(
            context,
            recording.submission!.clampedScore!.toDouble(),
          ),
        ],
      );
    }
    if ((recording.durationSeconds) < 1) {
      return _statusChip(
        context,
        'Recording Error',
        Icons.error_outline,
        Colors.red,
      );
    }
    if (recording.submission?.gradeResult?.score != null) {
      return Row(
        children: [
          _ratingDisplay(
            context,
            recording.submission!.gradeResult!.score.toDouble(),
          ),
        ],
      );
    }
    if (recording.submission != null) {
      return Row(
        children: [
          _ratingDisplay(context, 0),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _statusChip(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: color.withValues(alpha: 0.8), size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingDisplay(BuildContext context, double score) {
    final gradeResult = recording.submission?.gradeResult;

    if (gradeResult != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          spacing: 30,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (gradeResult.outcomeAchievement != null)
              ScoreIndicator(
                score: gradeResult.outcomeAchievement!,
                size: 40,
                strokeWidth: 4,
                fontSize: 8,
                label: 'Outcome',
              ),
            if (gradeResult.processQuality != null)
              ScoreIndicator(
                score: gradeResult.processQuality!,
                size: 40,
                strokeWidth: 4,
                fontSize: 8,
                label: 'Process',
              ),
            if (gradeResult.efficiency != null)
              ScoreIndicator(
                score: gradeResult.efficiency!,
                size: 40,
                strokeWidth: 4,
                fontSize: 8,
                label: 'Efficiency',
              ),
            if (gradeResult.confidence != null)
              ScoreIndicator(
                score: gradeResult.confidence!,
                size: 40,
                strokeWidth: 4,
                fontSize: 8,
                label: 'Confidence',
              ),
            ScoreIndicator(
              score: gradeResult.score.toDouble(),
              size: 60,
              strokeWidth: 6,
              label: 'Total',
            ),
          ],
        ),
      );
    }

    // Fallback for old data without detailed scores
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ScoreIndicator(
        score: score,
        size: 60,
        strokeWidth: 6,
        label: 'Score',
      ),
    );
  }

  Widget _rewardClaimedBadge(BuildContext context) {
    if (recording.submission?.clampedScore == null ||
        recording.submission?.reward == null ||
        recording.submission?.reward! == 0) {
      return const SizedBox.shrink();
    }
    final isClaimed = _isAlreadyClaimed(recording);

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: !isClaimed
              ? ClonesColors.rewardInfoShouldBeClaimed.withValues(alpha: 0.2)
              : ClonesColors.rewardInfoClaimed.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: !isClaimed
                ? ClonesColors.rewardInfoShouldBeClaimed.withValues(alpha: 0.5)
                : ClonesColors.rewardInfoClaimed.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              !isClaimed ? Icons.hourglass_empty : Icons.check_circle,
              color: !isClaimed
                  ? ClonesColors.rewardInfoShouldBeClaimed
                  : ClonesColors.rewardInfoClaimed,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              !isClaimed ? 'Reward can be claimed' : 'Reward claimed',
              style: theme.textTheme.bodySmall?.copyWith(
                color: !isClaimed
                    ? ClonesColors.rewardInfoShouldBeClaimed
                    : ClonesColors.rewardInfoClaimed,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    UploadTaskState? uploadItem,
    double maxReward,
  ) {
    final isUploading = uploadItem?.uploadStatus == UploadStatus.processing ||
        uploadItem?.uploadStatus == UploadStatus.uploading ||
        uploadItem?.uploadStatus == UploadStatus.zipping;
    final isCompleted = uploadItem?.uploadStatus == UploadStatus.done;
    const isQueued = false; // Not in UploadStatus enum
    final theme = Theme.of(context);
    return Row(
      children: [
        if (recording.status == 'completed' &&
            recording.submission == null &&
            !isCompleted)
          BtnPrimary(
            onTap: isUploading || isQueued
                ? null
                : () {
                    ref.read(uploadQueueProvider.notifier).upload(
                          recording.id,
                          recording.demonstration?.poolId ?? '',
                          recording.title,
                        );
                  },
            isLoading: isUploading,
            icon: Icons.upload,
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
            buttonText: isUploading
                ? 'Uploading...'
                : isQueued
                    ? 'Queued'
                    : maxReward > 0
                        ? 'Upload for ${maxReward.toStringAsFixed(2)} Tokens'
                        : 'Upload Recording',
          ),
        if (recording.submission == null)
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: ClonesColors.secondaryText),
            color: Colors.black.withValues(alpha: 0.9),
            onSelected: (value) async {
              switch (value) {
                case 'delete':
                  await AppDialogs.showConfirmDialog(
                    context,
                    ref,
                    'Confirm Deletion',
                    'Are you sure you want to delete this record?',
                    'Delete',
                    () async {
                      await ref
                          .read(tauriApiClientProvider)
                          .deleteRecording(recording.id);
                      ref.invalidate(mergedRecordingsProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Record deleted successfully',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  );

                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
