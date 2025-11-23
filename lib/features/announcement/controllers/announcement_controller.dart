import 'package:get/get.dart';
import 'package:agrigres/data/repositories/announcement/announcement_repository.dart';
import 'package:agrigres/features/admin/models/announcement_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class AnnouncementController extends GetxController {
  final AnnouncementRepository _announcementRepository = Get.find<AnnouncementRepository>();

  final announcements = <AnnouncementModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
  }

  /// Load active announcements
  Future<void> loadAnnouncements() async {
    try {
      isLoading.value = true;
      final loadedAnnouncements = await _announcementRepository.getActiveAnnouncements();
      announcements.assignAll(loadedAnnouncements);
      TLoggerHelper.info('Loaded ${loadedAnnouncements.length} active announcements');
    } catch (e) {
      TLoggerHelper.error('Error loading announcements', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get all valid announcements (active and not expired)
  /// Announcements will always be shown when app opens (no tracking)
  List<AnnouncementModel> getValidAnnouncements() {
    return announcements.where((announcement) {
      // Filter by isActive and isValid (checks expiresAt)
      return announcement.isActive && announcement.isValid;
    }).toList();
  }
}

