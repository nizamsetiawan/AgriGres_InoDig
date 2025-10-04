import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/province_food_price_model.dart';
import 'package:intl/intl.dart';

class ProvinceFoodPriceList extends StatefulWidget {
  final List<ProvinceFoodPriceModel> data;
  final List<GrandTotalModel> grandTotalData;

  const ProvinceFoodPriceList({
    super.key,
    required this.data,
    required this.grandTotalData,
  });

  @override
  State<ProvinceFoodPriceList> createState() => _ProvinceFoodPriceListState();
}

class _ProvinceFoodPriceListState extends State<ProvinceFoodPriceList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Harga Pangan Antar Wilayah',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        
        // Grand Total Summary
        if (widget.grandTotalData.isNotEmpty) _buildGrandTotalSection(context),
        
        const SizedBox(height: 16),
        
        // Province Data
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            final item = widget.data[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProvinceFoodPriceCard(item: item),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGrandTotalSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayCount = _isExpanded ? widget.grandTotalData.length : 6;
    final hasMore = widget.grandTotalData.length > 6;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.green[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.green[700],
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Rata-rata Nasional',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.grandTotalData.take(displayCount).map((item) => _buildGrandTotalChip(context, item)).toList(),
          ),
          if (hasMore) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded 
                        ? 'Tampilkan lebih sedikit' 
                        : 'dan ${widget.grandTotalData.length - 6} komoditas lainnya',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.green[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.green[600],
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGrandTotalChip(BuildContext context, GrandTotalModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.green[300]!,
          width: 0.5,
        ),
      ),
      child: Text(
        '${item.komoditas}: Rp ${_formatNumber(item.rataRata)}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.green[800],
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(number);
  }
}

class ProvinceFoodPriceCard extends StatelessWidget {
  final ProvinceFoodPriceModel item;

  const ProvinceFoodPriceCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          // Province Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.province,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item.komoditas.length} komoditas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Commodities List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: item.komoditas.map((commodity) => 
                _buildCommodityItem(commodity, context)
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommodityItem(ProvinceCommodity commodity, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                      commodity.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Harga Rata-rata: ${_formatCurrency(commodity.rataRata)}',
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

          // Today Province Price Info
          _buildTodayPriceInfo(commodity.todayProvincePrice),
          
          // Setting Harga Info
          if (commodity.settingHarga.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSettingHargaInfo(commodity.settingHarga.first),
          ],
        ],
      ),
    );
  }

  Widget _buildTodayPriceInfo(TodayProvincePriceProvince provincePrice) {
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPriceItem(
                  'Tertinggi',
                  _formatCurrency(provincePrice.hargatertinggi),
                  provincePrice.provinsitertinggi,
                  Colors.red[600]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPriceItem(
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

  Widget _buildSettingHargaInfo(SettingHargaProvince setting) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.orange[600],
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Keterangan Harga',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Tipe', setting.typeDescription),
          const SizedBox(height: 4),
          _buildInfoRow('Range', setting.hargaRangeProvinsi),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String label, String price, String province, Color color) {
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }
}

