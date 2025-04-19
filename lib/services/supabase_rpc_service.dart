import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kabadmanager/core/error_handler/error_handler.dart';
import 'package:kabadmanager/models/address.dart';
import 'package:kabadmanager/models/cart.dart';
import 'package:kabadmanager/models/contact.dart';
import 'package:kabadmanager/models/delivery_partner.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:kabadmanager/models/scrap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

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
      if (status.isEmpty) {
        throw ArgumentError("Status cannot be empty");
      }

      final response = await _client.rpc('get_requests_by_status2', params: {
        'status_param': status,
      });

      if (response == null) return [];

      final List dataList = response is List ? response : [response];

      final requests = dataList
          .map((item) {
            try {
              final json = item is Map<String, dynamic> ? item : {};
              return Request.fromJson({
                'id': json['id']?.toString() ?? '',
                'request_date_time': json['requestDateTime']?.toString() ??
                    json['request_date_time']?.toString() ??
                    DateTime.now().toIso8601String(),
                'address_id': json['addressId']?.toString() ??
                    json['address_id']?.toString() ??
                    '',
                'requesting_user_id': json['requestingUserId']?.toString() ??
                    json['requesting_user_id']?.toString() ??
                    '',
                'schedule_date_time': json['scheduleDateTime']?.toString() ??
                    json['schedule_date_time']?.toString() ??
                    DateTime.now().toIso8601String(),
                'total_price': json['totalPrice'] ?? json['total_price'] ?? 0.0,
                'status': json['status']?.toString() ?? 'pending',
                'qty_range': json['qtyRange']?.toString() ??
                    json['qty_range']?.toString(),
                'delivery_partner_id': json['deliveryPartnerId']?.toString() ??
                    json['delivery_partner_id']?.toString(),
                'pickup_time': json['pickupTime']?.toString() ??
                    json['pickup_time']?.toString(),
              });
            } catch (e, stack) {
              debugPrint("Error parsing request item: $e");
              debugPrint(stack.toString());
              return Request.fromJson({});
            }
          })
          .where((request) => request.id.isNotEmpty)
          .toList();
      return requests;
    } catch (e, stack) {
      debugPrint("Error fetching requests: $e");
      debugPrint(stack.toString());
      return [];
    }
  }

  Future<Contact> getContactDetailsByReqId(String reqId) async {
    try {
      final data = (await _client.rpc('get_user_metadata', params: {
        'req_id': reqId,
      }));
      return Contact.fromJson(data);
    } catch (error) {
      throw SkException('Failed to fetch addresses: $error');
    }
  }

  Future<Address?> fetchAddressById(String addressId) async {
    try {
      final response = await _client.rpc('fetchaddressbyid', params: {
        'address_id': addressId,
      });

      if (response == null || response is! Map<String, dynamic>) {
        return null;
      }
      final latlng = response['latlng'];
      final latlngString = latlng is Map
          ? '${latlng['lat']},${latlng['lng']}'
          : (latlng?.toString() ?? '');

      final address = Address(
        id: response['id'] ?? '',
        address: response['address'] ?? '',
        label: response['label'] ?? '',
        ownerId: response['ownerId'] ?? '',
        latlng: latlngString,
        category: response['category'],
        houseStreetNo: response['houseStreetNo'],
        apartmentRoadAreaLandMark: response['apartmentRoadAreadLandmark'],
        phoneNumber: response['phoneNumber'],
      );

      return address;
    } catch (e) {
      debugPrint("Error in fetchAddressById: $e");
      return null;
    }
  }

  Future<List<Cart>> getCartItemsByReqId(String id) async {
    try {
      final data = await _client
          .from('cart')
          .select("*,scrap:scrap_id(*)")
          .eq('request_id', id);
      return data.map((item) => Cart.fromJson(item)).toList();
    } catch (error) {
      throw SkException('Failed to fetch cart items: $error');
    }
  }

  /* Future<void> changeRequestStatus({
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
  } */

  Future<void> updateRequestStatus(
      String requestId, RequestStatus newStatus) async {
    try {
      await _client
          .from('requests')
          .update({'status': newStatus.name}).eq('id', requestId);
    } catch (e) {
      throw const SkException('Failed to update Request Status');
    }
  }

  Future<List<DeliveryPartner>> searchPartnerByName(String name) async {
    try {
      final response = await Supabase.instance.client.rpc(
          'search_delivery_partners_by_name',
          params: {"search_name": name});
      return (response as List)
          .map((e) => DeliveryPartner.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> acceptRequestWithPartner(
      {required String requestId, required String partnerId}) async {
    try {
      await _client.from('requests').update({
        'status': RequestStatus.accepted.name,
        'deliveryPartnerId': partnerId,
      }).eq('id', requestId);
    } catch (e) {
      throw SkException('Failed to accept request with partner: $e');
    }
  }

  Future<List<DeliveryPartner>> fetchAllDeliveryPartners() async {
    try {
      final response = await _client.rpc('get_all_delivery_partners');
      return (response as List)
          .map((e) => DeliveryPartner.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
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
      await _client.from("transactions").insert({
        "requestId": requestId,
        "pickupLocationId": addressId,
        "orderQuantity": orderQuantity,
        "photograph": photograph,
        "ownerId": ownerId,
        "totalAmountPaid": paidAmount,
      });
    } catch (e) {
      throw SkException('Failed to create transaction: $e');
    }
  }

  Future<List<ScrapModel>> getScrapRecommendations(String name) async {
    try {
      final response = await _client
          .from('scraps')
          .select('*')
          .ilike('name', '%$name%')
          .limit(5);
      return response.map((e) => ScrapModel.fromJson(e)).toList();
    } catch (e) {
      throw SkException('Failed to fetch scrap items: $e');
    }
  }

  Future<void> deleteCartItem(String cartId) async {
    try {
      await _client.from('cart').delete().eq('id', cartId);
      debugPrint('Deleted $cartId');
    } catch (e) {
      debugPrint('Failed to delete $e');
      throw SkException('Failed to delete cart item: $e');
    }
  }

  Future<String> insertCartItem({
    required String scrapId,
    required int qty,
    required String requestId,
  }) async {
    try {
      final response = await _client
          .from('cart')
          .insert({
            'scrap_id': scrapId,
            'qty': qty,
            'request_id': requestId,
          })
          .select('id')
          .single();
      return response['id'] as String;
    } catch (e) {
      throw Exception("Failed to insert cart item: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      await dotenv.load(fileName: ".env");
      final supaBaseKey = dotenv.env["SUPABASE_KEY"] ?? "";
      final response = await http.get(
        Uri.parse(
            'https://kbfzdoqimcdqltudyeht.supabase.co/functions/v1/get-all-users'),
        headers: {'Authorization': 'Bearer $supaBaseKey '},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final usersObject = data['users'] as Map<String, dynamic>? ?? {};
        final usersList = usersObject['users'] as List? ?? [];

        return usersList.map((user) => user as Map<String, dynamic>).toList();
      } else {
        throw Exception(
            'API request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<Map<String, dynamic>> addDeliveryPartner(String userId) async {
    try {
      final response = await _client.rpc('add_delivery_partner2', params: {
        'user_id_param': userId,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to add delivery partner: ${e.toString()}');
    }
  }
}

