import 'package:kabadmanager/models/delivery_partner_model/delivery_partner_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeliveryPartnersRepository {
  Future<List<DeliveryPartnerModel>> searchPartnerByName(String name) async {
    try {
      final response = await Supabase.instance.client.rpc(
          'search_delivery_partners_by_name',
          params: {"search_name": name});
      return (response as List)
          .map((e) => DeliveryPartnerModel.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
