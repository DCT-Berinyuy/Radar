import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../theme/app_theme.dart';
import '../providers/audio_providers.dart';

class CompressionScreen extends ConsumerWidget {
  const CompressionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const _TopNavBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _CompressionHeader(),
                    const SizedBox(height: AppSpacing.xl),
                    const _FileIngestionSection(),
                    const SizedBox(height: AppSpacing.gutter),
                    const _PresetSelectorSection(),
                    const SizedBox(height: AppSpacing.gutter),
                    const _ProjectionCard(),
                    const SizedBox(height: AppSpacing.gutter),
                    const _AdvancedParametersCard(),
                    const SizedBox(height: AppSpacing.gutter),
                    const _CommandPreview(),
                    const SizedBox(height: AppSpacing.xl),
                    const _CompressionControls(),
                    const SizedBox(height: AppSpacing.xl),
                    const _OutputSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopNavBar extends StatelessWidget {
  const _TopNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant,
            width: AppStroke.hairline,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sensors,
                color: AppColors.primaryFixedDim,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'RADAR_v1.0',
                style: AppTextStyles.h2(color: AppColors.primaryFixedDim)
                    .copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighest,
              border: Border.all(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              '00:04:12',
              style: AppTextStyles.monoLabel(color: AppColors.primaryFixedDim),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompressionHeader extends StatelessWidget {
  const _CompressionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PHASE 03',
            style: AppTextStyles.monoLabel(color: AppColors.outline)
                .copyWith(letterSpacing: 2),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'COMPRESSION ENGINE',
            style: AppTextStyles.h1(color: AppColors.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.outlineVariant, thickness: 1),
        ],
      ),
    );
  }
}

class _FileIngestionSection extends ConsumerWidget {
  const _FileIngestionSection();

  Future<void> _pickFile(WidgetRef ref) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'avi', 'mkv', 'webm'],
    );
    if (result != null) {
      final file = result.files.single;
      ref.read(compressionFilePathProvider.notifier).state = file.name;
      // Simulate typical sizing for a generic 1080p, 4m12s file:
      ref.read(compressionFileSizeProvider.notifier).state = 124.3;
      ref.read(compressionDurationProvider.notifier).state = 252.0; // 4:12 in seconds
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileName = ref.watch(compressionFilePathProvider);
    final fileSize = ref.watch(compressionFileSizeProvider);
    final duration = ref.watch(compressionDurationProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('INPUT SOURCE', style: AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant)),
              const Icon(Icons.info_outline, color: AppColors.onSurfaceVariant, size: 16),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (fileName != null) ...[
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                border: Border.all(color: AppColors.primaryFixedDim.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.videocam, color: AppColors.primaryFixedDim),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          style: AppTextStyles.monoData(color: AppColors.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${fileSize?.toStringAsFixed(1)} MB • 00:04:12 • 1080p',
                          style: AppTextStyles.monoLabel(color: AppColors.outline),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          ElevatedButton.icon(
            onPressed: () => _pickFile(ref),
            icon: const Icon(Icons.folder_open, size: 18),
            label: Text(fileName == null ? 'SELECT MEDIA FILE' : 'CHANGE FILE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceHighest,
              foregroundColor: AppColors.onSurface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.base),
                side: const BorderSide(color: AppColors.outlineVariant),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: AppTextStyles.monoLabel(color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetSelectorSection extends ConsumerWidget {
  const _PresetSelectorSection();

  Widget _buildToggle(
    BuildContext context, 
    WidgetRef ref, 
    CompressionPreset preset, 
    String title, 
    String spec, 
    IconData icon
  ) {
    final activePreset = ref.watch(selectedPresetProvider);
    final isActive = activePreset == preset;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedPresetProvider.notifier).state = preset;
        },
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryContainer.withValues(alpha: 0.15) : AppColors.surface,
            border: Border.all(
              color: isActive ? AppColors.primaryContainer : AppColors.outlineVariant,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: isActive ? AppColors.primaryContainer : AppColors.outline),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTextStyles.h2(
                  color: isActive ? AppColors.primaryContainer : AppColors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                spec,
                style: AppTextStyles.monoLabel(
                  color: isActive ? AppColors.primaryContainer : AppColors.outline,
                ).copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PRESET CONFIGURATION', style: AppTextStyles.monoLabel(color: AppColors.outline)),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _buildToggle(context, ref, CompressionPreset.fast, 'FAST', 'CRF 28 · ULTRAFAST · 96k', Icons.speed),
            const SizedBox(width: AppSpacing.sm),
            _buildToggle(context, ref, CompressionPreset.balanced, 'BALANCED', 'CRF 24 · MEDIUM · 128k', Icons.balance),
            const SizedBox(width: AppSpacing.sm),
            _buildToggle(context, ref, CompressionPreset.quality, 'QUALITY', 'CRF 20 · SLOW · 128k', Icons.high_quality),
          ],
        ),
      ],
    );
  }
}

class _ProjectionCard extends ConsumerWidget {
  const _ProjectionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originalSize = ref.watch(compressionFileSizeProvider);
    final estimatedSize = ref.watch(estimatedSizeProvider);

    double? pct;
    if (originalSize != null && estimatedSize != null && originalSize > 0) {
      pct = ((originalSize - estimatedSize) / originalSize) * 100.0;
    }

    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceContainer, border: Border.all(color: AppColors.outlineVariant)),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SIZE PROJECTION', style: AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant).copyWith(fontFamily: 'Inter', fontSize: 11)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ORIGINAL', style: AppTextStyles.monoLabel(color: AppColors.outline)),
                    Text(originalSize == null ? '-- MB' : '${originalSize.toStringAsFixed(1)} MB', style: AppTextStyles.monoData(color: AppColors.onSurface).copyWith(fontSize: 18)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_right_alt, color: AppColors.outline),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('ESTIMATED', style: AppTextStyles.monoLabel(color: AppColors.outline)),
                    Text(estimatedSize == null ? '-- MB' : '${estimatedSize.toStringAsFixed(1)} MB', style: AppTextStyles.monoData(color: AppColors.primaryFixedDim).copyWith(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          if (pct != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('↓ ${pct.toStringAsFixed(0)}%', style: AppTextStyles.monoData(color: AppColors.primaryFixedDim)),
          ]
        ],
      ),
    );
  }
}

class _AdvancedParametersCard extends ConsumerWidget {
  const _AdvancedParametersCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text('ADVANCED PARAMETERS', style: AppTextStyles.monoLabel(color: AppColors.outline)),
        childrenPadding: const EdgeInsets.all(AppSpacing.md),
        collapsedBackgroundColor: AppColors.surfaceLow,
        backgroundColor: AppColors.surfaceLow,
        children: [
          _buildSwitch(ref, 'HARDWARE ACCEL (GPU)', hardwareAccelProvider),
          _buildSwitch(ref, 'TWO-PASS ENCODE', twoPassProvider),
          _buildSwitch(ref, 'STRIP METADATA', stripMetadataProvider),
          _buildSwitch(ref, 'AUDIO ONLY (-vn)', audioOnlyProvider),
        ],
      ),
    );
  }

  Widget _buildSwitch(WidgetRef ref, String label, StateProvider<bool> provider) {
    final val = ref.watch(provider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.monoLabel(color: AppColors.onSurface).copyWith(fontSize: 12)),
        Switch(
          value: val,
          onChanged: (newVal) => ref.read(provider.notifier).state = newVal,
          activeColor: AppColors.primaryContainer,
          inactiveTrackColor: AppColors.surfaceHighest,
        ),
      ],
    );
  }
}

class _CommandPreview extends ConsumerWidget {
  const _CommandPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final command = ref.watch(ffmpegCommandProvider);
    
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF0A0A0F), border: Border.all(color: AppColors.outlineVariant)),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('FFMPEG COMMAND', style: AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant).copyWith(fontFamily: 'Inter', fontSize: 11)),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: command));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('COPIED COPIED', style: AppTextStyles.monoLabel(color: AppColors.onSurface)), backgroundColor: AppColors.primaryFixedDim)
                  );
                },
                child: const Icon(Icons.copy, color: AppColors.outline, size: 16),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            command.replaceAll(' -', '\n  -'), 
            style: AppTextStyles.monoData(color: AppColors.secondary).copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _CompressionControls extends ConsumerStatefulWidget {
  const _CompressionControls();

  @override
  _CompressionControlsState createState() => _CompressionControlsState();
}

class _CompressionControlsState extends ConsumerState<_CompressionControls> {
  final _mockLogs = [
    "Initializing engine core v4.2.1-stable...",
    "Stream #0:0(eng): Video: h264 (High) (avc1 / 0x31637661)",
    "Stream #0:1(eng): Audio: aac (LC) (mp4a / 0x6134706d)",
    "frame=  412 fps= 62 q=24.0 size=    2560kB time=00:00:14.22 bitrate=1474.3kbits/s speed=2.1x",
    "frame=  855 fps= 61 q=23.0 size=    5842kB time=00:00:28.45 bitrate=1682.1kbits/s speed=2.0x",
    "segment_marker_applied: p-frame continuity verified",
    "frame= 1240 fps= 60 q=24.0 size=    8912kB time=00:00:41.12 bitrate=1774.3kbits/s speed=1.9x",
    "video:8432kB audio:322kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 1.761829%",
  ];

  Future<void> _runCompression() async {
    ref.read(compressionStatusProvider.notifier).state = CompressionStatus.encoding;
    ref.read(compressionProgressProvider.notifier).state = 0.0;
    ref.read(compressionLogsProvider.notifier).state = [];
    
    final totalDuration = 4000;
    final interval = 400;
    final ticks = totalDuration ~/ interval;
    
    for (int i = 0; i <= ticks; i++) {
      if (!mounted) return;
      await Future.delayed(Duration(milliseconds: interval));
      
      ref.read(compressionProgressProvider.notifier).state = (i / ticks).clamp(0.0, 1.0);
      
      if (i < _mockLogs.length) {
        final logs = ref.read(compressionLogsProvider);
        ref.read(compressionLogsProvider.notifier).state = [
          ...logs, 
          "[09:41:${(i+2).toString().padLeft(2, '0')}] ${_mockLogs[i]}"
        ];
      }
    }
    
    if (!mounted) return;
    ref.read(compressionStatusProvider.notifier).state = CompressionStatus.complete;
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(compressionStatusProvider);
    final progress = ref.watch(compressionProgressProvider);
    final hasFile = ref.watch(compressionFilePathProvider) != null;
    final logs = ref.watch(compressionLogsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: hasFile && status != CompressionStatus.encoding ? _runCompression : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 24),
            disabledBackgroundColor: AppColors.surfaceHigh,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.base)),
          ),
          child: Text(
            'COMPRESS FILE',
            style: AppTextStyles.h2(color: hasFile && status != CompressionStatus.encoding ? AppColors.onPrimary : AppColors.outline),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceHighest,
                color: AppColors.primaryFixedDim,
                minHeight: 8,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text('${(progress * 100).toStringAsFixed(0)}%', style: AppTextStyles.monoData(color: AppColors.primaryFixedDim)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: status == CompressionStatus.idle ? AppColors.outline :
                         status == CompressionStatus.encoding ? const Color(0xFFFFD700) : AppColors.primaryFixedDim,
                ),
              ),
              child: Text(
                status.name.toUpperCase(),
                style: AppTextStyles.monoLabel(
                  color: status == CompressionStatus.idle ? AppColors.outline :
                         status == CompressionStatus.encoding ? const Color(0xFFFFD700) : AppColors.primaryFixedDim,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 100,
          color: const Color(0xFF0A0A0F),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (ctx, i) => Text(logs[i], style: AppTextStyles.monoLabel(color: AppColors.outline).copyWith(fontSize: 10)),
          ),
        ),
      ],
    );
  }
}

class _OutputSection extends ConsumerWidget {
  const _OutputSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(compressionStatusProvider);
    if (status != CompressionStatus.complete) return const SizedBox.shrink();

    final originalName = ref.watch(compressionFilePathProvider) ?? 'input.mp4';
    final outputName = '${originalName.split('.').first}_radar.mp4';
    final estimatedSize = ref.watch(estimatedSizeProvider);

    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceContainer, border: Border.all(color: AppColors.primaryFixedDim)),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('OUTPUT SUMMARY', style: AppTextStyles.monoLabel(color: AppColors.primaryFixedDim)),
          const SizedBox(height: AppSpacing.md),
          Text(outputName, style: AppTextStyles.monoData(color: AppColors.onSurface)),
          const SizedBox(height: AppSpacing.xs),
          Text('Final Size: ${estimatedSize?.toStringAsFixed(1) ?? '--'} MB', style: AppTextStyles.monoLabel(color: AppColors.outline)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('FFmpeg not yet connected — coming in Phase 3')));
                  },
                  child: const Text('SAVE FILE'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('FFmpeg not yet connected — coming in Phase 3')));
                  },
                  child: const Text('SHARE FILE'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
