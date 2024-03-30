part of 'home_page_controller.dart';

@freezed
class HomePageControllerState with _$HomePageControllerState {
    const factory HomePageControllerState.loading() = _Initial;
    const factory HomePageControllerState.data({required List<PickupRequestModel> models}) = _Data;
    const factory HomePageControllerState.error(Object e) = _Error;
    const factory HomePageControllerState.networkError() = _NetworkError;
}
