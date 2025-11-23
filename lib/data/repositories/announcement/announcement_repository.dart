import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/admin/models/announcement_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class AnnouncementRepository extends GetxController {
  static AnnouncementRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collectionName = 'Announcements';

  /// Get all active announcements
  Future<List<AnnouncementModel>> getActiveAnnouncements() async {
    try {
      // Load all announcements and filter/sort in memory to avoid index requirement
      final querySnapshot = await _db
          .collection(_collectionName)
          .get();

      final allAnnouncements = querySnapshot.docs
          .map((doc) => AnnouncementModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ))
          .where((announcement) => announcement.isActive && announcement.isValid)
          .toList();

      // Sort by created_at descending
      allAnnouncements.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return allAnnouncements;
    } catch (e) {
      TLoggerHelper.error('Error getting active announcements', e);
      return [];
    }
  }

  /// Get all announcements (for admin)
  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    try {
      final querySnapshot = await _db
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AnnouncementModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error getting all announcements', e);
      return [];
    }
  }

  /// Create announcement
  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    try {
      await _db.collection(_collectionName).add(announcement.toJson());
      TLoggerHelper.info('Announcement created successfully');
    } catch (e) {
      TLoggerHelper.error('Error creating announcement', e);
      rethrow;
    }
  }

  /// Update announcement
  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    try {
      await _db
          .collection(_collectionName)
          .doc(announcement.id)
          .update(announcement.toJson());
      TLoggerHelper.info('Announcement updated successfully');
    } catch (e) {
      TLoggerHelper.error('Error updating announcement', e);
      rethrow;
    }
  }

  /// Delete announcement
  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      await _db.collection(_collectionName).doc(announcementId).delete();
      TLoggerHelper.info('Announcement deleted successfully');
    } catch (e) {
      TLoggerHelper.error('Error deleting announcement', e);
      rethrow;
    }
  }

  /// Get announcement by ID
  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    try {
      final doc = await _db.collection(_collectionName).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return AnnouncementModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      TLoggerHelper.error('Error getting announcement by ID', e);
      return null;
    }
  }
}

