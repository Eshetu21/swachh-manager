import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kabadmanager/features/home/repositories/pickup_request_repository.dart';
import 'package:kabadmanager/models/address_model/address_model.dart';
import 'package:kabadmanager/models/cart_model/cart_model.dart';
import 'package:kabadmanager/models/contact_model/contact_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preview_page_controller.freezed.dart';
part 'preview_page_controller.g.dart';
part 'preview_page_controller_state.dart';

@riverpod
class PreviewPageController extends _$PreviewPageController {
  final _repo = SupabaseReqRepository();
  @override
  PreviewPageControllerState build() {
    return const _Initial();
  }

  void loadData(String reqId, String addrId) async {
    try {
      final addressModel = await _repo.getAddressByReqId(addrId);
      final cartModels = await _repo.getCartItemsByReqId(reqId);
      final contactDetails = await _repo.getContactDetailsByReqId(reqId);
      state = _Data(
          cartModels: cartModels,
          addressModel: addressModel,
          details: contactDetails);
    } catch (e) {
      print(e);
    }
  }
}
