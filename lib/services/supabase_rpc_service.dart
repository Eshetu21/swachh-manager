import 'package:kabadmanager/models/request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRpcService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> isAdmin(String userId) async {
    final response =
        await _client.functions.invoke("is_admin", body: {"user_id": userId});
    if (response.status != 200 || response.data == null) {
      return false;
    }
    return response.data["is_admin"] ?? false;
  }

  Future<List<Request>> fetchRequestsByStatus(String status) async {
    final response = await _client.functions
        .invoke("get_requests_by_status", body: {"status": status});
    if (response.status != 200 || response.data == null) {
      return [];
    }
    return (response.data as List)
        .map((item) => Request.fromJson(item))
        .toList();
  }

  Future<void> changeRequestStatus(
      {required String requestId, required String newStatus}) async {
    await _client.functions.invoke("change_request_status",
        body: {"request_id": requestId, "new_status": newStatus});
  }

  Future<void> assignDeliveryParnert(
      {required String requestId, required String partnerId}) async {
    await _client.functions.invoke("assign_delivery_parnter",
        body: {"request_id": requestId, "partner_id": partnerId});
  }

  Future<void> createTransaction(Map<String, dynamic> transactionData) async {
    await _client.functions.invoke('create_transaction', body: transactionData);
  }

  Future<List<Map<String, dynamic>>> fetchDeliveryPartners() async {
    final response = await _client.functions.invoke('get_delivery_partners');

    if (response.status != 200 || response.data == null) return [];

    return List<Map<String, dynamic>>.from(response.data);
  }
}

