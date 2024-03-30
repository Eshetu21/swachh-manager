import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';

class RequestStatusWidget extends ConsumerWidget {
  final RequestStatus status;

  const RequestStatusWidget(this.status, {super.key});

  Color _getContainerColor(context) {
    return switch (status) {
      RequestStatus.picked => Colors.greenAccent,
      RequestStatus.denied => Theme.of(context).colorScheme.error,
      RequestStatus.requested => Theme.of(context).colorScheme.tertiary,
      RequestStatus.accepted => Colors.blueAccent,
      RequestStatus.onTheWay => Theme.of(context).colorScheme.inversePrimary,
    };
  }

  Color _getTexrColor(context) {
    return switch (status) {
      RequestStatus.picked => Colors.black,
      RequestStatus.denied => Theme.of(context).colorScheme.onError,
      RequestStatus.requested => Theme.of(context).colorScheme.onTertiary,
      RequestStatus.accepted => Theme.of(context).colorScheme.onPrimary,
      RequestStatus.onTheWay => Theme.of(context).colorScheme.onTertiary,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: _getContainerColor(context),
          borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: _getTexrColor(context)),
      ),
    );
  }
}
