import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabadmanager/features/auth/providers/auth_controller.dart';

final showProgress = StateProvider((ref) => false);

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () {
            ref.read(authControllerProvider).signInWithGoogle();
          },
          child: const Text('Login With Google')),
    ));
  }
}
