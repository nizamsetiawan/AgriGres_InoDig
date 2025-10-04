import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/monthly_food_price_model.dart';
import 'package:agrigres/features/agri_info/widgets/monthly_food_price_summary_diagram.dart';

class MonthlyFoodPriceList extends StatelessWidget {
  final Map<String, List<MonthlyFoodPriceModel>> data;

  const MonthlyFoodPriceList({
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
          'Data Harga Pangan Bulanan',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Summary Diagram
        MonthlyFoodPriceSummaryDiagram(data: data),
        
        const SizedBox(height: 20),
        
        // Data by Year
        ...data.keys.map((year) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Year Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[50]!, Colors.green[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.green[700],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tahun $year',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                    Text(
                      '${data[year]!.length} Komoditas',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Commodities for this year
              ...data[year]!.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MonthlyFoodPriceCard(item: item),
                );
              }).toList(),
              
              const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ],
    );
  }
}

class MonthlyFoodPriceCard extends StatelessWidget {
  final MonthlyFoodPriceModel item;

  const MonthlyFoodPriceCard({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image and name
          Row(
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
              
              // Commodity Name and Current Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.komoditas,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    if (item.todayProvincePrice.hargaratarata != null)
                      Text(
                        'Harga Rata-rata: Rp ${_formatNumber(item.todayProvincePrice.hargaratarata!)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Monthly Price Chart
          _buildMonthlyChart(),
          
          const SizedBox(height: 12),
          
          // Price Range Info
          if (item.todayProvincePrice.hargatertinggi != null && 
              item.todayProvincePrice.hargaterendah != null)
            _buildPriceRangeInfo(),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final prices = months.map((month) => item.monthlyPrices[month]).toList();
    
    // Filter out null values and get min/max for scaling
    final validPrices = prices.where((price) => price != null).cast<int>().toList();
    if (validPrices.isEmpty) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Tidak ada data harga bulanan',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    
    final minPrice = validPrices.reduce((a, b) => a < b ? a : b);
    final maxPrice = validPrices.reduce((a, b) => a > b ? a : b);
    final range = maxPrice - minPrice;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trend Harga Bulanan',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        
        // Chart - Fixed overflow issue
        Container(
          height: 70,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: months.asMap().entries.map((entry) {
                final index = entry.key;
                final month = entry.value;
                final price = prices[index];
                
                if (price == null) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      width: 18,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }
                
                final height = range > 0 ? ((price - minPrice) / range * 50) + 10 : 30.0;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          month,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 18,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeInfo() {
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
            Icons.info_outline,
            color: Colors.grey[600],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Range: Rp ${_formatNumber(item.todayProvincePrice.hargaterendah!)} - Rp ${_formatNumber(item.todayProvincePrice.hargatertinggi!)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
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