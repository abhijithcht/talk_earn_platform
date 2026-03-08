import 'package:flutter/material.dart';
import 'package:frontend/core/theme/design_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DesignConstants.bgDeep,
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: DesignConstants.textMain,
        displayColor: DesignConstants.textMain,
      ),
      colorScheme: const ColorScheme.dark(
        primary: DesignConstants.primary,
        secondary: DesignConstants.secondary,
        surface: DesignConstants.surfaceSolid,
        onSurface: DesignConstants.textMain,
        error: DesignConstants.danger,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: DesignConstants.surfaceOverlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: DesignConstants.glassBorder),
        ),
        elevation: 12,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(DesignConstants.surfaceOverlay),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: DesignConstants.glassBorder),
            ),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: DesignConstants.textMain,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DesignConstants.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DesignConstants.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DesignConstants.secondary, width: 2),
        ),
        hintStyle: const TextStyle(color: DesignConstants.textMuted),
        labelStyle: const TextStyle(color: DesignConstants.textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignConstants.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignConstants.pXL,
            vertical: DesignConstants.pM,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: DesignConstants.glassBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: DesignConstants.glassBorder),
        ),
      ),
    );
  }

  // Maintaining lightTheme for backward compatibility if needed, but darkening it
  static ThemeData get lightTheme => darkTheme;
}
