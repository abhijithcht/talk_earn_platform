import 'package:flutter/material.dart';

class DesignConstants {
  // --- Colors ---
  static const Color bgDeep = Color(0xFF050B14);
  static const Color glassBg = Color(0x7310192B); // ~45% opacitiy
  static const Color glassBorder = Color(0x14FFFFFF); // ~8% opacity

  static const Color primary = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color accent = Color(0xFF10B981);
  static const Color danger = Color(0xFFEF4444);

  static const Color textMain = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);

  // --- Theme Specific Colors ---
  static const Color dialogBackground = Color(0xFF10192B);

  // --- Gradients Data ---
  static const Color walletGradientStart = Color(0xFF6366F1);
  static const Color walletGradientMiddle = Color(0xFF8B5CF6);
  static const Color walletGradientEnd = Color(0xFFD946EF);

  // --- Surfaces (Less Transparent) ---
  static const Color surfaceSolid = Color(0xFF0F172A);
  static const Color surfaceOverlay = Color(0xF210192B); // 95% opacity for popups

  // --- Spacing ---
  static const double pXS = 4;
  static const double pS = 8;
  static const double pM = 16;
  static const double pL = 24;
  static const double pXL = 32;
  static const double pXXL = 48;

  // --- Breakpoints ---
  static const double mobileLimit = 600;
  static const double tabletLimit = 900;
  static const double desktopLimit = 1200;

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient textGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF38BDF8), Color(0xFF818CF8), Color(0xFFC084FC)],
  );

  // --- Glass Effects ---
  static const double glassBlur = 20;
  static const double glassBorderWidth = 1.2;
  static const Radius glassRadius = Radius.circular(24);

  static BoxShadow glassShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.37),
    blurRadius: 32,
    offset: const Offset(0, 8),
  );
}
