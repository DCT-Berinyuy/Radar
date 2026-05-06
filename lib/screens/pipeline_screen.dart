import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/waveform_chart.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PipelineScreen — Screen 1: Pipeline Dashboard
// ─────────────────────────────────────────────────────────────────────────────
class PipelineScreen extends ConsumerWidget {
  const PipelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure the audio pipeline controller is active
    ref.watch(audioPipelineControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const _TopAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Metrics Bar ───────────────────────────────────────────────────
          const _MetricsBar(),

          // ── Central Waveform Area ─────────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                // 1. Waveform Background Layer + Scanline
                Container(
                  width: double.infinity,
                  color: AppColors.surfaceLowest,
                  child: const WaveformChart(),
                ),

                // 2. VU Meters (Left)
                const Positioned(
                  left: AppSpacing.gutter,
                  top: AppSpacing.gutter,
                  bottom: AppSpacing.gutter,
                  child: _VuMeters(),
                ),

                // 3. Technical Detail Overlay (Right)
                const Positioned(
                  right: AppSpacing.gutter,
                  top: AppSpacing.gutter,
                  child: _TechnicalDetails(),
                ),

                // 4. Central Control Action (Bottom Center)
                const Positioned(
                  bottom: AppSpacing.xl,
                  left: 0,
                  right: 0,
                  child: _CentralRecordButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top App Bar ───────────────────────────────────────────────────────────────
class _TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant, width: 1.0),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.sensors,
                    color: AppColors.primaryFixedDim, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text('RADAR_V1.0',
                    style: AppTextStyles.h2(color: AppColors.primaryFixedDim)),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLowest,
                    border: Border.all(
                        color:
                            AppColors.primaryFixedDim.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryFixedDim,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.primaryFixedDim,
                                  blurRadius: 8)
                            ]),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text('00:04:12',
                          style: AppTextStyles.monoLabel(
                              color: AppColors.primaryFixedDim)),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.settings,
                      color: AppColors.onSurfaceVariant),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}

// ── Metrics Bar ───────────────────────────────────────────────────────────────
class _MetricsBar extends ConsumerWidget {
  const _MetricsBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latency = ref.watch(latencyProvider) ?? 0.0;
    final bufferSize = ref.watch(bufferSizeProvider);
    final inputDeviceAsync = ref.watch(inputDeviceProvider);

    final deviceName = inputDeviceAsync.maybeWhen(
      data: (name) => name,
      orElse: () => 'Detecting...',
    );

    final String bufferStr =
        bufferSize != null ? '$bufferSize samples' : '— samples';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLow,
        border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant, width: 1.0)),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;
        if (isSmall) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: _MetricCell(
                          label: 'Latency (Bridge)',
                          value: latency.toStringAsFixed(1),
                          suffix: 'ms')),
                  Expanded(
                      child: _MetricCell(
                          label: 'Format', valueText: '44.1 kHz / 16-bit PCM')),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: _MetricCell(
                          label: 'Buffer Size', valueText: bufferStr)),
                  Expanded(
                      child: _MetricCell(
                          label: 'Input Device', valueText: deviceName)),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
                child: _MetricCell(
                    label: 'Latency (Bridge)',
                    value: latency.toStringAsFixed(1),
                    suffix: 'ms')),
            Expanded(
                child: _MetricCell(
                    label: 'Format', valueText: '44.1 kHz / 16-bit PCM')),
            Expanded(
                child: _MetricCell(label: 'Buffer Size', valueText: bufferStr)),
            Expanded(
                child: _MetricCell(
                    label: 'Input Device',
                    valueText: deviceName,
                    noBorder: true)),
          ],
        );
      }),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell(
      {required this.label,
      this.value,
      this.suffix,
      this.valueText,
      this.noBorder = false});
  final String label;
  final String? value;
  final String? suffix;
  final String? valueText;
  final bool noBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: noBorder
            ? null
            : const Border(
                right: BorderSide(color: AppColors.outlineVariant, width: 1.0),
                bottom: BorderSide(color: AppColors.outlineVariant, width: 1.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: AppTextStyles.monoLabel(color: AppColors.outline)),
          const SizedBox(height: AppSpacing.xs),
          if (valueText != null)
            Text(valueText!,
                style: AppTextStyles.monoData(color: AppColors.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis)
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value!,
                    style: AppTextStyles.h2(color: AppColors.primaryFixedDim)),
                const SizedBox(width: AppSpacing.xs),
                Text(suffix!,
                    style: AppTextStyles.monoLabel(color: AppColors.outline)),
              ],
            ),
        ],
      ),
    );
  }
}

// ── VU Meters ─────────────────────────────────────────────────────────────────
class _VuMeters extends StatelessWidget {
  const _VuMeters();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildMeter(0.75),
        const SizedBox(width: AppSpacing.xs),
        _buildMeter(0.68),
        const SizedBox(width: AppSpacing.xs),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('0',
                style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'JetBrains Mono',
                    color: AppColors.outline)),
            Text('-6',
                style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'JetBrains Mono',
                    color: AppColors.outline)),
            Text('-12',
                style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'JetBrains Mono',
                    color: AppColors.outline)),
            Text('-18',
                style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'JetBrains Mono',
                    color: AppColors.outline)),
            Text('-24',
                style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'JetBrains Mono',
                    color: AppColors.outline)),
            Text('-48',
                style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'JetBrains Mono',
                    color: AppColors.outline)),
          ],
        ),
      ],
    );
  }

  Widget _buildMeter(double level) {
    return Container(
      width: 8,
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(height: 5, color: AppColors.error),
          const SizedBox(height: 1),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                      heightFactor: level,
                      child: Container(color: AppColors.primaryFixedDim)))),
        ],
      ),
    );
  }
}

// ── Technical Details ─────────────────────────────────────────────────────────
class _TechnicalDetails extends StatelessWidget {
  const _TechnicalDetails();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDetailBar('CPU_THREAD_0', 0.12),
        const SizedBox(height: AppSpacing.sm),
        _buildDetailBar('MEMORY_BUFFER', 0.44),
      ],
    );
  }

  Widget _buildDetailBar(String label, double level) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.8),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrains Mono',
                  color: AppColors.outline,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: 128,
            height: 4,
            color: AppColors.surfaceHighest,
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: level,
              child: Container(color: AppColors.primaryFixedDim),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Central Action Toggle ─────────────────────────────────────────────────────
class _CentralRecordButton extends ConsumerStatefulWidget {
  const _CentralRecordButton();

  @override
  _CentralRecordButtonState createState() => _CentralRecordButtonState();
}

class _CentralRecordButtonState extends ConsumerState<_CentralRecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = ref.watch(recordingStateProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(recordingStateProvider.notifier).state = !isRecording;
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceHighest,
                border: Border.all(color: AppColors.outline),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 10)
                ]),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isRecording)
                  AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 80 * (0.8 + 0.2 * _pulseController.value),
                          height: 80 * (0.8 + 0.2 * _pulseController.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.error.withValues(alpha: 0.2),
                            border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.1),
                                width: 4),
                          ),
                        );
                      }),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording
                        ? AppColors.error
                        : AppColors.outlineVariant,
                    boxShadow: isRecording
                        ? [BoxShadow(color: AppColors.error, blurRadius: 20)]
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(isRecording ? 'RECORDING' : 'STANDBY',
            style: AppTextStyles.monoLabel(color: AppColors.onSurface)),
        Text(isRecording ? 'LOCKED_SYNC' : 'NOT_SYNCED',
            style: AppTextStyles.monoData(
                color: isRecording
                    ? AppColors.primaryFixedDim
                    : AppColors.outline)),
      ],
    );
  }
}
