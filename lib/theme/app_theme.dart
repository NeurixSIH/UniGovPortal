import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Government of Maharashtra Interoperability Hub
  static const Color primaryBlue = Color(0xFF0D47A1); // Deep Government Navy Blue
  static const Color primaryBlueLight = Color(0xFF1976D2); // Active Blue
  static const Color primaryBlueDark = Color(0xFF0A2E68);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color backgroundLight = Color(0xFFF8FAFC); // Clean off-white surface
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color cardGradientStart = Color(0xFFF0F7FF);
  static const Color cardGradientEnd = Color(0xFFFFFFFF);

  // Indian Tricolor & State Accents (Subtle & Elegant)
  static const Color saffron = Color(0xFFFF9933);
  static const Color saffronLight = Color(0xFFFFF3E0);
  static const Color indiaGreen = Color(0xFF138808);
  static const Color indiaGreenLight = Color(0xFFE8F5E9);
  static const Color tealAccent = Color(0xFF00897B);

  // Status Colors
  static const Color statusSuccess = Color(0xFF2E7D32);
  static const Color statusSuccessLight = Color(0xFFE8F5E9);
  static const Color statusPending = Color(0xFFED6C02);
  static const Color statusPendingLight = Color(0xFFFFF3E0);
  static const Color statusRejected = Color(0xFFD32F2F);
  static const Color statusRejectedLight = Color(0xFFFFEBEE);
  static const Color statusInfo = Color(0xFF0288D1);
  static const Color statusInfoLight = Color(0xFFE1F5FE);

  // Text & Neutral Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFF1F5F9);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: saffron,
        surface: surfaceWhite,
        error: statusRejected,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryBlue),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.2),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusRejected),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceWhite,
        selectedColor: primaryBlue.withAlpha(25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderLight),
        ),
        labelStyle: const TextStyle(fontSize: 13, color: textPrimary),
      ),
    );
  }
}
