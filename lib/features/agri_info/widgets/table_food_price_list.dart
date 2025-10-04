import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/table_food_price_model.dart';
import 'package:intl/intl.dart';

class TableFoodPriceList extends StatelessWidget {
  final List<TableFoodPriceModel> data;
  final TableFoodPriceResponse? responseData;

  const TableFoodPriceList({
    super.key,
    required this.data,
    this.responseData,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Harga Pangan Antar Waktu',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        const SizedBox(height: 16),

        // Summary Info
        if (responseData != null) _buildSummaryInfo(context),

        const SizedBox(height: 20),

        // Data List
        ...data.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TableFoodPriceCard(item: item),
          );
        }).toList(),

        // Detail Keterangan
        if (responseData?.detailKeterangan.keterangan.isNotEmpty == true)
          _buildDetailKeterangan(context),
      ],
    );
  }

  Widget _buildSummaryInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final requestData = responseData!.requestData;

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
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Informasi Periode',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Periode', requestData.periodDate),
          _buildInfoRow('Jenis Data', requestData.levelHargaDesc),
          _buildInfoRow('Tanggal Mulai', requestData.startDate),
          _buildInfoRow('Tanggal Akhir', requestData.endDate),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailKeterangan(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final keterangan = responseData!.detailKeterangan.keterangan;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: Colors.blue[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Keterangan',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...keterangan.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '• $item',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}

class TableFoodPriceCard extends StatelessWidget {
  final TableFoodPriceModel item;

  const TableFoodPriceCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final result = item.result.isNotEmpty ? item.result.first : null;

    if (result == null) return const SizedBox.shrink();

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
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
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
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Harga Hari Ini: ${_formatCurrency(result.today)}',
                      style: textTheme.bodyMedium?.copyWith(
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

          // Price Comparison Table
          _buildPriceComparisonTable(context, result),

          const SizedBox(height: 12),

          // Province Price Info
          if (result.todayProvincePrice.hargatertinggi > 0)
            _buildProvincePriceInfo(context, result.todayProvincePrice),
        ],
      ),
    );
  }

  Widget _buildPriceComparisonTable(BuildContext context, TableResult result) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Periode',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
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
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Perubahan',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Rows
          _buildTableRow('Hari Ini', result.today, null, null, Colors.green[600]!),
          if (result.yesterday > 0)
            _buildTableRow('Kemarin', result.yesterday, result.yesterdayPercentage, result.yesterdayPercentageGapChange, _getColorFromGap(result.yesterdayColorGap)),
          if (result.lastWeek > 0)
            _buildTableRow('Minggu Lalu', result.lastWeek, result.lastWeekPercentage, result.lastWeekPercentageGapChange, _getColorFromGap(result.lastWeekColorGap)),
          if (result.lastMonth > 0)
            _buildTableRow('Bulan Lalu', result.lastMonth, result.lastMonthPercentage, result.lastMonthPercentageGapChange, _getColorFromGap(result.lastMonthColorGap)),
          if (result.lastYear > 0)
            _buildTableRow('Tahun Lalu', result.lastYear, result.lastYearPercentage, result.lastYearPercentageGapChange, _getColorFromGap(result.lastYearColorGap)),
        ],
      ),
    );
  }

  Widget _buildTableRow(String period, int price, double? percentage, String? gapChange, Color color) {
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
              period,
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
            child: _buildPercentageWidget(percentage, gapChange, color),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageWidget(double? percentage, String? gapChange, Color color) {
    if (percentage == null || gapChange == null || gapChange == '-') {
      return const Text(
        '-',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          gapChange == 'up' ? Icons.trending_up : Icons.trending_down,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 2),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProvincePriceInfo(BuildContext context, TodayProvincePriceTable provincePrice) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.blue[600],
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Harga Provinsi',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildProvincePriceItem(
                  'Tertinggi',
                  _formatCurrency(provincePrice.hargatertinggi),
                  provincePrice.provinsitertinggi,
                  Colors.red[600]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProvincePriceItem(
                  'Terendah',
                  _formatCurrency(provincePrice.hargaterendah),
                  provincePrice.provinsiterendah,
                  Colors.green[600]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProvincePriceItem(String label, String price, String province, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          price,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          province,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _getColorFromGap(String gapColor) {
    switch (gapColor) {
      case 'green':
        return Colors.green[600]!;
      case 'red':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }
}
