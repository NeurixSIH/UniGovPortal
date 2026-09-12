import 'package:flutter/material.dart';

/// Centralized Design System Colors for CitizenConnect
/// Built on a deep indigo/navy brand identity with accessible semantic colors.
class AppColors {
  // Brand / Primary Colors
  static const Color primary = Color(0xFF0057B7); // Vibrant Blue from design
  static const Color primaryDark = Color(0xFF003D82);
  static const Color primaryLight = Color(0xFF337ACC);
  static const Color primaryAccent = Color(0xFF0066CC);
  static const Color primarySurface = Color(0xFFE5F0FA); // Light Blue Tint
  static const Color primaryBorder = Color(0xFFBFDBFE); // Light Blue Border

  // Secondary / Accent Colors
  static const Color secondary = Color(0xFF0D9488); // Modern Teal
  static const Color secondaryLight = Color(0xFFCCFBF1);

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceSubtle = Color(0xFFF1F5F9); // Slate 100
  static const Color surfaceMuted = Color(0xFFE2E8F0); // Slate 200

  // Text & Content Hierarchy
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF64748B); // Slate 500
  static const Color textLight = Color(0xFF94A3B8); // Slate 400
  static const Color textInverse = Color(0xFFFFFFFF);

  // Semantic Status Colors
  static const Color success = Color(0xFF059669); // Emerald 600
  static const Color successLight = Color(0xFFECFDF5); // Emerald 50
  static const Color successBorder = Color(0xFFA7F3D0);

  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningLight = Color(0xFFFFFBEB); // Amber 50
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color danger = Color(0xFFDC2626); // Crimson 600
  static const Color dangerLight = Color(0xFFFEF2F2); // Crimson 50
  static const Color dangerBorder = Color(0xFFFECACA);

  static const Color info = Color(0xFF2563EB); // Blue 600
  static const Color infoLight = Color(0xFFEFF6FF); // Blue 50
  static const Color infoBorder = Color(0xFFBFDBFE);

  static const Color neutralStatus = Color(0xFF475569);
  static const Color neutralStatusLight = Color(0xFFF1F5F9);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderSubtle = Color(0xFFF1F5F9);
  static const Color borderFocus = Color(0xFF2563EB);

  // Glassmorphism / Shadow Tints
  static const Color shadow = Color(0x0A000000);
  static const Color shadowMedium = Color(0x140F2557);
}
