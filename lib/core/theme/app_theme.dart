import 'package:flutter/material.dart';
import 'package:kabadmanager/core/theme/app_pallete.dart';
import 'package:kabadmanager/core/theme/text_theme.dart';

class AppTheme {
  static OutlineInputBorder _border(
          [Color color = AppPallete.lightBorderColor]) =>
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
      textTheme: TextThemes.lightTextTheme.apply(
        bodyColor: AppPallete.lightTextColor,
        fontFamily: 'ProductSans',
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(color: AppPallete.errorColor),
        hintStyle: const TextStyle(color: AppPallete.lightHintTextColor),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: _border(),
        focusedBorder: _border(),
        errorBorder: _border(AppPallete.errorColor),
        focusedErrorBorder: _border(AppPallete.errorColor),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppPallete.primaryColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          minimumSize: WidgetStatePropertyAll(Size(double.infinity, 45)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return AppPallete.primaryColor;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return AppPallete.whiteColor;
            },
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45)),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppPallete.lightIconColor,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey.shade200,
      ));

  static final darkThemeMode = ThemeData(
    scaffoldBackgroundColor: AppPallete.darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.darkBackgroundColor,
      foregroundColor: AppPallete.whiteColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPallete.successColor,
      primary: AppPallete.successColor,
      secondary: AppPallete.successColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    textTheme: TextThemes.darkTextTheme.apply(
      bodyColor: AppPallete.darkTextColor,
      fontFamily: 'ProductSans',
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(color: AppPallete.errorColor),
      hintStyle: const TextStyle(color: AppPallete.whiteColor),
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(AppPallete.greyColor),
      focusedBorder: _border(AppPallete.greyColor),
      errorBorder: _border(AppPallete.errorColor),
      focusedErrorBorder: _border(AppPallete.errorColor),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45)),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppPallete.whiteColor;
            }
            return AppPallete.whiteColor;
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppPallete.whiteColor;
            }
            return AppPallete.whiteColor;
          },
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            return AppPallete.primaryColor;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            return AppPallete.whiteColor;
          },
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45)),
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppPallete.darkIconColor,
    ),
  );
}

