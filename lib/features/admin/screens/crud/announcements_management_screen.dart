import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/announcements_management_controller.dart';
import 'package:agrigres/features/admin/screens/crud/create_edit_announcement_screen.dart';
import 'package:agrigres/features/admin/models/announcement_model.dart';
import 'package:intl/intl.dart';

class AnnouncementsManagementScreen extends StatelessWidget {
  const AnnouncementsManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnnouncementsManagementController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Manajemen Pengumuman'),
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
                  onPressed: () => Get.to(() => const CreateEditAnnouncementScreen()),
                  tooltip: 'Tambah Pengumuman',
                ),
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => controller.loadAnnouncements(),
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
                    hintText: 'Cari pengumuman...',
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

            // Announcements List
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final filteredAnnouncements = controller.filteredAnnouncements;

                if (filteredAnnouncements.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Tidak ada pengumuman'
                            : 'Pengumuman tidak ditemukan',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final announcement = filteredAnnouncements[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: _buildAnnouncementCard(context, announcement, controller),
                      );
                    },
                    childCount: filteredAnnouncements.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context,
    AnnouncementModel announcement,
    AnnouncementsManagementController controller,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final typeColors = {
      'announcement': Colors.blue,
      'update': Colors.green,
      'feature': Colors.purple,
    };
    final typeLabels = {
      'announcement': 'Pengumuman',
      'update': 'Pembaruan',
      'feature': 'Fitur Baru',
    };

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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (typeColors[announcement.type] ?? Colors.grey)[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: (typeColors[announcement.type] ?? Colors.grey)[200]!,
                  ),
                ),
                child: Text(
                  typeLabels[announcement.type] ?? announcement.type,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: typeColors[announcement.type] ?? Colors.grey,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: announcement.isActive ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: announcement.isActive ? Colors.green[200]! : Colors.red[200]!,
                  ),
                ),
                child: Text(
                  announcement.isActive ? 'Aktif' : 'Tidak Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: announcement.isActive ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            announcement.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            announcement.content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Iconsax.calendar, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                dateFormat.format(announcement.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
              if (announcement.expiresAt != null) ...[
                const SizedBox(width: 12),
                Icon(Iconsax.timer, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Berlaku hingga ${dateFormat.format(announcement.expiresAt!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => controller.toggleAnnouncementStatus(announcement),
                icon: Icon(
                  announcement.isActive ? Iconsax.eye_slash : Iconsax.eye,
                  size: 16,
                ),
                label: Text(announcement.isActive ? 'Nonaktifkan' : 'Aktifkan'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => Get.to(
                  () => CreateEditAnnouncementScreen(announcement: announcement),
                ),
                icon: const Icon(Iconsax.edit, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _showDeleteDialog(context, announcement, controller),
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
    AnnouncementModel announcement,
    AnnouncementsManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus pengumuman "${announcement.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteAnnouncement(announcement.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

