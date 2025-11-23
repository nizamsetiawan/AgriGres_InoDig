import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/planting_calendar/controllers/planting_calendar_controller.dart';
import 'package:agrigres/features/planting_calendar/models/planting_calendar_model.dart';
import 'package:agrigres/features/planting_calendar/screens/planting_calendar_detail_screen.dart';

class PlantingCalendarScreen extends StatelessWidget {
  const PlantingCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlantingCalendarController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        title: Text('Kalender Tanam'),
        showBackArrow: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    onChanged: (value) => controller.searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Cari tanaman...',
                      prefixIcon: const Icon(Iconsax.search_normal),
                      suffixIcon: Obx(
                        () => controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Iconsax.close_circle),
                                onPressed: () => controller.searchQuery.value = '',
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Section
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          context,
                          'Bulan',
                          controller.selectedMonth.value,
                          controller.months,
                          (value) => controller.selectedMonth.value = value ?? '',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterDropdown(
                          context,
                          'Jenis Tanaman',
                          controller.selectedCropType.value,
                          ['Semua', ...controller.cropTypes],
                          (value) => controller.selectedCropType.value = value == 'Semua' ? '' : (value ?? ''),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Current Month Section
                  if (controller.currentMonthCalendars.isNotEmpty) ...[
                    Text(
                      'Tanaman Bulan Ini',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...controller.currentMonthCalendars.map((calendar) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCalendarCard(context, calendar, controller),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],

                  // All Calendars Section
                  Text(
                    'Semua Kalender Tanam',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Calendars List
                  if (controller.filteredCalendars.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Tidak ada kalender tanam ditemukan',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  else
                    ...controller.filteredCalendars.map((calendar) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCalendarCard(context, calendar, controller),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCalendarCard(
    BuildContext context,
    PlantingCalendarModel calendar,
    PlantingCalendarController controller,
  ) {
    return GestureDetector(
      onTap: () => Get.to(() => PlantingCalendarDetailScreen(calendar: calendar)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Iconsax.calendar, color: Colors.green[600], size: 24),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    calendar.cropName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Iconsax.calendar_1, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Tanam: ${calendar.plantingMonth}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Iconsax.timer, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Panen: ${calendar.harvestMonth}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      calendar.cropType,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Iconsax.arrow_right_3, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}

