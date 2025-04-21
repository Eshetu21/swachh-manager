import 'package:kabadmanager/core/error_handler/error_handler.dart';
import 'package:kabadmanager/services/session_service.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseRpcService _rpcService;
  final SupabaseClient _client = Supabase.instance.client;
  final SessionService _sessionService;

  AuthRepository(this._rpcService, this._sessionService);
  Future<(String userId, bool isAdmin)> loginAndVerifyAdmin(
      String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final userId = response.user?.id;
      if (userId == null) {
        throw const SkException("Login failed: No user found");
      }
      final isAdmin = await _rpcService.isAdmin();
      if (isAdmin) {
        await _sessionService.saveLoginState(isAdmin);
      }
      return (userId, isAdmin);
    } catch (e) {
      throw errorHandler(e);
    }
  }

  Future<void> logOut() async {
    try {
      await _client.auth.signOut();
      await OneSignal.logout();
      await _sessionService.clearLoginState();
    } catch (e) {
      throw errorHandler(e);
    }
  }
}

