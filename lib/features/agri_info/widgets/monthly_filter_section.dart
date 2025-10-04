import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/controllers/monthly_detail_agri_info_controller.dart';

class MonthlyFilterSection extends StatelessWidget {
  const MonthlyFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MonthlyDetailAgriInfoController>();
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
        
        // Tahun Awal dan Tahun Akhir
        Row(
          children: [
            // Tahun Awal
            Expanded(
              child: Obx(() => _buildYearFilter(
                context,
                'Tahun Awal',
                controller.startYear.value,
                (year) => controller.setStartYear(year),
              )),
            ),
            
            const SizedBox(width: 12),
            
            // Tahun Akhir
            Expanded(
              child: Obx(() => _buildYearFilter(
                context,
                'Tahun Akhir',
                controller.endYear.value,
                (year) => controller.setEndYear(year),
              )),
            ),
          ],
        ),
        
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

  Widget _buildYearFilter(
    BuildContext context,
    String label,
    int selectedYear,
    Function(int) onYearSelected,
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
          onTap: () => _selectYear(context, selectedYear, onYearSelected),
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
                    selectedYear.toString(),
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

  void _showLevelHargaPicker(BuildContext context, MonthlyDetailAgriInfoController controller) {
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

  Future<void> _selectYear(
    BuildContext context,
    int initialYear,
    Function(int) onYearSelected,
  ) async {
    final now = DateTime.now();
    final int? picked = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tahun'),
        content: SizedBox(
          width: 200,
          height: 300,
          child: YearPicker(
            firstDate: DateTime(2020),
            lastDate: DateTime(now.year + 1),
            selectedDate: DateTime(initialYear),
            onChanged: (DateTime dateTime) {
              Navigator.pop(context, dateTime.year);
            },
          ),
        ),
      ),
    );
    
    if (picked != null && picked != initialYear) {
      onYearSelected(picked);
    }
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
