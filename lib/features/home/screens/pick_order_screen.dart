import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabadmanager/features/home/providers/home_page_controller.dart';
import 'package:kabadmanager/features/home/repositories/pickup_request_repository.dart';
import 'package:kabadmanager/models/address_model/address_model.dart';
import 'package:kabadmanager/models/cart_model/cart_model.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:kabadmanager/models/scrap_model/scrap_model.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';
import 'package:kabadmanager/widgets/app_filled_button.dart';

class PickOrderPage extends ConsumerStatefulWidget {
  const PickOrderPage({
    super.key,
    required this.address,
    required this.cartItems,
    required this.request,
  });

  final PickupRequestModel request;
  final AddressModel address;
  final List<CartModel> cartItems;

  @override
  _PickOrderPageState createState() => _PickOrderPageState();
}

final cartItemsProvider =
    FutureProvider.family<List<CartModel>, String>((ref, requestId) async {
  // Fetch pickup request items from the repository
  return await SupabaseReqRepository().getCartItemsByReqId(requestId);
});

class _PickOrderPageState extends ConsumerState<PickOrderPage> {
  // Controllers for the text fields
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController customAmountController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final SupabaseReqRepository repo = SupabaseReqRepository();

  TextEditingController? getTextEditingController;
  @override
  void initState() {
    _popuplateCartItems();
    super.initState();
  }

  _popuplateCartItems() {
    Future.delayed(const Duration(milliseconds: 200), () {
      for (var element in widget.cartItems) {
        keyValuePairs.putIfAbsent(
            element.scrap.name,
            () => {
                  'quantity': '0',
                  'amount': element.scrap.price,
                  'measureType': element.scrap.measure.name,
                });
      }
      _calculateTotal();
    });
  }

  // Dropdown items
  final List<String> paymentModes = ['Cash', 'UPI'];
  String selectedPaymentMode = 'Cash';

  final List<String> measureTypes = ['kg', 'units'];
  String selectedMeasureType = 'kg'; // Default measure type

  // List to store key-value pairs for the map
  Map<String, dynamic> keyValuePairs = {};

  // Store total price
  double totalPrice = 0.0;

  // Store Scrap amount based on item selected
  Map<String, double> itemAmounts = {};

  // Function to calculate total
  void _calculateTotal() {
    totalPrice = keyValuePairs.entries.fold(0, (sum, entry) {
      String itemName = entry.key;
      double quantity = double.parse(entry.value['quantity']);
      double amount = entry.value['amount'];

      return sum + (quantity * amount);
    });
    setState(() {
      totalPriceController.text = totalPrice.toString();
    });
  }

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
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: MapRowsWidget(
                  calculateTotal: _calculateTotal,
                  onSetQuantity: (amount) => {},
                  calculateTotalAmount: (a) {
                    return 2.00;
                  },
                  data: keyValuePairs,
                  onDelete: (key) {
                    setState(() {
                      keyValuePairs.remove(key);
                      _calculateTotal();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: totalPriceController,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Total',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AddItemPopup(
                        onSubmit: (p0) {
                          keyValuePairs.addAll(p0);
                          _calculateTotal();
                          setState(() {});
                        },
                      );
                    },
                  );
                },
                child: const Text("Add new item")),
            const SizedBox(height: 20),
            AppFilledButton(
              label: 'Create Transaction',
              asyncTap: () async {
                try {
                  if (keyValuePairs.isEmpty) {
                    showSnackBar(context, 'Enter Item name and Quantity');
                  } else if (totalPriceController.text.isEmpty) {
                    showSnackBar(context, 'Enter total amount paid');
                  } else if (double.parse(totalPriceController.text) < 0) {
                    showSnackBar(
                        context, 'The total amount can not be less or zero');
                  } else {
                    await repo.createTransaction(
                        requestId: widget.request.id,
                        address: widget.address.toJson(),
                        orderQuantity: keyValuePairs,
                        photograph: null,
                        ownerId: widget.request.requestingUserId,
                        paidAmount: double.parse(totalPriceController.text));
                    ref.invalidate(homePageControllerProvider);
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    showSnackBar(
                        context, 'Cannot create transaction at the moment');
                  }
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
  final Function(int amount) onSetQuantity;
  final Function() calculateTotal;
  final Function(String key)
      calculateTotalAmount; // Add this to calculate the total

  const MapRowsWidget({
    super.key,
    required this.data,
    required this.calculateTotal,
    required this.onSetQuantity,
    required this.onDelete,
    required this.calculateTotalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Table Header
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 2,
                  child: Text('Item',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
                  child: Text('Quantity',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 1,
                  child: Text('Price',
                      style: TextStyle(fontWeight: FontWeight.bold))),

              Expanded(
                  flex: 1,
                  child: Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 50), // Space for the delete icon
            ],
          ),
        ),
        const Divider(),
        // Table Rows
        ...data.entries.map((entry) {
          String itemName = entry.key;
          String quantity = entry.value['quantity'];
          String measure = entry.value['measureType'];
          double amount = entry.value['amount'];

          double totalAmount = double.parse(quantity) * amount;
          // Assume it returns total amount

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 2, child: Text(itemName)),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.onInverseSurface,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12)),
                            counterText: ''),
                        initialValue: quantity,
                        maxLength: 5,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (int.tryParse(value) != null) {
                            entry.value['quantity'] = value;
                            calculateTotal();
                          } else {
                            entry.value['quantity'] = '0';
                            calculateTotal();
                          }
                        },
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      '$amount/$measure',
                    )),
                Expanded(
                    flex: 2, child: Text('₹${totalAmount.toStringAsFixed(2)}')),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDelete(itemName);
                  },
                ),
              ],
            ),
          );
        }),
        const Divider(),
      ],
    );
  }
}

class AddItemPopup extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const AddItemPopup({super.key, required this.onSubmit});

  @override
  _AddItemPopupState createState() => _AddItemPopupState();
}

class _AddItemPopupState extends State<AddItemPopup> {
  // Repositories and controllers
  final SupabaseReqRepository repo = SupabaseReqRepository();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String selectedMeasurementType = 'kg';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assigning the form key to validate
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Item Name with Autocomplete
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Autocomplete<ScrapModel>(
                  displayStringForOption: (option) {
                    return option.name;
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<ScrapModel>.empty();
                    }
                    List<ScrapModel> availableItems = await repo
                        .getScrapRecommendations(textEditingValue.text);
                    return availableItems;
                  },
                  onSelected: (ScrapModel selection) {
                    setState(() {
                      itemController.text = selection.name;
                      selectedMeasurementType = selection.measure.name;
                      amountController.text = selection.price.toString();
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onChanged: (value) {
                        itemController.text = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an item name';
                        }
                        return null;
                      },
                    );
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              // Measurement Type Dropdown
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedMeasurementType,
                  items: ScrapMeasurement.values.map((type) {
                    return DropdownMenuItem(
                      value: type.name,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMeasurementType = value ?? 'kg';
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Measurement Type',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              // Price TextField
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // Form is valid, proceed with submission
              try {
                widget.onSubmit({
                  itemController.text: {
                    'quantity': quantityController.text,
                    'amount': double.parse(amountController.text),
                    'measureType': selectedMeasurementType,
                  }
                });
                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
