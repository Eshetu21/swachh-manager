import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringMapTableWidget extends StatelessWidget {
  const ShimmeringMapTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.grey.shade300;
    final Color highlightColor = Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(12),
          ),
          columnWidths: const {
            0: FractionColumnWidth(0.4),
            1: FractionColumnWidth(0.3),
            2: FractionColumnWidth(0.3),
          },
          children: List.generate(
            5,
            (_) => const TableRow(
              children: [
                ShimmeringTableCell(),
                ShimmeringTableCell(),
                ShimmeringTableCell(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmeringTableCell extends StatelessWidget {
  const ShimmeringTableCell({super.key});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
