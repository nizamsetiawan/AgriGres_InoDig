import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/models/sawah_model.dart';
import 'package:agrigres/features/agri_info/controllers/sawah_controller.dart';

class SawahDataList extends StatelessWidget {
  final SawahModel data;

  const SawahDataList({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SawahController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with summary
        _buildHeader(context),
        const SizedBox(height: 16),
        
        // Data List
        Obx(() {
          final filteredRecords = controller.filteredRecords;
          
          if (filteredRecords.isEmpty) {
            return _buildNoDataState();
          }
          
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredRecords.length,
            itemBuilder: (context, index) {
              final record = filteredRecords[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SawahDataCard(record: record),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Luas Sawah',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: ${data.result.total} desa/kelurahan',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Tidak ada data yang sesuai',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class SawahDataCard extends StatelessWidget {
  final SawahRecord record;

  const SawahDataCard({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final totalArea = record.totalArea;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
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
              color: Colors.green[50],
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
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.agriculture,
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
                        record.desaKelurahan,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        record.kecamatan,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${totalArea.toStringAsFixed(1)} Ha',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Data Table
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Luas Sawah',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Sawah items
                _buildSawahItem('Sawah Tadah Hujan', record.sawahTadahHujan, Colors.blue[600]!),
                _buildSawahItem('Sawah Irigasi', record.sawahIrigasi, Colors.cyan[600]!),
                _buildSawahItem('Sawah Rawa Pasang Surut Tidal', record.sawahRawaPasangSurutTidal, Colors.teal[600]!),
                _buildSawahItem('Sawah Rawa Lebak', record.sawahRawaLebak, Colors.green[600]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSawahItem(String label, String value, Color color) {
    final double area = _parseDouble(value);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            '${area.toStringAsFixed(1)} Ha',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: area > 0 ? color : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  double _parseDouble(String value) {
    try {
      return double.parse(value.replaceAll(',', '.'));
    } catch (e) {
      return 0.0;
    }
  }
}
