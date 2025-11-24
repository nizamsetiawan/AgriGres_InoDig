import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/level_harga_option_management_controller.dart';
import 'package:agrigres/features/admin/screens/crud/create_edit_level_harga_option_screen.dart';
import 'package:agrigres/features/agri_info/models/level_harga_option_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

class LevelHargaOptionManagementScreen extends StatelessWidget {
  const LevelHargaOptionManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LevelHargaOptionManagementController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Manajemen Level Harga'),
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
                  onPressed: () => Get.to(() => const CreateEditLevelHargaOptionScreen()),
                  tooltip: 'Tambah Opsi',
                ),
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => controller.loadOptions(),
                  tooltip: 'Refresh',
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Cari opsi...',
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
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final filteredOptions = controller.filteredOptions;
                if (filteredOptions.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Tidak ada opsi'
                            : 'Opsi tidak ditemukan',
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final option = filteredOptions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildOptionCard(context, option, controller),
                      );
                    },
                    childCount: filteredOptions.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    LevelHargaOptionModel option,
    LevelHargaOptionManagementController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Iconsax.dollar_circle, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      option.name,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    if (!option.isActive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Nonaktif',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Level ID: ${option.levelId} • Order: ${option.order}',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
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
                  () => Get.to(() => CreateEditLevelHargaOptionScreen(option: option)),
                ),
              ),
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
                  () => _showDeleteConfirmation(context, option, controller),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    LevelHargaOptionModel option,
    LevelHargaOptionManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus opsi "${option.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              controller.deleteOption(option.id);
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

