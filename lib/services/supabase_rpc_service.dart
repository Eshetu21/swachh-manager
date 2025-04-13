import 'package:kabadmanager/core/error_handler/error_handler.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRpcService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> isAdmin() async {
    try {
      final response = await _client.rpc('is_admin');
      return response as bool? ?? false;
    } catch (e) {
      throw errorHandler(e);
    }
  }

  Future<List<Request>> fetchRequestsByStatus(String status) async {
    try {
      final response = await _client
          .rpc('get_requests_by_status', params: {"status": status});
      if (response is List) {
        return response.map((item) => Request.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("Function call error (get_requests_by_status): $e");
      return [];
    }
  }

  Future<void> changeRequestStatus({
    required String requestId,
    required String newStatus,
  }) async {
    try {
      await _client.rpc('change_request_status', params: {
        "request_id": requestId,
        "new_status": newStatus,
      });
    } catch (e) {
      print("Function call error (change_request_status): $e");
    }
  }

  Future<void> assignDeliveryPartner({
    required String requestId,
    required String partnerId,
  }) async {
    try {
      await _client.rpc('assign_delivery_partner', params: {
        "request_id": requestId,
        "partner_id": partnerId,
      });
    } catch (e) {
      print("Function call error (assign_delivery_partner): $e");
    }
  }

  Future<void> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      await _client.rpc('create_transaction', params: transactionData);
    } catch (e) {
      print("Function call error (create_transaction): $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchDeliveryPartners() async {
    try {
      final response = await _client.rpc('get_delivery_partners');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print("Function call error (get_delivery_partners): $e");
      return [];
    }
  }
}

