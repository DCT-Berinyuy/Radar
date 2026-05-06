import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RADAR DESIGN SYSTEM — sourced directly from Stitch token export
// Stitch project: "Radar Voice Media Utility" (id: 2199838404194605918)
// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // ── Surface hierarchy (tonal layering — no shadows) ──────────────────────
  static const Color surfaceLowest   = Color(0xFF0E0E0E); // surface-container-lowest
  static const Color surfaceLow      = Color(0xFF1C1B1B); // surface-container-low
  static const Color surface         = Color(0xFF131313); // surface / background
  static const Color surfaceContainer= Color(0xFF201F1F); // surface-container
  static const Color surfaceHigh     = Color(0xFF2A2A2A); // surface-container-high
  static const Color surfaceHighest  = Color(0xFF353534); // surface-container-highest
  static const Color surfaceBright   = Color(0xFF393939); // surface-bright
  static const Color surfaceVariant  = Color(0xFF353534); // surface-variant

  // ── Primary — Cyber Green ─────────────────────────────────────────────────
  static const Color primary         = Color(0xFFEBFFE2); // primary (text on dark)
  static const Color primaryContainer= Color(0xFF00FF41); // primary-container (Cyber Green)
  static const Color cyberGreen      = Color(0xFF00FF41); // alias — use for active signals
  static const Color onPrimary       = Color(0xFF003907);
  static const Color onPrimaryContainer = Color(0xFF007117);
  static const Color primaryFixed    = Color(0xFF72FF70);
  static const Color primaryFixedDim = Color(0xFF00E639);
  static const Color inversePrimary  = Color(0xFF006E16);
  static const Color surfaceTint     = Color(0xFF00E639);

  // ── Secondary — Electric Blue ─────────────────────────────────────────────
  static const Color secondary          = Color(0xFFADC6FF);
  static const Color secondaryContainer = Color(0xFF4B8EFF);
  static const Color onSecondary        = Color(0xFF002E69);
  static const Color onSecondaryContainer = Color(0xFF00285C);

  // ── Tertiary — Warm Amber ─────────────────────────────────────────────────
  static const Color tertiary           = Color(0xFFFFF8F4);
  static const Color tertiaryContainer  = Color(0xFFFFD5AE);
  static const Color onTertiary         = Color(0xFF442B10);
  static const Color onTertiaryContainer= Color(0xFF7A5B3C);

  // ── On-surface text ───────────────────────────────────────────────────────
  static const Color onSurface        = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFB9CCB2);
  static const Color inverseSurface   = Color(0xFFE5E2E1);
  static const Color inverseOnSurface = Color(0xFF313030);

  // ── Outlines / borders ────────────────────────────────────────────────────
  static const Color outline        = Color(0xFF84967E);
  static const Color outlineVariant = Color(0xFF3B4B37);

  // ── Error ─────────────────────────────────────────────────────────────────
  static const Color error          = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError        = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // ── Waveform grid: secondary at 10% opacity ───────────────────────────────
  static const Color waveformGrid = Color(0x1A4B8EFF); // secondaryContainer @ 10%
}

class AppTextStyles {
  AppTextStyles._();

  // ── Inter — structural UI ─────────────────────────────────────────────────
  static TextStyle h1({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
        fontSize: 32, fontWeight: FontWeight.w700,
        letterSpacing: -0.64, height: 1.2, color: color,
      );

  static TextStyle h2({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
        fontSize: 24, fontWeight: FontWeight.w600,
        height: 1.3, color: color,
      );

  static TextStyle bodyLg({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400,
        height: 1.5, color: color,
      );

  static TextStyle bodySm({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400,
        height: 1.5, color: color,
      );

  // ── JetBrains Mono — technical data / labels ─────────────────────────────
  static TextStyle monoData({Color color = AppColors.onSurface}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 14, fontWeight: FontWeight.w500,
        letterSpacing: 0.28, height: 1.2, color: color,
      );

  static TextStyle monoLabel({Color color = AppColors.onSurfaceVariant}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 11, fontWeight: FontWeight.w700,
        height: 1.0, color: color,
      );
}

// ── Border radius ─────────────────────────────────────────────────────────────
class AppRadius {
  AppRadius._();
  static const double sm      = 2.0;
  static const double base    = 4.0; // primary shape token (0.25rem)
  static const double md      = 6.0;
  static const double lg      = 8.0;
  static const double xl      = 12.0;
  static const double full    = 999.0;
}

// ── Spacing ───────────────────────────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();
  static const double unit   = 4.0;
  static const double xs     = 4.0;
  static const double sm     = 8.0;
  static const double md     = 16.0;
  static const double lg     = 24.0;
  static const double xl     = 32.0;
  static const double gutter = 16.0;
  static const double margin = 24.0;
}

// ── Stroke widths ─────────────────────────────────────────────────────────────
class AppStroke {
  AppStroke._();
  static const double hairline     = 1.0;  // hairline border
  static const double waveformLine = 1.5;  // waveform stroke (thin-line icon spec)
}

// ─────────────────────────────────────────────────────────────────────────────
// MaterialApp ThemeData
// ─────────────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    final colorScheme = ColorScheme(
      brightness:           Brightness.dark,
      primary:              AppColors.cyberGreen,
      onPrimary:            AppColors.onPrimary,
      primaryContainer:     AppColors.primaryContainer,
      onPrimaryContainer:   AppColors.onPrimaryContainer,
      secondary:            AppColors.secondary,
      onSecondary:          AppColors.onSecondary,
      secondaryContainer:   AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary:             AppColors.tertiary,
      onTertiary:           AppColors.onTertiary,
      tertiaryContainer:    AppColors.tertiaryContainer,
      onTertiaryContainer:  AppColors.onTertiaryContainer,
      error:                AppColors.error,
      onError:              AppColors.onError,
      errorContainer:       AppColors.errorContainer,
      onErrorContainer:     AppColors.onErrorContainer,
      surface:              AppColors.surface,
      onSurface:            AppColors.onSurface,
      onSurfaceVariant:     AppColors.onSurfaceVariant,
      outline:              AppColors.outline,
      outlineVariant:       AppColors.outlineVariant,
      inverseSurface:       AppColors.inverseSurface,
      onInverseSurface:     AppColors.inverseOnSurface,
      inversePrimary:       AppColors.inversePrimary,
    );

    return base.copyWith(
      colorScheme:     colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor:   AppColors.surfaceContainer,
        foregroundColor:   AppColors.onSurface,
        elevation:         0,
        surfaceTintColor:  Colors.transparent,
        titleTextStyle:    AppTextStyles.h2(),
        centerTitle:       false,
        shape: const Border(
          bottom: BorderSide(color: AppColors.outlineVariant, width: AppStroke.hairline),
        ),
      ),
      cardTheme: CardThemeData(
        color:       AppColors.surfaceContainer,
        elevation:   0,
        shape:       RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          side: const BorderSide(color: AppColors.outlineVariant, width: AppStroke.hairline),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cyberGreen,
          foregroundColor: AppColors.onPrimary,
          textStyle:       AppTextStyles.bodySm(),
          padding:         const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.base)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurface,
          side: const BorderSide(color: AppColors.outline, width: AppStroke.hairline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.base)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.onPrimary
                : AppColors.onSurfaceVariant),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.cyberGreen
                : AppColors.surfaceHigh),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? Colors.transparent
                : AppColors.outline),
      ),
      dividerTheme: const DividerThemeData(
        color:     AppColors.outlineVariant,
        thickness: AppStroke.hairline,
        space:     0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:  AppColors.surfaceContainer,
        indicatorColor:   AppColors.cyberGreen.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) =>
            IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? AppColors.cyberGreen
                  : AppColors.onSurfaceVariant,
              size: 22,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith((states) =>
            AppTextStyles.monoLabel(
              color: states.contains(WidgetState.selected)
                  ? AppColors.cyberGreen
                  : AppColors.onSurfaceVariant,
            )),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 64,
        shadowColor: Colors.transparent,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge:  AppTextStyles.h1(),
        headlineLarge: AppTextStyles.h1(),
        headlineMedium: AppTextStyles.h2(),
        bodyLarge:     AppTextStyles.bodyLg(),
        bodyMedium:    AppTextStyles.bodySm(),
        labelSmall:    AppTextStyles.monoLabel(),
      ),
    );
  }
}
