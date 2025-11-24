import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/home_menu_management_controller.dart';
import 'package:agrigres/features/admin/screens/crud/create_edit_home_menu_screen.dart';
import 'package:agrigres/features/detection/models/home_menu_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/icon_helper.dart';

class HomeMenuManagementScreen extends StatelessWidget {
  const HomeMenuManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeMenuManagementController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Manajemen Menu Utama'),
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
                  onPressed: () => Get.to(() => const CreateEditHomeMenuScreen()),
                  tooltip: 'Tambah Menu',
                ),
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => controller.loadMenus(),
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
                    hintText: 'Cari menu...',
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

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.info_circle, color: Colors.green[700], size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Pedoman Menu Utama',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Beranda hanya menampilkan 6 menu aktif (AgriInfo, AgriEdu, AgriCare, AgriMart, AgriKalender, AgriLahan). Gunakan awalan "Agri" agar nama menu seragam.',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Menus List
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final filteredMenus = controller.filteredMenus;

                if (filteredMenus.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Tidak ada menu'
                            : 'Menu tidak ditemukan',
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final menu = filteredMenus[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildMenuCard(context, menu, controller),
                      );
                    },
                    childCount: filteredMenus.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    HomeMenuModel menu,
    HomeMenuManagementController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final icon = IconHelper.getIconFromName(menu.iconName) ?? Icons.help_outline;
    final backgroundColor = IconHelper.intToColor(menu.backgroundColor);
    final iconColor = IconHelper.intToColor(menu.iconColor);

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
          // Icon Preview
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          // Menu Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      menu.title,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    if (!menu.isActive) ...[
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
                  menu.subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Route: ${menu.route}',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• Order: ${menu.order}',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
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
                  () => Get.to(() => CreateEditHomeMenuScreen(menu: menu)),
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
                  () => _showDeleteConfirmation(context, menu, controller),
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
    HomeMenuModel menu,
    HomeMenuManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus menu "${menu.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteMenu(menu.id);
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

