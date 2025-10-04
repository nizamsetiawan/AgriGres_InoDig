import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProvinceFoodPriceShimmer extends StatelessWidget {
  const ProvinceFoodPriceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Grand Total Section Shimmer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(6, (index) => _buildShimmerChip()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Province Cards Shimmer
          ...List.generate(3, (index) => _buildShimmerCard()),
        ],
      ),
    );
  }

  Widget _buildShimmerChip() {
    return Container(
      width: 120,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Province Header
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 16,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 80,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Commodities List
            ...List.generate(3, (index) => _buildShimmerCommodityItem()),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCommodityItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Commodity Name and Price
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 14,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 80,
                height: 14,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Province Price Info
          Container(
            height: 12,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 10,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Setting Harga Info
          Container(
            height: 12,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 40,
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}









