import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/detection_config_management_controller.dart';
import 'package:agrigres/features/admin/screens/crud/create_edit_detection_config_screen.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

class DetectionConfigManagementScreen extends StatelessWidget {
  const DetectionConfigManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetectionConfigManagementController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Manajemen Konfigurasi Deteksi'),
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
                  onPressed: () => Get.to(() => CreateEditDetectionConfigScreen()),
                  tooltip: 'Tambah Tanaman',
                ),
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => controller.loadConfigs(),
                  tooltip: 'Refresh',
                ),
              ],
            ),

            // Info Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Kelola daftar penyakit dan keyword untuk deteksi menggunakan Gemini API. Perubahan akan diterapkan setelah cache expire (1 jam) atau clear cache.',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Configs List
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.configs.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Tidak ada konfigurasi',
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final config = controller.configs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildConfigCard(context, config, controller),
                      );
                    },
                    childCount: controller.configs.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigCard(
    BuildContext context,
    DetectionConfigModel config,
    DetectionConfigManagementController controller,
  ) {
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Iconsax.scan_barcode,
                  color: Colors.green[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.plantType,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${config.labels.length} penyakit dikonfigurasi',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Iconsax.more, size: 20),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Iconsax.edit, size: 18),
                        SizedBox(width: TSizes.xs),
                        Text('Edit'),
                      ],
                    ),
                    onTap: () => Future.delayed(
                      const Duration(milliseconds: 100),
                      () => Get.to(() => CreateEditDetectionConfigScreen(config: config)),
                    ),
                  ),
                  if (!DetectionConfigManagementController.defaultPlantTypes.contains(config.plantType))
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Iconsax.trash, size: 18, color: Colors.red),
                          SizedBox(width: TSizes.xs),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      onTap: () => Future.delayed(
                        const Duration(milliseconds: 100),
                        () => _showDeleteConfirmation(context, config, controller),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Labels Preview
          if (config.labels.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Daftar Penyakit:',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: config.labels.take(5).map((label) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (config.labels.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'dan ${config.labels.length - 5} penyakit lainnya...',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              ),
          ],

          // Custom Keyword Indicator
          if (config.customKeyword != null && config.customKeyword!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Iconsax.document_text, size: 16, color: Colors.amber[700]),
                const SizedBox(width: 6),
                Text(
                  'Custom keyword tersedia',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    DetectionConfigModel config,
    DetectionConfigManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus konfigurasi untuk "${config.plantType}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteConfig(config.plantType);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

