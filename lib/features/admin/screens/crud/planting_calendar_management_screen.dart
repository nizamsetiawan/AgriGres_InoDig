import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/planting_calendar_management_controller.dart';
import 'package:agrigres/features/admin/screens/crud/create_edit_planting_calendar_screen.dart';
import 'package:agrigres/features/planting_calendar/models/planting_calendar_model.dart';

class PlantingCalendarManagementScreen extends StatelessWidget {
  const PlantingCalendarManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlantingCalendarManagementController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Manajemen Kalender Tanam'),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              foregroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.add),
                  onPressed: () => Get.to(() => const CreateEditPlantingCalendarScreen()),
                  tooltip: 'Tambah Kalender',
                ),
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => controller.loadCalendars(),
                  tooltip: 'Refresh',
                ),
              ],
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Cari kalender tanam...',
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
              ),
            ),

            // Calendars List
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final filteredCalendars = controller.filteredCalendars;

                if (filteredCalendars.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Tidak ada kalender tanam'
                            : 'Kalender tanam tidak ditemukan',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final calendar = filteredCalendars[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: _buildCalendarCard(context, calendar, controller),
                      );
                    },
                    childCount: filteredCalendars.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard(
    BuildContext context,
    PlantingCalendarModel calendar,
    PlantingCalendarManagementController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.calendar, color: Colors.green[600], size: 20),
              ),
              const SizedBox(width: 12),
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
                    Text(
                      '${calendar.cropType} • ${calendar.plantingMonth} - ${calendar.harvestMonth}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: calendar.isActive ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: calendar.isActive ? Colors.green[200]! : Colors.red[200]!,
                  ),
                ),
                child: Text(
                  calendar.isActive ? 'Aktif' : 'Tidak Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: calendar.isActive ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => controller.toggleCalendarStatus(calendar),
                icon: Icon(
                  calendar.isActive ? Iconsax.eye_slash : Iconsax.eye,
                  size: 16,
                ),
                label: Text(calendar.isActive ? 'Nonaktifkan' : 'Aktifkan'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => Get.to(
                  () => CreateEditPlantingCalendarScreen(calendar: calendar),
                ),
                icon: const Icon(Iconsax.edit, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _showDeleteDialog(context, calendar, controller),
                icon: const Icon(Iconsax.trash, size: 16, color: Colors.red),
                label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    PlantingCalendarModel calendar,
    PlantingCalendarManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus kalender tanam "${calendar.cropName}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteCalendar(calendar.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

