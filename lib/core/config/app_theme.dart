import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF7C3AED);
  static const Color secondaryColor = Color(0xFF10B981);
  static const Color accentColor = Color(0xFFF59E0B);
  static const Color textColor = Color(0xFF374151);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFF9FAFB);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textColor,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: textColor),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
          color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
