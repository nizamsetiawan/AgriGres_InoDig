import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/rekapitulasi_model.dart';
import 'package:intl/intl.dart';

class RekapitulasiDataList extends StatelessWidget {
  final List<RekapitulasiData> data;

  const RekapitulasiDataList({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Rekapitulasi Harga Pangan',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        
        // Data List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RekapitulasiDataCard(item: item),
            );
          },
        ),
      ],
    );
  }
}

class RekapitulasiDataCard extends StatelessWidget {
  final RekapitulasiData item;

  const RekapitulasiDataCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    // Filter out dates with 0 values for better visualization
    final validDates = item.byDate.where((date) => date.rataRata > 0).toList();
    final hasData = validDates.isNotEmpty;

    return Container(
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: hasData ? Colors.green[50] : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: hasData ? Colors.green[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    hasData ? Icons.analytics_outlined : Icons.analytics_outlined,
                    color: hasData ? Colors.green[600] : Colors.grey[400],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: hasData ? Colors.green[800] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasData 
                            ? '${validDates.length} data tersedia'
                            : 'Tidak ada data',
                        style: textTheme.bodyMedium?.copyWith(
                          color: hasData ? Colors.green[600] : Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasData)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Data Table
          if (hasData) _buildDataTable(context, validDates),
          
          // No Data State
          if (!hasData) _buildNoDataState(context),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, List<ByDate> validDates) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perkembangan Harga',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tanggal',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Harga',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Perubahan',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Table Rows
          ...validDates.asMap().entries.map((entry) {
            final index = entry.key;
            final dateData = entry.value;
            final previousPrice = index > 0 ? validDates[index - 1].rataRata : null;
            final change = previousPrice != null ? dateData.rataRata - previousPrice : null;
            
            return _buildTableRow(
              context,
              dateData.date,
              dateData.rataRata,
              change,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, String date, int price, int? change) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(date),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _formatCurrency(price),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: _buildChangeWidget(change),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeWidget(int? change) {
    if (change == null || change == 0) {
      return const Text(
        '-',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      );
    }

    final isPositive = change > 0;
    final color = isPositive ? Colors.red[600]! : Colors.green[600]!;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 2),
        Text(
          _formatCurrency(change.abs()),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildNoDataState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Tidak ada data untuk periode ini',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final day = parts[0];
        final month = parts[1];
        final year = parts[2];
        return '$day/$month/$year';
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }
}
