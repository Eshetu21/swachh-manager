import 'package:flutter/material.dart';
import 'package:kabadmanager/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPallete.borderColor]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1),
        borderRadius: BorderRadius.circular(10),
      );

  static final lightThemeMode = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      primary: Colors.green,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppPallete.textColor,
          fontFamily: 'ProductSans',
        ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: AppPallete.hintTextColor),
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(AppPallete.errorColor),
      focusedErrorBorder: _border(AppPallete.errorColor),
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        minimumSize: WidgetStatePropertyAll(Size(double.infinity, 45)),
      ),
    ),
  );
}
