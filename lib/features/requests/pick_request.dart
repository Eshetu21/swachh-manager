import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kabadmanager/models/address.dart';
import 'package:kabadmanager/models/cart.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:kabadmanager/models/scrap.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';

class PickOrderPage extends StatefulWidget {
  const PickOrderPage({
    super.key,
    required this.address,
    required this.cartItems,
    required this.request,
  });

  final Request request;
  final Address address;
  final List<Cart> cartItems;

  @override
  State<PickOrderPage> createState() => _PickOrderPageState();
}

class _PickOrderPageState extends State<PickOrderPage> {
  final _supabaseService = SupabaseRpcService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _totalPriceController = TextEditingController();
  final List<String> _paymentModes = ['Cash', 'UPI'];
  String _selectedPaymentMode = 'Cash';
  double _totalPrice = 0.0;
  final Map<String, Map<String, dynamic>> _orderItems = {};
  List<Cart> _allCartItems = [];
  bool _isCreatingTransaction = false;

  @override
  void initState() {
    super.initState();
    _allCartItems = widget.cartItems;
    _initializeOrderItems();
  }

  void _initializeOrderItems() {
    for (var item in widget.cartItems) {
      _orderItems[item.scrap.name] = {
        'quantity': item.qty.toString(),
        'amount': item.scrap.price,
        'measureType': item.scrap.measure.name,
      };
    }
    _calculateTotal();
  }

  Future<void> _deleteItem(String itemName, String? cartId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        if (cartId != null) {
          await _supabaseService.deleteCartItem(cartId);
        }

        setState(() {
          _orderItems.remove(itemName);
          _calculateTotal();
        });

        if (mounted) {
          ShowSnackbar.show(context, "Item deleted successfully");
        }
      } catch (e) {
        if (mounted) {
          ShowSnackbar.show(context, 'Failed to delete item: ${e.toString()}',
              isError: true);
        }
      }
    }
  }

  void _calculateTotal() {
    _totalPrice = _orderItems.entries.fold(0.0, (sum, entry) {
      final quantity = double.tryParse(entry.value['quantity'].toString()) ?? 0;
      final amount = entry.value['amount'] as double;
      return sum + (quantity * amount);
    });
    _totalPriceController.text = _totalPrice.toStringAsFixed(2);
  }

  Future<void> _createTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_orderItems.isEmpty) {
      ShowSnackbar.show(context, 'Please add at least one item');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Transaction'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Payment Mode: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_selectedPaymentMode),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Items:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ..._orderItems.entries.map((entry) {
                final itemName = entry.key;
                final data = entry.value;
                final total =
                    (double.tryParse(data['quantity'].toString()) ?? 0) *
                        (data['amount'] as double);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(itemName, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        child:
                            Text('${data['quantity']} ${data['measureType']}'),
                      ),
                      Expanded(
                        child: Text('₹${total.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 24),
              Row(
                children: [
                  const Text('Total Amount: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('₹${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Are you sure you want to proceed?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isCreatingTransaction = true;
    });

    try {
      await _supabaseService.createTransaction(
        requestId: widget.request.id,
        addressId: widget.address.id,
        orderQuantity: _orderItems,
        photograph: null,
        ownerId: widget.request.requestingUserId,
        paidAmount: _totalPrice,
      );

      await _supabaseService.updateRequestStatus(
          widget.request.id, RequestStatus.picked);

      if (mounted) {
        ShowSnackbar.show(context, 'Transaction created successfully');
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ShowSnackbar.show(
            context, 'Failed to create transaction: ${e.toString()}',isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingTransaction = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(_calculateTotal),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedPaymentMode,
                decoration: InputDecoration(
                  labelText: 'Payment Mode',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _paymentModes.map((mode) {
                  return DropdownMenuItem(
                    value: mode,
                    child: Text(mode),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedPaymentMode = value!),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text('Item',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                child: Text('Qty',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                child: Text('Price',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                child: Text('Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            SizedBox(width: 40),
                          ],
                        ),
                        const Divider(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _orderItems.length,
                            itemBuilder: (context, index) {
                              final entry =
                                  _orderItems.entries.elementAt(index);
                              final itemName = entry.key;
                              final data = entry.value;
                              final total = (double.tryParse(
                                          data['quantity'].toString()) ??
                                      0) *
                                  (data['amount'] as double);
                              final cartId = _allCartItems[index].id;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(itemName,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue:
                                            data['quantity'].toString(),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          hintText: '0',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                        ),
                                        onChanged: (value) {
                                          final qty = int.tryParse(value) ?? 0;
                                          _orderItems[itemName]?['quantity'] =
                                              qty.toString();
                                          _calculateTotal();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '₹${data['amount'].toStringAsFixed(2)}/${data['measureType']}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '₹${total.toStringAsFixed(2)}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async {
                                        await _deleteItem(itemName, cartId);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _totalPriceController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Total Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.currency_rupee),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: _totalPriceController.text));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Item'),
                      onPressed: () => _showAddItemDialog(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: _isCreatingTransaction
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.check_circle),
                      label: _isCreatingTransaction
                          ? const Text('Processing...')
                          : const Text('Create transaction'),
                      onPressed:
                          _isCreatingTransaction ? null : _createTransaction,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddItemDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );

    if (result != null && result.isNotEmpty) {
      final orderItem =
          result['orderItem'] as Map<String, Map<String, dynamic>>;
      final scrap = result['scrap'] as ScrapModel;
      final quantity =
          int.tryParse(orderItem.values.first['quantity'] ?? '0') ?? 0;

      try {
        final newCartItemId = await _supabaseService.insertCartItem(
          scrapId: scrap.id,
          qty: quantity,
          requestId: widget.request.id,
        );
        final newCartItem =
            Cart(id: newCartItemId, scrap: scrap, qty: quantity);
        setState(() {
          _allCartItems.add(newCartItem);
          _orderItems.addAll(orderItem);
          _calculateTotal();
        });

        if (mounted) {
          ShowSnackbar.show(context, 'Item added successfully');
        }
      } catch (e) {
        if (mounted) {
          ShowSnackbar.show(context, 'Failed to add item: ${e.toString()}',
              isError: true);
        }
      }
    }
  }
}

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _supabaseService = SupabaseRpcService();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedMeasureType = 'kg';
  List<ScrapModel> _scrapSuggestions = [];
  ScrapModel? _selectedScrap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Autocomplete<ScrapModel>(
                displayStringForOption: (option) => option.name,
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<ScrapModel>.empty();
                  }
                  try {
                    setState(() {});
                    _scrapSuggestions = await _supabaseService
                        .getScrapRecommendations(textEditingValue.text);
                    return _scrapSuggestions;
                  } finally {
                    setState(() {});
                  }
                },
                onSelected: (ScrapModel selection) {
                  _selectedScrap = selection;
                  _itemController.text = selection.name;
                  _priceController.text = selection.price.toString();
                  _selectedMeasureType = selection.measure.name;
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller
                      ..addListener(
                          () => _itemController.text = controller.text),
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per unit',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  return double.tryParse(value!) == null
                      ? 'Invalid number'
                      : null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedMeasureType,
                items: const [
                  DropdownMenuItem(value: 'kg', child: Text('kg')),
                  DropdownMenuItem(value: 'unit', child: Text('unit')),
                  DropdownMenuItem(value: 'piece', child: Text('piece')),
                ],
                onChanged: (value) =>
                    setState(() => _selectedMeasureType = value!),
                decoration: const InputDecoration(
                  labelText: 'Measurement',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  return int.tryParse(value!) == null ? 'Invalid number' : null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final result = {
                'orderItem': {
                  _itemController.text: {
                    'quantity': _quantityController.text,
                    'amount': double.parse(_priceController.text),
                    'measureType': _selectedMeasureType,
                  }
                },
                'scrap': _selectedScrap,
              };
              Navigator.pop(context, result);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

