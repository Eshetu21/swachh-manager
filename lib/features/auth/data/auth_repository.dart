import 'package:kabadmanager/services/supabase_rpc_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseRpcService _rpcService;
  final SupabaseClient _client = Supabase.instance.client;

  AuthRepository(this._rpcService);

  Future<bool> loginAndVerifyAdmin(String email, String password) async {
    final response =
        await _client.auth.signInWithPassword(email: email, password: password);
    final userId = response.user?.id;
    if (userId == null) {
      return false;
    }
    final isAdmin = await _rpcService.isAdmin(userId);
    return isAdmin;
  }
}

