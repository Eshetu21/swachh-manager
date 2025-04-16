import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Center(
            child: GestureDetector(
                onTap: () {
                  // const AuthRoute().go(context);
                },
                child: const Text("Loading..."))),
      ),
    );
  }
}

