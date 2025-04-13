import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabadmanager/core/theme/text_theme.dart';
import 'package:kabadmanager/features/auth/presentation/login_screen.dart';

class KabadWalaApp extends StatelessWidget {
  const KabadWalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KabadManager',
      theme: ThemeData(
        outlinedButtonTheme: const OutlinedButtonThemeData(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
                minimumSize:
                    WidgetStatePropertyAll(Size(double.infinity, 45)))),
        textTheme: GoogleFonts.poppinsTextTheme(TextThemes.textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(TextThemes.textTheme),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

