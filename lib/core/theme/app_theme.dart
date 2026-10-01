import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF1E293B);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.light,
          surface: lightBackground,
        ),
        scaffoldBackgroundColor: lightBackground,
        fontFamily: 'Inter',
        cardTheme: CardThemeData(
          color: lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: lightBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          foregroundColor: Color(0xFF0F172A),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: lightCard,
          indicatorColor: Color.fromRGBO(139, 92, 246, 0.15),
          elevation: 0,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 11, fontFamily: 'Inter', fontWeight: FontWeight.w600),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.dark,
          surface: darkBackground,
        ),
        scaffoldBackgroundColor: darkBackground,
        fontFamily: 'Inter',
        cardTheme: CardThemeData(
          color: darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          foregroundColor: Color(0xFFF8FAFC),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkCard,
          indicatorColor: Color.fromRGBO(139, 92, 246, 0.25),
          elevation: 0,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 11, fontFamily: 'Inter', fontWeight: FontWeight.w600),
          ),
        ),
      );
}
