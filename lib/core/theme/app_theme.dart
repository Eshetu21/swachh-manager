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
        foregroundColor: WidgetStatePropertyAll(AppPallete.whiteColor),
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
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.grey.shade200,
    ),
    cardTheme: CardThemeData(
      color: AppPallete.lightCardColor,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppPallete.lightChipBackgroundColor,
      disabledColor: Colors.grey.shade300,
      selectedColor: AppPallete.primaryColor,
      secondarySelectedColor: AppPallete.primaryColor.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelStyle: TextThemes.lightTextTheme.labelSmall?.copyWith(
        color: AppPallete.lightTextColor,
      ),
      secondaryLabelStyle: TextThemes.lightTextTheme.labelSmall?.copyWith(
        color: AppPallete.whiteColor,
      ),
      brightness: Brightness.light,
      elevation: 0,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

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
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppPallete.primaryColor),
        foregroundColor: WidgetStatePropertyAll(AppPallete.whiteColor),
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
      color: AppPallete.darkIconColor,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppPallete.darkChipBackgroundColor,
      disabledColor: Colors.grey.shade700,
      selectedColor: AppPallete.successColor,
      secondarySelectedColor: AppPallete.successColor.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelStyle: TextThemes.darkTextTheme.labelSmall?.copyWith(
        color: AppPallete.darkTextColor,
      ),
      secondaryLabelStyle: TextThemes.darkTextTheme.labelSmall?.copyWith(
        color: AppPallete.whiteColor,
      ),
      brightness: Brightness.dark,
      elevation: 0,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

