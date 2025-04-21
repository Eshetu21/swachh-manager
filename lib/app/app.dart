import 'package:flutter/material.dart';
import 'package:kabadmanager/core/theme/app_theme.dart';
import 'package:kabadmanager/features/auth/presentation/login_screen.dart';
import 'package:kabadmanager/features/dashboard/dashboard.dart';

class KabadWalaApp extends StatelessWidget {
  final String initialRoute;

  const KabadWalaApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KabadManager',
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: ThemeMode.system, 
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}