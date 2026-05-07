import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_theme.dart';
import '../providers/audio_providers.dart';

class DenoiserScreen extends ConsumerWidget {
  const DenoiserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainer,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sensors, color: AppColors.primaryFixedDim, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                'RADAR_v1.0',
                style: AppTextStyles.monoLabel(color: AppColors.primaryFixedDim)
                    .copyWith(fontSize: 13, letterSpacing: 1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.4)),
              ),
              child: Text(
                'PHASE 02',
                style: AppTextStyles.monoLabel(color: AppColors.primaryFixedDim)
                    .copyWith(fontSize: 9, letterSpacing: 1.5),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.gutter),
            child: Text(
              'DENOISE',
              style: AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant)
                  .copyWith(fontSize: 10, letterSpacing: 1),
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _FileIngestionSection(),
              const SizedBox(height: AppSpacing.gutter),
              const _EngineParametersSection(),
              const SizedBox(height: AppSpacing.gutter),
              const _VisualizerSection(),
              const SizedBox(height: AppSpacing.gutter),
              const _ProcessAudioAction(),
              const SizedBox(
                  height: AppSpacing.xl), // extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}

class _FileIngestionSection extends ConsumerWidget {
  const _FileIngestionSection();

  Future<void> _pickFile(WidgetRef ref) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'avi', 'wav', 'mp3'],
    );
    if (result != null) {
      final file = result.files.single;
      ref.read(importedFileProvider.notifier).state = ImportedMedia(
        path: file.path ?? '',
        name: file.name,
        extension: file.extension ?? '',
        details:
            'AUDIO/VIDEO • IMPORTED', // Placeholder since real parsing takes additional libs
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileInfo = ref.watch(importedFileProvider);

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
              Text(
                'INPUT SOURCE',
                style:
                    AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant),
              ),
              const Icon(Icons.info_outline,
                  color: AppColors.onSurfaceVariant, size: 16),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (fileInfo != null) ...[
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                border: Border.all(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixedDim.withValues(alpha: 0.1),
                      border: Border.all(
                          color:
                              AppColors.primaryFixedDim.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(Icons.movie,
                        color: AppColors.primaryFixedDim),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileInfo.name,
                          style: AppTextStyles.monoData(
                              color: AppColors.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fileInfo.details,
                          style:
                              AppTextStyles.monoLabel(color: AppColors.outline)
                                  .copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: AppColors.onSurfaceVariant,
                    hoverColor: AppColors.error,
                    onPressed: () {
                      ref.read(importedFileProvider.notifier).state = null;
                    },
                  ),
                ],
              ),
            ),
          ],
          InkWell(
            onTap: () => _pickFile(ref),
            hoverColor: AppColors.surfaceHighest,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceHighest,
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                children: [
                  const Icon(Icons.upload_file, color: AppColors.outline),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'SELECT MEDIA',
                    style: AppTextStyles.monoLabel(color: AppColors.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EngineParametersSection extends ConsumerWidget {
  const _EngineParametersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bypassActive = ref.watch(bypassActiveProvider);
    final reductionDepth = ref.watch(reductionDepthProvider);
    final denoiserMode = ref.watch(denoiserModeProvider);

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
          Text(
            'ENGINE PARAMETERS',
            style: AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          // Bypass Mode
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BYPASS MODE',
                style: AppTextStyles.monoLabel(color: AppColors.onSurface),
              ),
              Switch(
                value: bypassActive,
                onChanged: (val) {
                  ref.read(bypassActiveProvider.notifier).state = val;
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Reduction Depth
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'REDUCTION DEPTH',
                style:
                    AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant),
              ),
              Text(
                '${reductionDepth.toStringAsFixed(1)}dB',
                style: AppTextStyles.monoData(color: AppColors.primaryFixedDim),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: AppColors.primaryFixedDim,
              inactiveTrackColor: AppColors.surfaceLowest,
              thumbColor: AppColors.primaryFixedDim,
              overlayColor: AppColors.primaryFixedDim.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: reductionDepth,
              min: -60.0,
              max: 0.0,
              onChanged: (val) {
                ref.read(reductionDepthProvider.notifier).state = val;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Comparison Switcher
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () =>
                      ref.read(denoiserModeProvider.notifier).state = 'Raw',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: denoiserMode == 'Raw'
                          ? AppColors.primaryFixedDim.withValues(alpha: 0.1)
                          : AppColors.surfaceLowest,
                      border: Border.all(
                        color: denoiserMode == 'Raw'
                            ? AppColors.primaryFixedDim
                            : AppColors.outlineVariant,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'RAW',
                      style: AppTextStyles.monoLabel(
                        color: denoiserMode == 'Raw'
                            ? AppColors.primaryFixedDim
                            : AppColors.outline,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: InkWell(
                  onTap: () =>
                      ref.read(denoiserModeProvider.notifier).state = 'Clean',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: denoiserMode == 'Clean'
                          ? AppColors.primaryFixedDim.withValues(alpha: 0.1)
                          : AppColors.surfaceLowest,
                      border: Border.all(
                        color: denoiserMode == 'Clean'
                            ? AppColors.primaryFixedDim
                            : AppColors.outlineVariant,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'CLEAN',
                      style: AppTextStyles.monoLabel(
                        color: denoiserMode == 'Clean'
                            ? AppColors.primaryFixedDim
                            : AppColors.outline,
                      ),
                    ),
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

class _VisualizerSection extends ConsumerWidget {
  const _VisualizerSection();

  Future<void> _computeProfile(WidgetRef ref) async {
    ref.read(isComputingProfileProvider.notifier).state = true;
    await Future.delayed(const Duration(milliseconds: 500));
    ref.read(isComputingProfileProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComputing = ref.watch(isComputingProfileProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.surfaceHigh,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'VISUALIZER_V2.LOG',
                      style:
                          AppTextStyles.monoLabel(color: AppColors.onSurface),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Row(
                      children: [
                        Container(
                            width: 4,
                            height: 12,
                            color: AppColors.primaryFixedDim),
                        const SizedBox(width: 4),
                        Container(
                            width: 4,
                            height: 12,
                            color: AppColors.primaryFixedDim
                                .withValues(alpha: 0.4)),
                        const SizedBox(width: 4),
                        Container(
                            width: 4,
                            height: 12,
                            color: AppColors.primaryFixedDim
                                .withValues(alpha: 0.6)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_in, size: 20),
                      color: AppColors.outline,
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: const Icon(Icons.zoom_out, size: 20),
                      color: AppColors.outline,
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.surfaceLowest,
              child: Stack(
                children: [
                  // Grid background implementation could be custom painter, skipping purely decorative part
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(14, (index) {
                        return Container(
                          width: 3,
                          height: (index % 3 == 0)
                              ? 60
                              : (index % 2 == 0)
                                  ? 120
                                  : 90,
                          color:
                              AppColors.primaryFixedDim.withValues(alpha: 0.6),
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    left: 100,
                    right: 150,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        border: const Border.symmetric(
                          vertical: BorderSide(color: AppColors.secondary),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Text(
                              'NOISE_PROFILE',
                              style: AppTextStyles.monoLabel(
                                      color: AppColors.onSecondaryContainer)
                                  .copyWith(fontSize: 9),
                            ),
                          ),
                          Text(
                            '0.45s - 1.22s',
                            style: AppTextStyles.monoLabel(
                                    color: AppColors.secondary)
                                .copyWith(fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 200, // mock playhead
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 1,
                      color: AppColors.error,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.surfaceHigh,
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                  icon: const Icon(Icons.skip_previous),
                  color: AppColors.onSurfaceVariant,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.md),
                IconButton(
                  icon: const Icon(Icons.play_arrow, size: 36),
                  color: AppColors.primaryFixedDim,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.md),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  color: AppColors.onSurfaceVariant,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.lg),
                // Add Compute Profile action here as requested
                ActionChip(
                  label: isComputing
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : Text('COMPUTE PROFILE',
                          style: AppTextStyles.monoLabel(
                              color: AppColors.onPrimary)),
                  backgroundColor: AppColors.primaryFixedDim,
                  onPressed: isComputing ? null : () => _computeProfile(ref),
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessAudioAction extends ConsumerWidget {
  const _ProcessAudioAction();

  Future<void> _denoiseFile(WidgetRef ref) async {
    ref.read(isDenoisingFileProvider.notifier).state = true;
    for (int i = 0; i <= 30; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      ref.read(denoiseProgressProvider.notifier).state = i / 30.0;
    }
    ref.read(isDenoisingFileProvider.notifier).state = false;
    ref.read(denoiseProgressProvider.notifier).state = 0.0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDenoising = ref.watch(isDenoisingFileProvider);
    final progress = ref.watch(denoiseProgressProvider);

    return InkWell(
      onTap: isDenoising ? null : () => _denoiseFile(ref),
      child: Container(
        height: 64,
        color: AppColors.primaryFixedDim,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isDenoising)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * progress,
                  color: AppColors.inversePrimary.withValues(alpha: 0.3),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.auto_fix_high,
                  color: AppColors.onPrimary,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  isDenoising
                      ? 'DENOISING... ${(progress * 100).toInt()}%'
                      : 'PROCESS AUDIO',
                  style: AppTextStyles.h2(color: AppColors.onPrimary).copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
