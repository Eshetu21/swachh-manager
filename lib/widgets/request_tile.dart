import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kabadmanager/core/extensions/object_extension.dart';
import 'package:kabadmanager/core/extensions/string_extension.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:kabadmanager/widgets/request_status_widget.dart';
import 'package:kabadmanager/widgets/text_widgets.dart';

class PickRequestTile extends ConsumerWidget {
  const PickRequestTile(
      {super.key, this.onLongTap, required this.onTap, required this.model});

  final PickupRequestModel model;
  final VoidCallback? onLongTap;
  final void Function(PickupRequestModel model) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      isThreeLine: true,
      onLongPress: onLongTap,
      onTap: () => onTap.call(model),
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleSmall(
          text: DateFormat.yMMMd().format(model.requestDateTime.toLocal()),
        ),
        const SizedBox(height: 5),
        if (model.address.isNotNull) ...[
          LabelMedium(text: model.address!.address.capitalize)
        ]
      ]),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelLarge(
              text: "Quantity ${model.qtyRange} >",
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.6),
            ),
            if (model.pickedDateTime != null) ...[
              const SizedBox(height: 5), // Add some spacing
              Container(
                padding:
                    const EdgeInsets.all(2.0), // Padding inside the container
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.2), // Background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Text(
                  DateFormat.yMd()
                      .add_Hms()
                      .format(model.pickedDateTime!.toLocal()),
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RequestStatusWidget(model.status),
          Text(DateFormat.yMd()
              .add_Hms()
              .format(model.requestDateTime.toLocal())),
        ],
      ),
    );
  }
}
