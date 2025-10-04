import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/controllers/province_detail_agri_info_controller.dart';

class ProvinceFilterSection extends StatelessWidget {
  const ProvinceFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProvinceDetailAgriInfoController>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Jenis Data Panel
        Obx(() => _buildFilterItem(
          context,
          'Jenis Data panel',
          Text(
            controller.selectedLevelHargaName,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[800],
            ),
          ),
          onTap: () => _showLevelHargaPicker(context, controller),
        )),

        const SizedBox(height: 16),

        // Periode Date Range
        Row(
          children: [
            // Tanggal Awal
            Expanded(
              child: Obx(() => _buildDateFilter(
                context,
                'Tanggal Awal',
                controller.startDate.value,
                (date) => controller.setStartDate(date),
              )),
            ),

            const SizedBox(width: 12),

            // Tanggal Akhir
            Expanded(
              child: Obx(() => _buildDateFilter(
                context,
                'Tanggal Akhir',
                controller.endDate.value,
                (date) => controller.setEndDate(date),
              )),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Peta Wilayah (Disabled)
        _buildFilterItem(
          context,
          'Peta Wilayah',
          Text(
            'Jawa Timur',
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
            'Kab. Gresik',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          isEnabled: false,
        ),
      ],
    );
  }

  Widget _buildFilterItem(
    BuildContext context,
    String label,
    Widget valueWidget, {
    VoidCallback? onTap,
    bool isEnabled = true,
  }) {
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
                Expanded(child: valueWidget),
                if (isEnabled)
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilter(
    BuildContext context,
    String label,
    DateTime selectedDate,
    Function(DateTime) onDateSelected,
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
          onTap: () => _selectDate(context, selectedDate, onDateSelected),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(selectedDate),
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLevelHargaPicker(BuildContext context, ProvinceDetailAgriInfoController controller) {
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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Pilih Jenis Data',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
              ),
            ),
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
                        Get.back();
                      }
                    },
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

  Future<void> _selectDate(
    BuildContext context,
    DateTime initialDate,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}










