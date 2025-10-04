import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/monthly_food_price_model.dart';

class MonthlyFoodPriceSummaryDiagram extends StatelessWidget {
  final Map<String, List<MonthlyFoodPriceModel>> data;

  const MonthlyFoodPriceSummaryDiagram({
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
              Expanded(
                child: Text(
                  'Ringkasan Data Harga Pangan Bulanan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
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
                  '${summary['totalCommodities']}',
                  Icons.inventory_2_outlined,
                  Colors.blue[600]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Tahun',
                  '${summary['totalYears']}',
                  Icons.calendar_month,
                  Colors.orange[600]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Data Point',
                  '${summary['totalDataPoints']}',
                  Icons.data_usage,
                  Colors.purple[600]!,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Year Distribution Chart
          _buildYearDistributionChart(context, summary),
          
          const SizedBox(height: 16),
          
          // Average Price Info
          _buildAveragePriceInfo(context, summary),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateSummary(Map<String, List<MonthlyFoodPriceModel>> data) {
    int totalCommodities = 0;
    int totalDataPoints = 0;
    int totalYears = data.keys.length;
    int totalPrices = 0;
    int priceCount = 0;

    data.forEach((year, commodities) {
      totalCommodities += commodities.length;
      
      commodities.forEach((commodity) {
        commodity.monthlyPrices.values.forEach((price) {
          if (price != null) {
            totalDataPoints++;
            totalPrices += price;
            priceCount++;
          }
        });
      });
    });

    return {
      'totalCommodities': totalCommodities,
      'totalYears': totalYears,
      'totalDataPoints': totalDataPoints,
      'averagePrice': priceCount > 0 ? (totalPrices / priceCount).round() : 0,
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

  Widget _buildYearDistributionChart(BuildContext context, Map<String, dynamic> summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distribusi Data per Tahun',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        
        // Year bars
        ...data.keys.map((year) {
          final commodityCount = data[year]!.length;
          final maxCommodities = data.values.map((list) => list.length).reduce((a, b) => a > b ? a : b);
          final percentage = maxCommodities > 0 ? commodityCount / maxCommodities : 0.0;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    year,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percentage,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[400]!, Colors.green[600]!],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$commodityCount',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAveragePriceInfo(BuildContext context, Map<String, dynamic> summary) {
    final avgPrice = summary['averagePrice'] as int;
    
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
                  'Rata-rata Harga Keseluruhan',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${_formatNumber(avgPrice)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
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
