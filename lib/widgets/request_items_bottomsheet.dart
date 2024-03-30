import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabadmanager/features/home/repositories/pickup_request_repository.dart';
import 'package:kabadmanager/models/cart_model/cart_model.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';
import 'package:kabadmanager/widgets/cart_item_tile.dart';
import 'package:kabadmanager/widgets/request_status_widget.dart';
import 'package:kabadmanager/widgets/text_widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_items_bottomsheet.g.dart';

@riverpod
Future<List<CartModel>> getCartItem(GetCartItemRef ref,
    {required String requestId}) async {
  return SupabaseReqRepository().getCartItemsByReqId(requestId);
}

Future<void> showRequestContentsBottomSheet(BuildContext context,
    {required PickupRequestModel requestModel}) async {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return _RequestContentsBottomSheetWidget(requestModel: requestModel);
    },
  );
}

class _RequestContentsBottomSheetWidget extends ConsumerWidget {
  final PickupRequestModel requestModel;

  const _RequestContentsBottomSheetWidget(
      {super.key, required this.requestModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const HeadlineSmall(
                    text: 'Scrap Items',
                    weight: FontWeight.bold,
                  ),
                  Row(
                    children: [
                      RequestStatusWidget(requestModel.status),
                    ],
                  )
                ],
              ),
            ),
            Builder(builder: (context) {
              final items =
                  ref.watch(getCartItemProvider(requestId: requestModel.id));
              return items.when(
                  data: (models) {
                    return Flexible(
                      child: ListView.builder(
                        itemCount:
                            models.length, // Replace with the actual item count
                        itemBuilder: (context, index) {
                          return CartItemTile(model: models[index]);
                        },
                      ),
                    );
                  },
                  error: (e, s) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      showSnackBar(context, 'Look\'s like an error Occurred');
                      Navigator.pop(context);
                    });
                    return const SizedBox();
                  },
                  loading: () => const Center(
                        child: CupertinoActivityIndicator(),
                      ));
            }),
          ],
        ),
      ),
    );
  }
}
