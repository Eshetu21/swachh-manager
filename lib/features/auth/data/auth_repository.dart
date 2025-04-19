import 'package:kabadmanager/core/error_handler/error_handler.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseRpcService _rpcService;
  final SupabaseClient _client = Supabase.instance.client;

  AuthRepository(this._rpcService);
 Future<(String userId, bool isAdmin)> loginAndVerifyAdmin(String email, String password) async {
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
    return (userId, isAdmin);
  } catch (e) {
    throw errorHandler(e);
  }
}


  Future<void> logOut() async {
    try {
      await _client.auth.signOut();
       await OneSignal.logout();
    } catch (e) {
      throw errorHandler(e);
    }
  }
}

