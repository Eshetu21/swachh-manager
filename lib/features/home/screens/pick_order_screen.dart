import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabadmanager/features/home/providers/home_page_controller.dart';
import 'package:kabadmanager/features/home/repositories/pickup_request_repository.dart';
import 'package:kabadmanager/models/address_model/address_model.dart';
import 'package:kabadmanager/models/cart_model/cart_model.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';
import 'package:kabadmanager/widgets/app_filled_button.dart';

class PickOrderPage extends ConsumerStatefulWidget {
  const PickOrderPage(
      {super.key,
      required this.address,
      required this.cartItems,
      required this.request});

  final PickupRequestModel request;
  final AddressModel address;
  final List<CartModel> cartItems;

  @override
  _PickOrderPageState createState() => _PickOrderPageState();
}

class _PickOrderPageState extends ConsumerState<PickOrderPage> {
  // Text editing controllers for the text fields
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final SupabaseReqRepository repo = SupabaseReqRepository();

  // Dropdown items
  final List<String> paymentModes = ['Cash', 'UPI'];
  String selectedPaymentMode = 'Cash';

  // List to store key-value pairs for the map
  Map<String, dynamic> keyValuePairs = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pickup Request')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField(
              value: selectedPaymentMode,
              items: paymentModes.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaymentMode = value ?? '';
                });
              },
              decoration: InputDecoration(
                labelText: 'Payment Mode',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius:
                      BorderRadius.circular(12.0), // Set border radius
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .onInverseSurface, // Set background color
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onInverseSurface, // Change the color to your desired background color
                      borderRadius:
                          BorderRadius.circular(12), // Set the border radius
                    ),
                    child: TextField(
                      controller: itemController,
                      decoration: const InputDecoration(
                        labelText: 'Item name',
                        border: InputBorder.none, // Remove default border
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10), // Adjust content padding
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onInverseSurface, // Change the color to your desired background color
                      borderRadius:
                          BorderRadius.circular(12), // Set the border radius
                    ),
                    child: TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: InputBorder.none, // Remove default border
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10), // Adjust content padding
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      keyValuePairs.addEntries([
                        MapEntry(itemController.text, quantityController.text)
                      ]);
                      itemController.clear();
                      quantityController.clear();
                    });
                  },
                  child: const Text('Add'),
                ),
              ],
            ),

            // Display added key-value pairs
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: MapRowsWidget(
                  data: keyValuePairs,
                  onDelete: (key) {
                    setState(() {
                      keyValuePairs.remove(key);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onInverseSurface, // Change the color to your desired background color
                borderRadius:
                    BorderRadius.circular(12), // Set the border radius
              ),
              child: TextField(
                controller: totalPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total',
                  hintText: '250',
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Adjust content padding
                ),
              ),
            ),
            const SizedBox(height: 20),

            // // Button to select image
            // ElevatedButton(
            //   onPressed: () {
            //     // Implement logic to select image
            //   },
            //   child: const Text('Select Image'),
            // ),

            // const SizedBox(height: 20),

            AppFilledButton(
              label: 'Create Transaction',
              asyncTap: () async {
                try {
                  if (keyValuePairs.isEmpty) {
                    showSnackBar(context, 'Enter Item name and Quantity');
                  }
                  if (totalPriceController.text.isEmpty) {
                    showSnackBar(context, 'Enter total amount paid');
                  } else {
                    await repo.createTransaction(
                        requestId: widget.request.id,
                        address: widget.address.toJson(),
                        orderQuantity: keyValuePairs,
                        photograph: null,
                        ownerId: widget.request.requestingUserId,
                        paidAmount: int.parse(totalPriceController.text));
                    ref.invalidate(homePageControllerProvider);
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    showSnackBar(
                        context, 'Can not create transaction at the moment');
                  }
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MapRowsWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key) onDelete;

  const MapRowsWidget({
    super.key,
    required this.data,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.entries.map((entry) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(entry.key),
            Text(entry.value.toString()),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDelete(entry.key);
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}
