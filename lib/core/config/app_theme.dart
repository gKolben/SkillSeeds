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

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF0B1221),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF0B1221),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    // Ensure readable near-white text across the app for accessibility
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: Colors.white70, displayColor: Colors.white70),
    iconTheme: const IconThemeData(color: Colors.white70),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF0B1221),
      iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 0.92), fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardColor: const Color(0xFF111827),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white70,
      textColor: Color.fromRGBO(255, 255, 255, 0.92),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F1724),
      hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.72)),
      labelStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.92)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    dividerColor: Colors.white12,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryColor),
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
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(primaryColor),
      trackColor: WidgetStateProperty.resolveWith((states) => const Color.fromRGBO(124, 58, 237, 0.4)),
    ),
    checkboxTheme: CheckboxThemeData(fillColor: WidgetStateProperty.all(primaryColor)),
    radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(primaryColor)),
  );
}
