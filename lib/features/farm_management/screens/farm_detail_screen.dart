import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/farm_management/models/farm_model.dart';
import 'package:agrigres/features/farm_management/screens/create_edit_farm_screen.dart';
import 'package:agrigres/features/farm_management/controllers/farm_management_controller.dart';
import 'package:intl/intl.dart';

class FarmDetailScreen extends StatelessWidget {
  final FarmModel farm;

  const FarmDetailScreen({
    Key? key,
    required this.farm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FarmManagementController>();
    final dateFormat = DateFormat('dd MMM yyyy');
    final statusColor = Color(farm.statusColor);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: const Text('Detail Lahan'),
        showBackArrow: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () => Get.to(() => CreateEditFarmScreen(farm: farm)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Images
            if (farm.imageUrls.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: farm.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 8),
                      child: CachedNetworkImage(
                        imageUrl: farm.imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Icon(Iconsax.image, size: 48, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          farm.farmName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          farm.statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Farm Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          Iconsax.ruler,
                          'Luas Lahan',
                          '${farm.area} hektar',
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          Iconsax.location,
                          'Lokasi',
                          farm.location,
                        ),
                        if (farm.address != null && farm.address!.isNotEmpty) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Iconsax.map,
                            'Alamat',
                            farm.address!,
                          ),
                        ],
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          Iconsax.tree,
                          'Jenis Tanaman',
                          farm.cropType,
                        ),
                        if (farm.cropVariety != null && farm.cropVariety!.isNotEmpty) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Iconsax.tick_circle,
                            'Varietas',
                            farm.cropVariety!,
                          ),
                        ],
                        if (farm.plantingDate != null) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Iconsax.calendar_1,
                            'Tanggal Tanam',
                            dateFormat.format(farm.plantingDate!),
                          ),
                        ],
                        if (farm.expectedHarvestDate != null) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Iconsax.timer,
                            'Estimasi Panen',
                            dateFormat.format(farm.expectedHarvestDate!),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Notes
                  if (farm.notes != null && farm.notes!.isNotEmpty) ...[
                    Text(
                      'Catatan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        farm.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Get.to(() => CreateEditFarmScreen(farm: farm)),
                          icon: const Icon(Iconsax.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showDeleteDialog(context, farm, controller),
                          icon: const Icon(Iconsax.trash),
                          label: const Text('Hapus'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    FarmModel farm,
    FarmManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus lahan "${farm.farmName}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteFarm(farm.id);
              Get.back(); // Close detail screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

