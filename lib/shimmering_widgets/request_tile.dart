import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringPickRequestTile extends StatelessWidget {
  const ShimmeringPickRequestTile({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.grey.shade300;
    final Color highlightColor = Colors.grey.shade100;

    return Card(
      color: Colors.grey.shade100,
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
              _shimmerLine(width: 100),
              const SizedBox(height: 8),
              _shimmerLine(),
              const SizedBox(height: 8),
              _shimmerLine(width: 80),
              const SizedBox(height: 12),
              _shimmerBlock(width: 100, height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerLine({double width = double.infinity}) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _shimmerBlock({double width = 100, double height = 20}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

