import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/food_price_model.dart';

class FoodPriceSummaryDiagram extends StatelessWidget {
  final List<FoodPriceModel> data;

  const FoodPriceSummaryDiagram({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final summary = _calculateSummary(data);
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: Colors.green[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Ringkasan Data Harga Pangan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total',
                  '${data.length}',
                  Icons.inventory_2_outlined,
                  Colors.blue[600]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Naik',
                  '${summary['upCount']}',
                  Icons.trending_up,
                  Colors.green[600]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Turun',
                  '${summary['downCount']}',
                  Icons.trending_down,
                  Colors.red[600]!,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Price Range Chart
          _buildPriceRangeChart(context, summary),
          
          const SizedBox(height: 16),
          
          // Average Price Info
          _buildAveragePriceInfo(context, summary),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateSummary(List<FoodPriceModel> data) {
    int upCount = 0;
    int downCount = 0;
    int totalToday = 0;
    int totalYesterday = 0;
    int minPrice = data.isNotEmpty ? data.first.today : 0;
    int maxPrice = data.isNotEmpty ? data.first.today : 0;

    for (var item in data) {
      if (item.gapChange == 'up') {
        upCount++;
      } else if (item.gapChange == 'down') {
        downCount++;
      }
      
      totalToday += item.today;
      totalYesterday += item.yesterday;
      
      if (item.today < minPrice) minPrice = item.today;
      if (item.today > maxPrice) maxPrice = item.today;
    }

    return {
      'upCount': upCount,
      'downCount': downCount,
      'totalToday': totalToday,
      'totalYesterday': totalYesterday,
      'averageToday': data.isNotEmpty ? (totalToday / data.length).round() : 0,
      'averageYesterday': data.isNotEmpty ? (totalYesterday / data.length).round() : 0,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
    };
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeChart(BuildContext context, Map<String, dynamic> summary) {
    final minPrice = summary['minPrice'] as int;
    final maxPrice = summary['maxPrice'] as int;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rentang Harga',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        
        // Price Range Bar
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red[400]!,
                      Colors.orange[400]!,
                      Colors.green[400]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Price Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp ${_formatNumber(minPrice)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Rp ${_formatNumber(maxPrice)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAveragePriceInfo(BuildContext context, Map<String, dynamic> summary) {
    final avgToday = summary['averageToday'] as int;
    final avgYesterday = summary['averageYesterday'] as int;
    final avgGap = avgToday - avgYesterday;
    final isUp = avgGap > 0;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics_outlined,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rata-rata Harga',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Rp ${_formatNumber(avgToday)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isUp ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isUp ? Icons.arrow_upward : Icons.arrow_downward,
                            size: 12,
                            color: isUp ? Colors.green[700] : Colors.red[700],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Rp ${_formatNumber(avgGap.abs())}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isUp ? Colors.green[700] : Colors.red[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
