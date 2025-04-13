import 'package:flutter/material.dart';
import 'package:kabadmanager/core/theme/app_theme.dart';
import 'package:kabadmanager/features/auth/presentation/login_screen.dart';
import 'package:kabadmanager/features/dashboard/dashboard.dart';

class KabadWalaApp extends StatelessWidget {
  const KabadWalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KabadManager',
      theme: AppTheme.lightThemeMode,
      darkTheme: ThemeData.dark(), 
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}

