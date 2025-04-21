import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringPickRequestTile extends StatelessWidget {
  const ShimmeringPickRequestTile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color baseColor =
        isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final Color highlightColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    final Color blockColor = isDark ? Colors.grey.shade900 : Colors.white;

    return Card(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerLine(blockColor, width: 100),
              const SizedBox(height: 8),
              _shimmerLine(blockColor),
              const SizedBox(height: 8),
              _shimmerLine(blockColor, width: 80),
              const SizedBox(height: 12),
              _shimmerBlock(blockColor, width: 100, height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerLine(Color color, {double width = double.infinity}) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _shimmerBlock(Color color, {double width = 100, double height = 20}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

