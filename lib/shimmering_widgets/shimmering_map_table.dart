import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringMapTableWidget extends StatelessWidget {
  const ShimmeringMapTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color baseColor =
        isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final Color highlightColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    final Color cellColor = isDark ? Colors.grey.shade900 : Colors.white;

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
            (_) => TableRow(
              children: [
                ShimmeringTableCell(color: cellColor),
                ShimmeringTableCell(color: cellColor),
                ShimmeringTableCell(color: cellColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmeringTableCell extends StatelessWidget {
  final Color color;
  const ShimmeringTableCell({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

