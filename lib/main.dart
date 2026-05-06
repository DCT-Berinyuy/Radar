import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/pipeline_screen.dart';
import 'screens/denoiser_screen.dart';
import 'screens/compression_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Root nav-bar index provider
// ─────────────────────────────────────────────────────────────────────────────
final _navIndexProvider = StateProvider<int>((ref) => 0);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait; Radar is a mobile utility
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent system bars — let our dark surface bleed to the edge
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.surfaceContainer,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const ProviderScope(child: RadarApp()));
}

class RadarApp extends StatelessWidget {
  const RadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const _RootShell(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Root shell — persistent bottom nav bar across all screens
// ─────────────────────────────────────────────────────────────────────────────
class _RootShell extends ConsumerWidget {
  const _RootShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(_navIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(
        index: idx,
        children: const [
          PipelineScreen(),
          DenoiserScreen(),
          CompressionScreen(),
          _PlaceholderScreen(label: 'SETTINGS & SETUP'),
        ],
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: AppColors.surfaceHighest, // surface-container-highest
          border: Border(
            top: BorderSide(color: AppColors.outlineVariant, width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(ref, 0, Icons.sensors, 'PIPELINE',
                isActive: idx == 0),
            _buildNavItem(ref, 1, Icons.auto_awesome, 'DENOISE',
                isActive: idx == 1),
            _buildNavItem(ref, 2, Icons.compress, 'COMPRESS',
                isActive: idx == 2),
            _buildNavItem(ref, 3, Icons.tune, 'SETTINGS', isActive: idx == 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(WidgetRef ref, int index, IconData icon, String label,
      {required bool isActive}) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ref.read(_navIndexProvider.notifier).state = index,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.primaryContainer : AppColors.outline,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.monoLabel(
                color:
                    isActive ? AppColors.primaryContainer : AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder screens for nav items 2–4 (not yet designed)
// ─────────────────────────────────────────────────────────────────────────────
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.outlineVariant, width: AppStroke.hairline),
              ),
              child: const Icon(Icons.hourglass_empty_rounded,
                  color: AppColors.onSurfaceVariant, size: 24),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(label,
                style:
                    AppTextStyles.monoLabel(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text('Coming soon',
                style: AppTextStyles.bodySm(color: AppColors.outline)),
          ],
        ),
      ),
    );
  }
}
