import 'package:get/get.dart';
import 'package:agrigres/data/repositories/announcement/announcement_repository.dart';
import 'package:agrigres/features/admin/models/announcement_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';
import 'package:agrigres/features/admin/controllers/admin_auth_controller.dart';

class AnnouncementsManagementController extends GetxController {
  final AnnouncementRepository _announcementRepository = Get.find<AnnouncementRepository>();
  
  final announcements = <AnnouncementModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final searchQuery = ''.obs;

  /// Get AdminAuthController (lazy access)
  AdminAuthController? get _adminAuthController {
    try {
      return Get.find<AdminAuthController>();
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
  }

  /// Load all announcements
  Future<void> loadAnnouncements() async {
    try {
      isLoading.value = true;
      final loadedAnnouncements = await _announcementRepository.getAllAnnouncements();
      announcements.assignAll(loadedAnnouncements);
    } catch (e) {
      TLoggerHelper.error('Error loading announcements', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat pengumuman: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered announcements based on search query
  List<AnnouncementModel> get filteredAnnouncements {
    if (searchQuery.value.isEmpty) {
      return announcements;
    }
    final query = searchQuery.value.toLowerCase();
    return announcements.where((announcement) {
      return announcement.title.toLowerCase().contains(query) ||
          announcement.content.toLowerCase().contains(query) ||
          announcement.type.toLowerCase().contains(query);
    }).toList();
  }

  /// Create announcement
  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    try {
      isSaving.value = true;
      String createdBy = 'Admin';
      if (_adminAuthController != null) {
        final admin = _adminAuthController!.currentAdmin.value;
        createdBy = admin?.email ?? admin?.name ?? 'Admin';
      }
      final announcementWithCreator = announcement.copyWith(
        createdBy: createdBy,
      );
      await _announcementRepository.createAnnouncement(announcementWithCreator);
      await loadAnnouncements();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengumuman berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating announcement', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat pengumuman: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Update announcement
  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    try {
      isSaving.value = true;
      await _announcementRepository.updateAnnouncement(announcement);
      await loadAnnouncements();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengumuman berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating announcement', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui pengumuman: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete announcement
  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      isSaving.value = true;
      await _announcementRepository.deleteAnnouncement(announcementId);
      await loadAnnouncements();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengumuman berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting announcement', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus pengumuman: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Toggle announcement active status
  Future<void> toggleAnnouncementStatus(AnnouncementModel announcement) async {
    try {
      final updated = announcement.copyWith(isActive: !announcement.isActive);
      await updateAnnouncement(updated);
    } catch (e) {
      TLoggerHelper.error('Error toggling announcement status', e);
    }
  }
}

