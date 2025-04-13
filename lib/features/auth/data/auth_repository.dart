import 'package:kabadmanager/core/error_handler/error_handler.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseRpcService _rpcService;
  final SupabaseClient _client = Supabase.instance.client;

  AuthRepository(this._rpcService);
  Future<bool> loginAndVerifyAdmin(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final userId = response.user?.id;
      if (userId == null) {
        throw const SkException("Login failed: No user found");
      }
      return await _rpcService.isAdmin();
    } catch (e) {
      throw errorHandler(e);
    }
  }

  Future<void> logOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw errorHandler(e);
    }
  }
}

