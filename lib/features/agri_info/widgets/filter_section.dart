import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/controllers/detail_agri_info_controller.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailAgriInfoController>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Jenis Data Panel
        _buildFilterItem(
          context,
          'Jenis Data panel',
          Obx(() => Text(
            controller.selectedLevelHargaName,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[800],
            ),
          )),
          onTap: () => _showLevelHargaPicker(context, controller),
        ),
        
        const SizedBox(height: 16),
        
        // Peta Wilayah (Disabled)
        _buildFilterItem(
          context,
          'Peta Wilayah',
          Text(
            'Nasional',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          isEnabled: false,
        ),
        
        const SizedBox(height: 16),
        
        // Kab/Kota (Disabled)
        _buildFilterItem(
          context,
          'Kab/Kota',
          Text(
            'Pilih Kab/kota',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          isEnabled: false,
        ),
        
        const SizedBox(height: 16),
        
        // Date Range (Disabled)
        Row(
          children: [
            // Tanggal Awal (Disabled)
            Expanded(
              child: _buildDisabledDateFilter(
                context,
                'Tanggal Awal',
                controller.startDate.value,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Tanggal Akhir (Disabled)
            Expanded(
              child: _buildDisabledDateFilter(
                context,
                'Tanggal Akhir',
                controller.endDate.value,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterItem(
    BuildContext context,
    String label,
    Widget content,
    {bool isEnabled = true, VoidCallback? onTap}
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.green[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: isEnabled ? onTap : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isEnabled ? Colors.grey[300]! : Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(child: content),
                if (isEnabled && onTap != null)
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[600],
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisabledDateFilter(
    BuildContext context,
    String label,
    DateTime selectedDate,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.green[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _formatDate(selectedDate),
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ),
              Icon(
                Icons.calendar_today,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLevelHargaPicker(BuildContext context, DetailAgriInfoController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Pilih Jenis Data Panel',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // Options
            Obx(() => Column(
              children: controller.levelHargaOptions.map((option) {
                return ListTile(
                  title: Text(option['name']),
                  leading: Radio<int>(
                    value: option['id'],
                    groupValue: controller.selectedLevelHargaId.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectLevelHarga(value);
                        Navigator.pop(context);
                      }
                    },
                    activeColor: Colors.green[700],
                  ),
                );
              }).toList(),
            )),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
