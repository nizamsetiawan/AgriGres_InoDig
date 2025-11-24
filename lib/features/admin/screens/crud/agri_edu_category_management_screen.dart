import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/agri_edu_category_management_controller.dart';
import 'package:agrigres/features/admin/screens/crud/create_edit_agri_edu_category_screen.dart';
import 'package:agrigres/features/agri_edu/models/agri_edu_category_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

class AgriEduCategoryManagementScreen extends StatelessWidget {
  const AgriEduCategoryManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AgriEduCategoryManagementController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Manajemen Kategori AgriEdu'),
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
                  onPressed: () => Get.to(() => const CreateEditAgriEduCategoryScreen()),
                  tooltip: 'Tambah Kategori',
                ),
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => controller.loadCategories(),
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
                    hintText: 'Cari kategori...',
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

            // Categories List
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final filteredCategories = controller.filteredCategories;

                if (filteredCategories.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Tidak ada kategori'
                            : 'Kategori tidak ditemukan',
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = filteredCategories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildCategoryCard(context, category, controller),
                      );
                    },
                    childCount: filteredCategories.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    AgriEduCategoryModel category,
    AgriEduCategoryManagementController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Iconsax.category,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Category Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      category.name,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    if (!category.isActive) ...[
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
                  'Order: ${category.order}',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Menu
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
                  () => Get.to(() => CreateEditAgriEduCategoryScreen(category: category)),
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
                  () => _showDeleteConfirmation(context, category, controller),
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
    AgriEduCategoryModel category,
    AgriEduCategoryManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus kategori "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteCategory(category.id);
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

