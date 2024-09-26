import 'package:kabadmanager/core/error_handler/error_handler.dart';
import 'package:kabadmanager/features/home/models/search_param.dart';
import 'package:kabadmanager/models/address_model/address_model.dart';
import 'package:kabadmanager/models/cart_model/cart_model.dart';
import 'package:kabadmanager/models/contact_model/contact_model.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:kabadmanager/models/scrap_model/scrap_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BaseRequestsRepository {
  Future<List<PickupRequestModel>> listModelsByStatus(
    RequestStatus status,
  );

  Future<List<ScrapModel>> getScrapRecommendations(String name);

  void updateRequestStatus(String requestId, RequestStatus newStatus);

  Future<List<PickupRequestModel>> searchByParam(SearchParamFilter filter);
}

class SupabaseReqRepository extends BaseRequestsRepository {
  final _supabaseClient = Supabase.instance.client;
  final int _limit = 50;
  final int _offset = 0;

  @override
  Future<List<ScrapModel>> getScrapRecommendations(String name) async {
    try {
      final models = await _supabaseClient
          .from('scraps')
          .select('*')
          .ilikeAnyOf('name', ['%$name%']);

      return (models as List).map((e) => ScrapModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Future<bool> assignRequestToPartner(String userId)async{
  //   try {
  //     await _supabaseClient.from('requests').update({'status':"accepted","assignedUserId":''})
  //   } catch (e) {

  //   }
  // }

  @override
  Future<List<PickupRequestModel>> listModelsByStatus(
    RequestStatus status,
  ) async {
    final models = await _supabaseClient
        .from('requests')
        .select('*,address:addressId(*)')
        .eq('status', status.name)
        .order('scheduleDateTime')
        .range(_offset, _offset + _limit);
    return models.map((json) => PickupRequestModel.fromJson(json)).toList();
  }

  Future<List<PickupRequestModel>> listModelsFromDatetime(
      RequestStatus status, DateTime from, DateTime to) async {
    final models = await _supabaseClient
        .from('requests')
        .select('*,address:addressId(*)')
        .eq('status', status.name)
        .gte('requestDateTime', from.toIso8601String())
        .lte('requestDateTime', to.toIso8601String())
        .order('scheduleDateTime')
        .range(_offset, _offset + _limit);
    return models.map((json) => PickupRequestModel.fromJson(json)).toList();
  }

  @override
  Future<List<PickupRequestModel>> searchByParam(
      SearchParamFilter filter) async {
    final models = await _supabaseClient
        .from('requests')
        .select('*')
        .order('scheduleDateTime')
        .range(_offset, _offset + _limit);
    return models.map((json) => PickupRequestModel.fromJson(json)).toList();
  }

  @override
  Future<void> updateRequestStatus(
      String requestId, RequestStatus newStatus) async {
    try {
      await _supabaseClient
          .from('requests')
          .update({'status': newStatus.name}).eq('id', requestId);
    } catch (e) {
      throw const SkException('Failed to update Request Status');
    }
  }

  Future<List<CartModel>> getCartItemsByReqId(String id) async {
    try {
      final data = await _supabaseClient
          .from('cart')
          .select("*,scrap:scrap_id(*)")
          .eq('request_id', id);
      return data.map((item) => CartModel.fromJson(item)).toList();
    } catch (error) {
      throw SkException('Failed to fetch cart items: $error');
    }
  }

  Future<AddressModel> getAddressByReqId(String addrId) async {
    try {
      final data = (await _supabaseClient.rpc('fetchaddressbyid', params: {
        'address_id': addrId,
      }).single());
      return AddressModel.fromJson(data);
    } catch (error) {
      throw SkException('Failed to fetch addresses: $error');
    }
  }

  Future<ContactModel> getContactDetailsByReqId(String reqId) async {
    try {
      final data = (await _supabaseClient.rpc('get_user_metadata', params: {
        'req_id': reqId,
      }));
      return ContactModel.fromJson(data);
    } catch (error) {
      throw SkException('Failed to fetch addresses: $error');
    }
  }

  Future<bool> assignDeliveryPartner(String reqId, String partnerId) async {
    try {
      await _supabaseClient
          .from('requests')
          .update({"deliveryPartnerId": partnerId}).eq('id', reqId);
      return true;
    } catch (error) {
      throw SkException('Failed to assign partner: $error');
    }
  }

  Future<void> createTransaction({
    required String requestId,
    required String addressId,
    required Map<String, dynamic> orderQuantity,
    required String? photograph,
    required String ownerId,
    required double paidAmount,
  }) async {
    try {
      await _supabaseClient.from("transactions").insert({
        "requestId": requestId,
        "pickupLocationId": addressId,
        "orderQuantity": orderQuantity,
        "photograph": photograph,
        "ownerId": ownerId,
        "totalAmountPaid": paidAmount,
      });
      return;
    } catch (error) {
      throw SkException('Failed to create transaction: $error');
    }
  }
}
