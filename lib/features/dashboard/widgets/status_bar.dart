import 'package:flutter/material.dart';
import 'package:kabadmanager/core/theme/app_pallete.dart';

class StatusTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSmallScreen;

  const StatusTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isSmallScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = isSelected
        ? Colors.green
        : theme.brightness == Brightness.dark
            ? AppPallete.tabUnselectedColorDark
            : AppPallete.tabUnselectedColorLight;

    final textColor = isSelected
        ? Colors.white
        : theme.brightness == Brightness.dark
            ? AppPallete.whiteColor
            : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 24,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 6 : 8,
          vertical: isSmallScreen ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
      ),
    );
  }
}

