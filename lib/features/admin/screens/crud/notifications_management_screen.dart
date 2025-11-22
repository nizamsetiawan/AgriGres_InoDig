import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/notifications_management_controller.dart';
import 'package:agrigres/features/admin/screens/crud/edit_notification_screen.dart';
import 'package:agrigres/features/notification/models/notification_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:intl/intl.dart';

class NotificationsManagementScreen extends StatelessWidget {
  const NotificationsManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsManagementController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Manajemen Notifikasi'),
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
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => controller.loadNotifications(),
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
                    hintText: 'Cari notifikasi...',
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

            // Notifications List
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final filteredNotifications = controller.filteredNotifications;

                if (filteredNotifications.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Tidak ada notifikasi'
                            : 'Notifikasi tidak ditemukan',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final notification = filteredNotifications[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildNotificationCard(
                            context, notification, controller),
                      );
                    },
                    childCount: filteredNotifications.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
    NotificationsManagementController controller,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final textTheme = Theme.of(context).textTheme;
    Color statusColor;
    switch (notification.status) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'processing':
        statusColor = Colors.blue;
        break;
      case 'resolved':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.jenisDarurat,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: TSizes.xs),
                      Text(
                        'Pelapor: ${notification.namaPelapor}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.sm,
                    vertical: TSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    notification.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Iconsax.edit, size: 18),
                          SizedBox(width: TSizes.xs),
                          Text('Ubah Status'),
                        ],
                      ),
                      onTap: () => Future.delayed(
                        const Duration(milliseconds: 100),
                        () => Get.to(() => EditNotificationScreen(notification: notification)),
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
                        () => _showDeleteConfirmation(
                            context, notification, controller),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.sm),
            const Divider(height: 1),

            // Details
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lokasi: ${notification.lokasiLahan}',
                    style: textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    'Kontak: ${notification.kontakPetani}',
                    style: textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    'Tanggal: ${dateFormat.format(notification.tanggalTerjadi)}',
                    style: textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    notification.deskripsiSingkat,
                    style: textTheme.bodyMedium?.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),

          ],
        ),
      );
  }


  void _showDeleteConfirmation(
    BuildContext context,
    NotificationModel notification,
    NotificationsManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus notifikasi ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteNotification(notification.id);
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

