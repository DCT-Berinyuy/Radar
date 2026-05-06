import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_providers.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WaveformChart
//
// Design spec (Stitch):
//   • Centerpiece visualization — Cyber Green line on deep charcoal surface
//   • X: 100 normalized samples, scrolling (no axis labels)
//   • Y: −1.0 → 1.0 (no axis labels)
//   • Background grid: secondaryContainer @ 10% opacity
//   • Line: primaryContainer (#00FF41), stroke 1.5px
//   • Background: surfaceLowest (#0E0E0E)
//   • Hairline border: outlineVariant, radius 4px
// ─────────────────────────────────────────────────────────────────────────────
class WaveformChart extends ConsumerStatefulWidget {
  const WaveformChart({super.key});

  @override
  ConsumerState<WaveformChart> createState() => _WaveformChartState();
}

class _WaveformChartState extends ConsumerState<WaveformChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanlineController;

  @override
  void initState() {
    super.initState();
    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _scanlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buffer = ref.watch(waveformBufferProvider);

    final spots = <FlSpot>[];
    for (int i = 0; i < buffer.length; i++) {
      spots.add(FlSpot(i.toDouble(), buffer[i].clamp(-1.0, 1.0)));
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(
          color: AppColors.outlineVariant,
          width: AppStroke.hairline,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: LineChart(
              _buildChartData(spots),
              duration:
                  const Duration(milliseconds: 0), // instant — no tween lag
            ),
          ),
          AnimatedBuilder(
              animation: _scanlineController,
              builder: (context, child) {
                return Align(
                    alignment: Alignment(
                        -1.0 + (_scanlineController.value * 2.0), 0.0),
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryContainer
                                  .withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]),
                    ));
              }),
        ],
      ),
    );
  }

  LineChartData _buildChartData(List<FlSpot> spots) {
    return LineChartData(
      // ── Clip & grid ──────────────────────────────────────────────────────
      clipData: const FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: 0.5,
        verticalInterval: 20,
        getDrawingHorizontalLine: (_) => const FlLine(
          color: AppColors.waveformGrid,
          strokeWidth: AppStroke.hairline,
        ),
        getDrawingVerticalLine: (_) => const FlLine(
          color: AppColors.waveformGrid,
          strokeWidth: AppStroke.hairline,
        ),
      ),

      // ── Axis titles — none (technical spec: no labels) ───────────────────
      titlesData: const FlTitlesData(show: false),

      // ── Border ───────────────────────────────────────────────────────────
      borderData: FlBorderData(show: false),

      // ── Chart extents ────────────────────────────────────────────────────
      minX: 0,
      maxX: 99,
      minY: -1.0,
      maxY: 1.0,

      // ── Waveform line ────────────────────────────────────────────────────
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.2,
          color: AppColors.cyberGreen,
          barWidth: AppStroke.waveformLine,
          isStrokeCapRound: false, // butt caps — "plotted" engineered spec
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.cyberGreen.withValues(alpha: 0.06),
          ),
        ),
      ],

      // ── Interaction ───────────────────────────────────────────────────────
      lineTouchData: const LineTouchData(enabled: false),
    );
  }
}
