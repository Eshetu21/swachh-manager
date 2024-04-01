import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabadmanager/features/auth/providers/auth_controller.dart';
import 'package:kabadmanager/widgets/app_filled_button.dart';
import 'package:kabadmanager/widgets/text_widgets.dart';

class UnAuthorizedPage extends ConsumerWidget {
  const UnAuthorizedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              child: TitleLarge(
                maxLines: 3,
                text:
                    'Look\'s like you are unAuthorized to access this application',
              ),
            ),
            AppFilledButton(
              label: 'LogOut',
              onTap: () async {
                ref.invalidate(isAuthorizedProvider);
                await ref.read(authControllerProvider).signOut();
                return;
              },
            )
          ],
        ),
      ),
    );
  }
}
