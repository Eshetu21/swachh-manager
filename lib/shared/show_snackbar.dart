import 'package:flutter/material.dart';
import 'package:kabadmanager/core/theme/app_pallete.dart';

class ShowSnackbar {
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    if (!context.mounted) return;

    final theme = Theme.of(context);
    final backgroundColor =
        isError ? AppPallete.errorColor : AppPallete.successColor;

    final textColor =
        isError ? AppPallete.lightBackgroundColor : AppPallete.whiteColor;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
      duration: duration,
      elevation: 2,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

