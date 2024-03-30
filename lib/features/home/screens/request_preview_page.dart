import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kabadmanager/core/extensions/string_extension.dart';
import 'package:kabadmanager/features/home/providers/home_page_controller.dart';
import 'package:kabadmanager/features/home/providers/preview_page_controller.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';
import 'package:kabadmanager/widgets/app_filled_button.dart';
import 'package:kabadmanager/widgets/cart_item_tile.dart';
import 'package:kabadmanager/widgets/map_table_widget.dart';
import 'package:kabadmanager/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestPreviewPage extends ConsumerStatefulWidget {
  const RequestPreviewPage(this.model, {super.key});

  final PickupRequestModel model;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RequestPreviewPageState();
}

class _RequestPreviewPageState extends ConsumerState<RequestPreviewPage> {
  @override
  void initState() {
    super.initState();
    ref
        .read(previewPageControllerProvider.notifier)
        .loadData(widget.model.id, widget.model.addressId ?? '');
  }

  final _phoneNotifier = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(previewPageControllerProvider);
    final controller = ref.read(previewPageControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const TitleLarge(text: 'Request Preview'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _phoneNotifier,
            builder: (BuildContext context, String? value, Widget? child) {
              if (value != null) {
                return ElevatedButton.icon(
                  label: const Text('Call'),
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    _launchUrl('tel://+${_phoneNotifier.value}', context);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: state.when(initial: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }, data: (cartModels, addressModel, details) {
        final addr = addressModel.toJson();
        _phoneNotifier.value = details.phone;
        addr.remove('latlng');
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleMedium(
                  text: ' Request Details',
                  weight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.onInverseSurface),
                  child: MapTableWidget(
                    data: {
                      'Request Id': widget.model.id,
                      'Request Date and Time': DateFormat.yMd()
                          .add_Hms()
                          .format(widget.model.requestDateTime.toLocal())
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const TitleMedium(
                  text: ' Cart Details',
                  weight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.onInverseSurface),
                    child: Column(children: [
                      Column(
                        children: [
                          ...List.generate(cartModels.length,
                              (index) => CartItemTile(model: cartModels[index]))
                        ],
                      )
                    ])),
                const SizedBox(
                  height: 20,
                ),
                const TitleMedium(
                  text: ' Quantity Details',
                  weight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.onInverseSurface),
                    child: TitleSmall(text: '${widget.model.qtyRange} Kg')),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                const TitleMedium(
                  text: ' Address Details',
                  weight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.onInverseSurface),
                    child: MapTableWidget(
                      data: {
                        'Address': addressModel.address.capitalize,
                        'House No.': addressModel.houseStreetNo.capitalize,
                        'Apartment/Road/Landmark':
                            addressModel.apartmentRoadAreadLandmark?.capitalize,
                        'Phone Number': addressModel.phoneNumber?.capitalize,
                        'Category': addressModel.category.name.capitalize,
                      },
                    )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.all(10),
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _launchUrl(
                                  _constructGoogleMapsUrl(
                                      addressModel.latlng.lat,
                                      addressModel.latlng.lng),
                                  context);
                            },
                            label: const Text('Open In Maps'),
                            icon: const Icon(Icons.map_outlined)),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.all(10),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: _constructGoogleMapsUrl(
                                    addressModel.latlng.lat,
                                    addressModel.latlng.lng)));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Copied "${_constructGoogleMapsUrl(addressModel.latlng.lat, addressModel.latlng.lng)}"')),
                            );
                          },
                          label: const Text('Copy'),
                          icon: const Icon(Icons.copy),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const TitleMedium(
                  text: ' Contact Details',
                  weight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.onInverseSurface),
                  child: MapTableWidget(data: {
                    'Name': '${details.name}',
                    'Phone Number': '${details.phone?.substring(2)}',
                    'Email Id': '${details.email}'
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (RequestStatus.accepted == widget.model.status) ...[
                  AppFilledButton(
                    asyncTap: () async {
                      ref
                          .read(homePageControllerProvider.notifier)
                          .updateStatus(
                              id: widget.model.id,
                              newStatus: RequestStatus.onTheWay);
                    },
                    label: 'Mark As On The Way',
                  ),
                ]
              ],
            ),
          ),
        );
      }),
    );
  }
}

String _constructGoogleMapsUrl(double latitude, double longitude) {
  return 'https://www.google.com/maps?q=$latitude,$longitude';
}

void _launchUrl(String url, context) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    launchUrl(Uri.parse(url));
  } else {
    showSnackBar(context, 'Can not open !');
    throw 'Could not launch $url';
  }
}
