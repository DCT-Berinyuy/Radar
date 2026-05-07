import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../theme/app_theme.dart';
import '../providers/audio_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Radar — Settings & Setup  (Phase 4)
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainer,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.sensors,
                color: AppColors.primaryFixedDim, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'RADAR_v1.0',
              style: AppTextStyles.monoLabel(color: AppColors.primaryFixedDim)
                  .copyWith(fontSize: 13, letterSpacing: 1),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.4)),
              ),
              child: Text(
                'PHASE 04',
                style: AppTextStyles.monoLabel(color: AppColors.primaryFixedDim)
                    .copyWith(fontSize: 9, letterSpacing: 1.5),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.gutter),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighest,
                    border: Border.all(
                        color:
                            AppColors.primaryFixedDim.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'SYSTEM CONFIG',
                    style: AppTextStyles.monoLabel(
                            color: AppColors.primaryFixedDim)
                        .copyWith(fontSize: 9, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(AppStroke.hairline),
          child: Container(
              color: AppColors.outlineVariant, height: AppStroke.hairline),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _SectionHeader(number: '01', title: 'DSP PARAMETERS'),
            SizedBox(height: AppSpacing.md),
            _DspParametersSection(),
            SizedBox(height: AppSpacing.xl),
            _SectionHeader(number: '02', title: 'PIPELINE'),
            SizedBox(height: AppSpacing.md),
            _PipelineSection(),
            SizedBox(height: AppSpacing.xl),
            _SectionHeader(number: '03', title: 'OUTPUT'),
            SizedBox(height: AppSpacing.md),
            _OutputSection(),
            SizedBox(height: AppSpacing.xl),
            _SectionHeader(number: '04', title: 'SYSTEM'),
            SizedBox(height: AppSpacing.md),
            _SystemInfoSection(),
            SizedBox(height: AppSpacing.xl),
            _SectionHeader(number: '05', title: 'DANGER ZONE', danger: true),
            SizedBox(height: AppSpacing.md),
            _DangerZoneSection(),
            SizedBox(height: AppSpacing.xl),
            _BuildInfoFooter(),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared section header — left-bordered like the Stitch design
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.number,
    required this.title,
    this.danger = false,
  });

  final String number;
  final String title;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFFF4444) : AppColors.primaryFixedDim;
    return Container(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 2)),
      ),
      child: Text(
        '$number / $title',
        style: AppTextStyles.monoLabel(color: color).copyWith(letterSpacing: 2),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

/// A labelled card row used throughout the settings sections.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: child,
    );
  }
}

/// A small sub-label shown below controls.
class _SubLabel extends StatelessWidget {
  const _SubLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.monoLabel(color: AppColors.outline)
          .copyWith(fontSize: 10, fontWeight: FontWeight.w400),
    );
  }
}

/// Builds a horizontal segmented-control style selector.
class _SegmentedRow extends StatelessWidget {
  const _SegmentedRow({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((opt) {
        final isActive = opt == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(opt),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryFixedDim.withValues(alpha: 0.15)
                    : AppColors.surfaceHighest,
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryFixedDim
                      : AppColors.outlineVariant,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                opt,
                style: AppTextStyles.monoLabel(
                  color: isActive
                      ? AppColors.primaryFixedDim
                      : AppColors.onSurfaceVariant,
                ).copyWith(fontSize: 11),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// A row with a label, optional sub-label, and a trailing toggle switch.
class _SwitchRow extends ConsumerWidget {
  const _SwitchRow({
    required this.label,
    required this.provider,
    this.subLabel,
  });

  final String label;
  final StateProvider<bool> provider;
  final String? subLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final val = ref.watch(provider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.monoLabel(color: AppColors.onSurface)
                      .copyWith(fontSize: 12)),
              if (subLabel != null) ...[
                const SizedBox(height: 2),
                _SubLabel(subLabel!),
              ],
            ],
          ),
        ),
        Switch(
          value: val,
          onChanged: (v) => ref.read(provider.notifier).state = v,
          activeThumbColor: AppColors.primaryFixedDim,
          activeTrackColor: AppColors.primaryFixedDim.withValues(alpha: 0.25),
          inactiveTrackColor: AppColors.surfaceHighest,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 01 — DSP PARAMETERS
// ─────────────────────────────────────────────────────────────────────────────

class _DspParametersSection extends ConsumerWidget {
  const _DspParametersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowSize = ref.watch(dctWindowSizeProvider);
    final overlap = ref.watch(overlapFactorProvider);
    final alpha = ref.watch(alphaValueProvider);
    final floor = ref.watch(noiseFloorProvider);

    return Column(
      children: [
        // DCT Window Size
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DCT WINDOW SIZE',
                      style: AppTextStyles.monoLabel(
                          color: AppColors.onSurfaceVariant)),
                  Text('$windowSize samples',
                      style: AppTextStyles.monoData(
                              color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 12)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SegmentedRow(
                options: const ['512', '1024', '2048'],
                selected: windowSize.toString(),
                onSelect: (v) => ref
                    .read(dctWindowSizeProvider.notifier)
                    .state = int.parse(v),
              ),
              const SizedBox(height: AppSpacing.sm),
              const _SubLabel('Larger = better quality, higher latency'),
            ],
          ),
        ),
        _gap(),

        // Overlap Factor
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('OVERLAP FACTOR',
                      style: AppTextStyles.monoLabel(
                          color: AppColors.onSurfaceVariant)),
                  Text('${(overlap * 100).toStringAsFixed(0)}%',
                      style: AppTextStyles.monoData(
                              color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 12)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SegmentedRow(
                options: const ['25%', '50%', '75%'],
                selected: '${(overlap * 100).toStringAsFixed(0)}%',
                onSelect: (v) {
                  final pct = double.parse(v.replaceAll('%', '')) / 100.0;
                  ref.read(overlapFactorProvider.notifier).state = pct;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              const _SubLabel('OLA hop size as % of window'),
            ],
          ),
        ),
        _gap(),

        // Over-Subtraction α
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('OVER-SUBTRACTION α',
                      style: AppTextStyles.monoLabel(
                          color: AppColors.onSurfaceVariant)),
                  Text(alpha.toStringAsFixed(1),
                      style: AppTextStyles.monoData(
                              color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 14)),
                ],
              ),
              Slider(
                value: alpha.clamp(0.5, 3.0),
                min: 0.5,
                max: 3.0,
                divisions: 25,
                activeColor: AppColors.primaryFixedDim,
                inactiveColor: AppColors.surfaceHighest,
                onChanged: (v) => ref.read(alphaValueProvider.notifier).state =
                    double.parse(v.toStringAsFixed(1)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0.5',
                      style: AppTextStyles.monoLabel(color: AppColors.outline)
                          .copyWith(fontSize: 9)),
                  Text('1.5',
                      style: AppTextStyles.monoLabel(
                              color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 9)),
                  Text('3.0',
                      style: AppTextStyles.monoLabel(color: AppColors.outline)
                          .copyWith(fontSize: 9)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              const _SubLabel('Higher = more aggressive noise removal'),
            ],
          ),
        ),
        _gap(),

        // Noise Floor Threshold
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('NOISE FLOOR THRESHOLD',
                      style: AppTextStyles.monoLabel(
                          color: AppColors.onSurfaceVariant)),
                  Text('${floor.toStringAsFixed(0)} dB',
                      style: AppTextStyles.monoData(
                              color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 14)),
                ],
              ),
              Slider(
                value: floor.clamp(-60.0, -20.0),
                min: -60.0,
                max: -20.0,
                divisions: 40,
                activeColor: AppColors.primaryFixedDim,
                inactiveColor: AppColors.surfaceHighest,
                onChanged: (v) => ref.read(noiseFloorProvider.notifier).state =
                    double.parse(v.toStringAsFixed(0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('-60 dB',
                      style: AppTextStyles.monoLabel(color: AppColors.outline)
                          .copyWith(fontSize: 9)),
                  Text('-40 dB',
                      style: AppTextStyles.monoLabel(
                              color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 9)),
                  Text('-20 dB',
                      style: AppTextStyles.monoLabel(color: AppColors.outline)
                          .copyWith(fontSize: 9)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              const _SubLabel('Coefficients below this are zeroed'),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox _gap() => const SizedBox(height: 1);
}

// ─────────────────────────────────────────────────────────────────────────────
// 02 — PIPELINE
// ─────────────────────────────────────────────────────────────────────────────

class _PipelineSection extends ConsumerWidget {
  const _PipelineSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleRate = ref.watch(sampleRateProvider);
    final bitDepth = ref.watch(bitDepthProvider);
    final bufferSize = ref.watch(bufferSizeProvider);

    return Column(
      children: [
        // Sample Rate
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SAMPLE RATE',
                  style: AppTextStyles.monoLabel(
                      color: AppColors.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighest,
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: DropdownButton<int>(
                  value: sampleRate,
                  isExpanded: true,
                  dropdownColor: AppColors.surfaceHigh,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.expand_more,
                      color: AppColors.onSurfaceVariant),
                  style:
                      AppTextStyles.monoData(color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 44100, child: Text('44100 Hz')),
                    DropdownMenuItem(value: 48000, child: Text('48000 Hz')),
                    DropdownMenuItem(value: 22050, child: Text('22050 Hz')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(sampleRateProvider.notifier).state = v;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 1),

        // Bit Depth
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BIT DEPTH',
                  style: AppTextStyles.monoLabel(
                      color: AppColors.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.md),
              _SegmentedRow(
                options: const ['16-bit', '32-bit'],
                selected: '$bitDepth-bit',
                onSelect: (v) {
                  ref.read(bitDepthProvider.notifier).state =
                      int.parse(v.replaceAll('-bit', ''));
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 1),

        // Buffer Size (read-only)
        _SettingsCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BUFFER SIZE',
                      style: AppTextStyles.monoLabel(
                          color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text(
                    bufferSize == null ? '— samples' : '$bufferSize samples',
                    style:
                        AppTextStyles.monoData(color: AppColors.primaryFixedDim)
                            .copyWith(fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primaryFixedDim.withValues(alpha: 0.5)),
                ),
                child: Text(
                  'AUTO-DETECTED',
                  style:
                      AppTextStyles.monoLabel(color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 9, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 1),

        // Rust Bridge toggle
        _SettingsCard(
          child: _SwitchRow(
            label: 'ENABLE RUST BRIDGE',
            provider: rustBridgeEnabledProvider,
            subLabel: 'Disable to benchmark Flutter-only path',
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 03 — OUTPUT
// ─────────────────────────────────────────────────────────────────────────────

class _OutputSection extends ConsumerWidget {
  const _OutputSection();

  Future<void> _pickDirectory(WidgetRef ref) async {
    final path = await FilePicker.getDirectoryPath();
    if (path != null) {
      ref.read(outputDirectoryProvider.notifier).state = path;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final format = ref.watch(exportFormatProvider);
    final outDir = ref.watch(outputDirectoryProvider);

    return Column(
      children: [
        // Export format
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DEFAULT EXPORT FORMAT',
                  style: AppTextStyles.monoLabel(
                      color: AppColors.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighest,
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: DropdownButton<ExportFormat>(
                  value: format,
                  isExpanded: true,
                  dropdownColor: AppColors.surfaceHigh,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.expand_more,
                      color: AppColors.onSurfaceVariant),
                  style:
                      AppTextStyles.monoData(color: AppColors.primaryFixedDim)
                          .copyWith(fontSize: 13),
                  items: ExportFormat.values
                      .map((f) => DropdownMenuItem(
                            value: f,
                            child: Text(f.name.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(exportFormatProvider.notifier).state = v;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 1),

        // Output directory
        _SettingsCard(
          child: GestureDetector(
            onTap: () => _pickDirectory(ref),
            child: Row(
              children: [
                const Icon(Icons.folder_open,
                    color: AppColors.onSurfaceVariant, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('OUTPUT DIRECTORY',
                          style: AppTextStyles.monoLabel(
                              color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text(
                        outDir,
                        style: AppTextStyles.monoData(
                                color: AppColors.primaryFixedDim)
                            .copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.outline, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 1),

        // Auto-save toggle
        _SettingsCard(
          child: _SwitchRow(
            label: 'AUTO-SAVE RECORDINGS',
            provider: autoSaveProvider,
          ),
        ),
        const SizedBox(height: 1),

        // Append suffix toggle
        _SettingsCard(
          child: _SwitchRow(
            label: 'APPEND _radar SUFFIX',
            provider: appendSuffixProvider,
            subLabel: 'Prevents overwriting original files',
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 04 — SYSTEM INFO
// ─────────────────────────────────────────────────────────────────────────────

class _SystemInfoSection extends ConsumerWidget {
  const _SystemInfoSection();

  String _platformName() {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benchmarkResult = ref.watch(benchmarkResultsProvider);
    final isBenchmarking = ref.watch(_isBenchmarkingProvider);

    final infoItems = [
      ('FLUTTER VERSION', 'v3.29.3', AppColors.onSurface),
      ('RUST BRIDGE', 'NOT CONNECTED', const Color(0xFFFFD700)),
      ('FFMPEG', 'NOT CONNECTED', const Color(0xFFFFD700)),
      ('PLATFORM', _platformName(), AppColors.onSurface),
    ];

    return Column(
      children: [
        // 2×2 info grid
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          shrinkWrap: true,
          childAspectRatio: 2.4,
          physics: const NeverScrollableScrollPhysics(),
          children: infoItems
              .map((item) => _SystemInfoCard(
                    label: item.$1,
                    value: item.$2,
                    valueColor: item.$3,
                  ))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        // Benchmark button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isBenchmarking
                ? null
                : () async {
                    ref.read(_isBenchmarkingProvider.notifier).state = true;
                    await runBenchmark(ref);
                    ref.read(_isBenchmarkingProvider.notifier).state = false;

                    if (context.mounted) {
                      final result = ref.read(benchmarkResultsProvider);
                      if (result != null) {
                        _showBenchmarkSheet(context, result);
                      }
                    }
                  },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryFixedDim,
              side: BorderSide(
                color: isBenchmarking
                    ? AppColors.outlineVariant
                    : AppColors.primaryFixedDim,
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: isBenchmarking
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.primaryFixedDim,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'RUNNING BENCHMARK…',
                        style:
                            AppTextStyles.monoLabel(color: AppColors.outline),
                      ),
                    ],
                  )
                : Text(
                    'RUN LATENCY BENCHMARK',
                    style: AppTextStyles.monoLabel(
                        color: AppColors.primaryFixedDim),
                  ),
          ),
        ),

        // Show last result inline if available
        if (benchmarkResult != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              border: Border.all(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BenchStat('AVG', benchmarkResult.avg),
                _divider(),
                _BenchStat('MIN', benchmarkResult.min),
                _divider(),
                _BenchStat('MAX', benchmarkResult.max),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        color: AppColors.outlineVariant,
      );

  void _showBenchmarkSheet(BuildContext context, BenchmarkResult result) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      builder: (_) => _BenchmarkSheet(result: result),
    );
  }
}

// Local provider to track benchmark running state (avoids setState)
final _isBenchmarkingProvider = StateProvider<bool>((ref) => false);

class _SystemInfoCard extends StatelessWidget {
  const _SystemInfoCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: AppTextStyles.monoLabel(color: AppColors.outline)
                  .copyWith(fontSize: 9, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.monoData(color: valueColor)
                .copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BenchStat extends StatelessWidget {
  const _BenchStat(this.label, this.value);
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: AppTextStyles.monoLabel(color: AppColors.outline)
                .copyWith(fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)} ms',
          style: AppTextStyles.monoData(color: AppColors.primaryFixedDim)
              .copyWith(fontSize: 14),
        ),
      ],
    );
  }
}

class _BenchmarkSheet extends StatelessWidget {
  const _BenchmarkSheet({required this.result});
  final BenchmarkResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('BENCHMARK RESULTS',
              style: AppTextStyles.monoLabel(color: AppColors.primaryFixedDim)
                  .copyWith(letterSpacing: 2)),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BenchStat('AVG', result.avg),
              Container(width: 1, height: 40, color: AppColors.outlineVariant),
              _BenchStat('MIN', result.min),
              Container(width: 1, height: 40, color: AppColors.outlineVariant),
              _BenchStat('MAX', result.max),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '100 iterations · simulated processAudio stub',
            style: AppTextStyles.monoLabel(color: AppColors.outline)
                .copyWith(fontSize: 10),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 05 — DANGER ZONE
// ─────────────────────────────────────────────────────────────────────────────

class _DangerZoneSection extends ConsumerWidget {
  const _DangerZoneSection();

  static const _dangerRed = Color(0xFFFF4444);

  Future<bool> _confirm(BuildContext context, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text('CONFIRM',
            style: AppTextStyles.monoLabel(color: _dangerRed)
                .copyWith(letterSpacing: 2)),
        content: Text(message,
            style: AppTextStyles.bodySm(color: AppColors.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('CANCEL',
                style:
                    AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('CONFIRM',
                style: AppTextStyles.monoLabel(color: _dangerRed)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Clear cached files
        OutlinedButton(
          onPressed: () async {
            final ok = await _confirm(context,
                'This will clear all cached files. This cannot be undone.');
            if (ok && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cache cleared.',
                      style:
                          AppTextStyles.monoLabel(color: AppColors.onSurface)),
                  backgroundColor: AppColors.surfaceHigh,
                ),
              );
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: _dangerRed,
            side: const BorderSide(color: _dangerRed),
            minimumSize: const Size(double.infinity, 56),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text('CLEAR ALL CACHED FILES',
              style: AppTextStyles.monoLabel(color: _dangerRed)),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Reset to defaults
        OutlinedButton(
          onPressed: () async {
            final ok = await _confirm(
                context, 'All settings will be reset to their default values.');
            if (ok) {
              ref.read(dctWindowSizeProvider.notifier).state = 1024;
              ref.read(overlapFactorProvider.notifier).state = 0.5;
              ref.read(alphaValueProvider.notifier).state = 0.5;
              ref.read(noiseFloorProvider.notifier).state = -40.0;
              ref.read(sampleRateProvider.notifier).state = 44100;
              ref.read(bitDepthProvider.notifier).state = 16;
              ref.read(rustBridgeEnabledProvider.notifier).state = true;
              ref.read(exportFormatProvider.notifier).state = ExportFormat.wav;
              ref.read(outputDirectoryProvider.notifier).state =
                  'Downloads/Radar';
              ref.read(autoSaveProvider.notifier).state = true;
              ref.read(appendSuffixProvider.notifier).state = true;
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Settings reset to defaults.',
                        style: AppTextStyles.monoLabel(
                            color: AppColors.onSurface)),
                    backgroundColor: AppColors.surfaceHigh,
                  ),
                );
              }
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: _dangerRed,
            side: const BorderSide(color: _dangerRed),
            minimumSize: const Size(double.infinity, 56),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text('RESET TO DEFAULTS',
              style: AppTextStyles.monoLabel(color: _dangerRed)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Build info footer (mirrors Stitch BUILD INFO section)
// ─────────────────────────────────────────────────────────────────────────────

class _BuildInfoFooter extends StatelessWidget {
  const _BuildInfoFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      decoration: const BoxDecoration(
        border:
            Border(top: BorderSide(color: AppColors.outlineVariant, width: 1)),
      ),
      child: Wrap(
        spacing: AppSpacing.xl,
        runSpacing: AppSpacing.md,
        children: [
          _FooterItem('BUILD_HASH', 'v1.0.4-STABLE.0922'),
          _FooterItem('RUST_CORE', '1.75.0-NIGHTLY'),
          _FooterItem('DEVELOPED_BY', 'DCT LABS © 2026',
              valueColor: AppColors.primaryFixedDim),
        ],
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  const _FooterItem(this.label, this.value, {this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.monoLabel(color: AppColors.outline)
                .copyWith(fontSize: 9, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(
          value,
          style:
              AppTextStyles.monoData(color: valueColor ?? AppColors.onSurface)
                  .copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
