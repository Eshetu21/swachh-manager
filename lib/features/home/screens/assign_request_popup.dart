import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabadmanager/features/home/providers/home_page_controller.dart';
import 'package:kabadmanager/features/home/repositories/delivery_partners_repository.dart';
import 'package:kabadmanager/models/delivery_partner_model/delivery_partner_model.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';

class AssignPartnerPopup extends ConsumerStatefulWidget {
  const AssignPartnerPopup({required this.requestId, super.key});
  final String requestId;

  @override
  _AssignPartnerPopupState createState() => _AssignPartnerPopupState();
}

class _AssignPartnerPopupState extends ConsumerState<AssignPartnerPopup> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? userId;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign Request to Partner'),
      content: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Autocomplete<DeliveryPartnerModel>(
                  displayStringForOption: (option) => option.name,
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<DeliveryPartnerModel>.empty();
                    }
                    // Replace with your own repository call
                    List<DeliveryPartnerModel> availableItems =
                        await DeliveryPartnersRepository()
                            .searchPartnerByName(textEditingValue.text);
                    return availableItems;
                  },
                  onSelected: (DeliveryPartnerModel selection) {
                    userId = selection.id;
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted) {
                    // Use the same controller and focusNode to maintain focus
                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Partner Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {},
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (userId == null) {
              showSnackBar(context,
                  "Select a name of the delivery partner from dropdown");
            } else {
              try {
                ref.read(homePageControllerProvider.notifier).updateStatus(
                    id: widget.requestId,
                    newStatus: RequestStatus.accepted,
                    deliveryPartnerId: userId!);

                Navigator.of(context).pop();
              } catch (e) {
                showSnackBar(context, e.toString());
              }
            }
          },
          child: const Text('Assign'),
        ),
      ],
    );
  }
}
