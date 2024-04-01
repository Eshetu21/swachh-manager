import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:kabadmanager/core/services/notification_service.dart';
import 'package:kabadmanager/features/auth/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part "auth_controller.g.dart";

@Riverpod(keepAlive: true)
Future<bool> isAuthorized(IsAuthorizedRef ref) async {
  return await AuthRepository().isAdmin();
}

@Riverpod(keepAlive: true)
AuthController authController(AuthControllerRef ref) {
  final authStates = ref.watch(authStateChangesProvider);
  final authorized = ref.watch(isAuthorizedProvider);
  if (authStates.value?.event == null) {
    return const AuthController(AppAuthState.loading);
  }
  if (authStates.value?.session != null) {
    final sessionUser = authStates.value!.session!.user;

    SupabaseNotificationWrapper.instance.initialize();

    FirebaseAnalytics.instance.setUserId(
      id: sessionUser.id,
    );

    if (authorized.value == true) {
      return const AuthController(AppAuthState.authenticated);
    }
    return const AuthController(AppAuthState.unAuthorized);
  } else {
    return const AuthController(AppAuthState.unauthenticated);
  }
}

@Riverpod(keepAlive: true)
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
}

enum AppAuthState { authenticated, loading, unauthenticated, unAuthorized }

class AuthController {
  final AppAuthState state;

  const AuthController(this.state);

  AuthRepository get _repo => AuthRepository();

  Future<User?> get user => _repo.getUser();

  Future<void> signInWithOtp(String phone) async {
    await _repo.signInWithOtp(phone);
  }

  Future<void> signOut() async {
    await _repo.signOut();
    return;
  }

  Future<User?> signInWithGoogle() async {
    return await _repo.signInWithGoogle();
  }

  Future<User?> verifyOtp(
      {required String token,
      String? phone,
      required OtpType type,
      String? email}) async {
    return await _repo.verifyOtp(
        t: token, phoneNumber: phone, email: email, otpType: type);
  }

  Future<User?> getUser() async {
    return await _repo.getUser();
  }
}
