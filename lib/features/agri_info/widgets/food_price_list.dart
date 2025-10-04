import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/food_price_model.dart';
import 'package:agrigres/features/agri_info/widgets/food_price_summary_diagram.dart';

class FoodPriceList extends StatelessWidget {
  final List<FoodPriceModel> data;

  const FoodPriceList({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Data Harga Pangan',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Summary Diagram
        FoodPriceSummaryDiagram(data: data),
        
        const SizedBox(height: 20),
        
        // Data List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FoodPriceCard(item: item),
            );
          },
        ),
      ],
    );
  }
}

class FoodPriceCard extends StatelessWidget {
  final FoodPriceModel item;

  const FoodPriceCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Commodity Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.background,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                    size: 24,
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Commodity Name
                Text(
                  item.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Price Info
                Row(
                  children: [
                    // Today Price
                    Expanded(
                      child: _buildPriceInfo(
                        'Hari Ini',
                        'Rp ${_formatNumber(item.today)}',
                        Colors.grey[600]!,
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Yesterday Price
                    Expanded(
                      child: _buildPriceInfo(
                        'Kemarin',
                        'Rp ${_formatNumber(item.yesterday)}',
                        Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Gap Info
                _buildGapInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildGapInfo() {
    final isUp = item.gapChange == 'up';
    final gapColor = isUp ? Colors.green[600]! : Colors.red[600]!;
    final gapIcon = isUp ? Icons.arrow_upward : Icons.arrow_downward;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: gapColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gapIcon,
            size: 12,
            color: gapColor,
          ),
          const SizedBox(width: 4),
          Text(
            '${isUp ? '+' : ''}${_formatNumber(item.gap)} (${item.gapPercentage.toStringAsFixed(2)}%)',
            style: TextStyle(
              fontSize: 11,
              color: gapColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
