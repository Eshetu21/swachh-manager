import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabadmanager/gen/assets.gen.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

final showProgress = StateProvider((ref) => false);

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Assets.swachhLogo.image(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SupaEmailAuth(
                  metadataFields: [
                    MetaDataField(
                        prefixIcon: const Icon(Icons.person),
                        label: 'Full Name',
                        key: 'full_name',
                        validator: (v) {
                          if (v?.isEmpty ?? true) {
                            return "The name field can not be empty";
                          } else if (v!.length > 10) {
                            return "The name field can not be more than 10 characters";
                          }
                          return null;
                        })
                  ],
                  onSignInComplete: (response) {},
                  onSignUpComplete: (response) {},
                ),
              ),
            ],
          ),
        ));
  }
}
