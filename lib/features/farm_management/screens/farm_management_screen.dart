import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/farm_management/controllers/farm_management_controller.dart';
import 'package:agrigres/features/farm_management/models/farm_model.dart';
import 'package:agrigres/features/farm_management/screens/farm_detail_screen.dart';
import 'package:agrigres/features/farm_management/screens/create_edit_farm_screen.dart';
import 'package:intl/intl.dart';

class FarmManagementScreen extends StatelessWidget {
  const FarmManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FarmManagementController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        title: Text('Manajemen Lahan'),
        showBackArrow: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Get.to(() => const CreateEditFarmScreen()),
        child: const Icon(Iconsax.add, color: Colors.white,),
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
                      hintText: 'Cari lahan...',
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

                  // Status Filter
                  DropdownButtonFormField<String>(
                    value: controller.selectedStatus.value.isEmpty
                        ? 'Semua'
                        : controller.selectedStatus.value,
                    decoration: const InputDecoration(
                      labelText: 'Filter Status',
                      prefixIcon: Icon(Iconsax.filter),
                    ),
                    items: controller.statusOptions.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status == 'Semua' ? 'Semua Status' : _getStatusLabel(status)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedStatus.value = value ?? 'Semua';
                    },
                  ),
                  const SizedBox(height: 20),

                  // Farms List
                  Text(
                    'Daftar Lahan (${controller.filteredFarms.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (controller.filteredFarms.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Iconsax.home_2, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              controller.searchQuery.value.isEmpty &&
                                      controller.selectedStatus.value.isEmpty
                                  ? 'Belum ada lahan'
                                  : 'Lahan tidak ditemukan',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (controller.searchQuery.value.isEmpty &&
                                controller.selectedStatus.value.isEmpty)
                              Text(
                                'Tambahkan lahan baru untuk mulai mengelola',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...controller.filteredFarms.map((farm) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildFarmCard(context, farm, controller),
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

  Widget _buildFarmCard(
    BuildContext context,
    FarmModel farm,
    FarmManagementController controller,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final statusColor = Color(farm.statusColor);

    return GestureDetector(
      onTap: () => Get.to(() => FarmDetailScreen(farm: farm)),
      child: Container(
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Iconsax.home_2, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farm.farmName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Iconsax.location, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              farm.location,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    farm.statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    Iconsax.ruler,
                    'Luas',
                    '${farm.area} ha',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    Iconsax.tree,
                    'Tanaman',
                    farm.cropType,
                  ),
                ),
              ],
            ),
            if (farm.plantingDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Iconsax.calendar_1, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Tanam: ${dateFormat.format(farm.plantingDate!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'preparing':
        return 'Persiapan';
      case 'planting':
        return 'Menanam';
      case 'growing':
        return 'Tumbuh';
      case 'harvesting':
        return 'Panen';
      case 'harvested':
        return 'Sudah Panen';
      default:
        return status;
    }
  }
}

