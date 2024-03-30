part of 'preview_page_controller.dart';

@freezed
class PreviewPageControllerState with _$PreviewPageControllerState {
  const factory PreviewPageControllerState.initial() = _Initial;
  const factory PreviewPageControllerState.data(
      {required List<CartModel> cartModels,
      required AddressModel addressModel,
      required ContactModel details}) = _Data;
}
