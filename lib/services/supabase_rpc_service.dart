import 'package:kabadmanager/core/error_handler/error_handler.dart';
import 'package:kabadmanager/models/address.dart';
import 'package:kabadmanager/models/cart.dart';
import 'package:kabadmanager/models/contact.dart';
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
              print("Error parsing request item: $e");
              print(stack);
              return Request.fromJson({});
            }
          })
          .where((request) => request.id.isNotEmpty)
          .toList();
      print('Fetched ${requests.length} requests with status "$status":');
      for (final r in requests) {
        print(
            '→ Request ID: ${r.id}, Qty: ${r.qtyRange}, Status: ${r.status}, AddressID: ${r.addressId}');
      }

      return requests;
    } catch (e, stack) {
      print("Error fetching requests: $e");
      print(stack);
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

      print("Fetched Address: ${address.toJson()}");

      return address;
    } catch (e) {
      print("Error in fetchAddressById: $e");
      return null;
    }
  }

  Future<List<Cart>> getCartItemsByReqId(String id) async {
    try {
      final data = await _client
          .from('cart')
          .select("*,scrap:scrap_id(*)")
          .eq('request_id', id);
      print('getCartItemsByReqId $data');
      return data.map((item) => Cart.fromJson(item)).toList();
    } catch (error) {
      throw SkException('Failed to fetch cart items: $error');
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

