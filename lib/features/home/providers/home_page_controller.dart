import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kabadmanager/features/home/models/search_param.dart';
import 'package:kabadmanager/features/home/repositories/pickup_request_repository.dart';
import 'package:kabadmanager/features/home/screens/home_page.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_page_controller.freezed.dart';
part 'home_page_controller.g.dart';
part 'home_page_controller_state.dart';

@riverpod
class HomePageController extends _$HomePageController {
  final _repo = SupabaseReqRepository();
  List<PickupRequestModel> _models = [];
  @override
  HomePageControllerState build() {
    final status = ref.watch(categoryProvider);
    getRequestsByStatus(status);
    return const _Initial();
  }

  void getRequestsByStatus(RequestStatus status) async {
    try {
      state = const _Initial();
      final models = await _repo.listModelsByStatus(status);
      state = _Data(models: models);
      _models = models;
    } catch (e) {
      state = _Error(e);
    }
  }

  void searchByParam(SearchParamFilter filter) async {
    try {
      final models = await _repo.searchByParam(filter);
      state = _Data(models: models);
      _models = models;
    } catch (e) {
      state = _Error(e);
    }
  }

  void updateStatus(
      {required String id, required RequestStatus newStatus}) async {
    try {
      await _repo.updateRequestStatus(id, newStatus);
      _models.removeWhere((element) => element.id == id);
      state = _Data(models: _models);
      // _models[index] = _models[index].copyWith(status: newStatus);
    } catch (e) {
      print(e);
      // throw error maybe catch...
    }
  }
}
