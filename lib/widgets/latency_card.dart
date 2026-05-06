import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_providers.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LatencyCard
//
// Design spec (Stitch):
//   • Technical Chip / Card with 1px hairline border
//   • Label: JetBrains Mono uppercase (monoLabel style)
//   • Value: JetBrains Mono data style, Cyber Green when active
//   • Background: surfaceContainer
//   • Border: outlineVariant (hairline)
//   • LED status dot: Cyber Green glow when recording, outline when idle
// ─────────────────────────────────────────────────────────────────────────────
class LatencyCard extends ConsumerWidget {
  const LatencyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latency = ref.watch(latencyProvider);
    final isRecording = ref.watch(recordingStateProvider);
    final cps = ref.watch(chunksPerSecondProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(
          color: AppColors.outlineVariant,
          width: AppStroke.hairline,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          // ── LED status indicator ──────────────────────────────────────────
          _LedDot(active: isRecording),
          const SizedBox(width: AppSpacing.sm),

          // ── Latency readout ───────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LATENCY',
                  style: AppTextStyles.monoLabel(),
                ),
                const SizedBox(height: 2),
                Text(
                  latency != null ? '${latency.toStringAsFixed(2)} ms' : '— ms',
                  style: AppTextStyles.monoData(
                    color: isRecording
                        ? AppColors.cyberGreen
                        : AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // ── Divider ───────────────────────────────────────────────────────
          Container(
            width: AppStroke.hairline,
            height: 36,
            color: AppColors.outlineVariant,
          ),
          const SizedBox(width: AppSpacing.md),

          // ── Chunks/sec readout ────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('CHK/S', style: AppTextStyles.monoLabel()),
              const SizedBox(height: 2),
              Text(
                '$cps',
                style: AppTextStyles.monoData(
                  color:
                      isRecording ? AppColors.cyberGreen : AppColors.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(width: AppSpacing.md),

          // ── Divider ───────────────────────────────────────────────────────
          Container(
            width: AppStroke.hairline,
            height: 36,
            color: AppColors.outlineVariant,
          ),
          const SizedBox(width: AppSpacing.md),

          // ── Status chip ───────────────────────────────────────────────────
          _StatusChip(active: isRecording),
        ],
      ),
    );
  }
}

// ── LED dot (phosphor glow when active) ──────────────────────────────────────
class _LedDot extends StatelessWidget {
  const _LedDot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.cyberGreen : AppColors.surfaceHigh,
        border: Border.all(
          color: active ? AppColors.cyberGreen : AppColors.outline,
          width: AppStroke.hairline,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.cyberGreen.withValues(alpha: 0.55),
                  blurRadius: 6,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
    );
  }
}

// ── Status text chip ──────────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: active
            ? AppColors.cyberGreen.withValues(alpha: 0.12)
            : AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: active ? AppColors.cyberGreen : AppColors.outline,
          width: AppStroke.hairline,
        ),
      ),
      child: Text(
        active ? 'LIVE' : 'IDLE',
        style: AppTextStyles.monoLabel(
          color: active ? AppColors.cyberGreen : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
