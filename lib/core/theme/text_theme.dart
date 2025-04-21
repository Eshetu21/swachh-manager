import 'package:flutter/material.dart';

class TextThemes {
  static TextTheme get lightTextTheme => const TextTheme(
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        headlineLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      );

  static TextTheme get darkTextTheme => const TextTheme(
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        headlineLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      );
}