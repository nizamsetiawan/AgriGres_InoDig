import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/notification/models/notification_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class NotificationsManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  /// Load all notifications
  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading notifications...');

      final snapshot = await _db
          .collection('Notifications')
          .orderBy('created_at', descending: true)
          .get();

      notifications.assignAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          return NotificationModel(
            id: doc.id,
            jenisDarurat: data['jenis_darurat'] ?? '',
            lokasiLahan: data['lokasi_lahan'] ?? '',
            kontakPetani: data['kontak_petani'] ?? '',
            namaPelapor: data['nama_pelapor'] ?? '',
            tanggalTerjadi: data['tanggal_terjadi'] != null
                ? DateTime.parse(data['tanggal_terjadi'])
                : DateTime.now(),
            deskripsiSingkat: data['deskripsi_singkat'] ?? '',
            imageUrls: List<String>.from(data['image_urls'] ?? []),
            status: data['status'] ?? 'pending',
            createdAt: data['created_at'] != null
                ? DateTime.parse(data['created_at'])
                : DateTime.now(),
            updatedAt: data['updated_at'] != null
                ? DateTime.parse(data['updated_at'])
                : null,
          );
        }).toList(),
      );

      TLoggerHelper.info('Loaded ${notifications.length} notifications');
    } catch (e) {
      TLoggerHelper.error('Error loading notifications', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat notifikasi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered notifications based on search query
  List<NotificationModel> get filteredNotifications {
    if (searchQuery.value.isEmpty) {
      return notifications;
    }
    return notifications.where((notification) {
      final query = searchQuery.value.toLowerCase();
      return notification.jenisDarurat.toLowerCase().contains(query) ||
          notification.lokasiLahan.toLowerCase().contains(query) ||
          notification.namaPelapor.toLowerCase().contains(query) ||
          notification.status.toLowerCase().contains(query);
    }).toList();
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      TLoggerHelper.info('Deleting notification: $notificationId');

      await _db.collection('Notifications').doc(notificationId).delete();

      notifications.removeWhere((notification) => notification.id == notificationId);

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Notifikasi berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting notification', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus notifikasi: ${e.toString()}',
      );
    }
  }

  /// Update notification status
  Future<void> updateNotificationStatus(String notificationId, String status) async {
    try {
      TLoggerHelper.info('Updating notification status: $notificationId -> $status');

      await _db.collection('Notifications').doc(notificationId).update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      });

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
      }

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Status notifikasi berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating notification status', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui status: ${e.toString()}',
      );
    }
  }
}

