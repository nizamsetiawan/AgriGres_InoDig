import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/planting_calendar/models/planting_calendar_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class PlantingCalendarRepository extends GetxController {
  static PlantingCalendarRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collectionName = 'PlantingCalendar';

  /// Get all active planting calendars
  Future<List<PlantingCalendarModel>> getActivePlantingCalendars() async {
    try {
      final querySnapshot = await _db.collection(_collectionName).get();

      final allCalendars = querySnapshot.docs
          .map((doc) => PlantingCalendarModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ))
          .where((calendar) => calendar.isActive)
          .toList();

      // Sort by planting month
      allCalendars.sort((a, b) => a.plantingMonth.compareTo(b.plantingMonth));

      return allCalendars;
    } catch (e) {
      TLoggerHelper.error('Error getting active planting calendars', e);
      return [];
    }
  }

  /// Get all planting calendars (for admin)
  Future<List<PlantingCalendarModel>> getAllPlantingCalendars() async {
    try {
      final querySnapshot = await _db
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PlantingCalendarModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error getting all planting calendars', e);
      return [];
    }
  }

  /// Get planting calendars by month
  Future<List<PlantingCalendarModel>> getPlantingCalendarsByMonth(String month) async {
    try {
      final allCalendars = await getActivePlantingCalendars();
      return allCalendars.where((calendar) => calendar.plantingMonth == month).toList();
    } catch (e) {
      TLoggerHelper.error('Error getting planting calendars by month', e);
      return [];
    }
  }

  /// Get planting calendars by crop type
  Future<List<PlantingCalendarModel>> getPlantingCalendarsByType(String cropType) async {
    try {
      final allCalendars = await getActivePlantingCalendars();
      return allCalendars.where((calendar) => calendar.cropType == cropType).toList();
    } catch (e) {
      TLoggerHelper.error('Error getting planting calendars by type', e);
      return [];
    }
  }

  /// Create planting calendar
  Future<void> createPlantingCalendar(PlantingCalendarModel calendar) async {
    try {
      await _db.collection(_collectionName).add(calendar.toJson());
      TLoggerHelper.info('Planting calendar created successfully');
    } catch (e) {
      TLoggerHelper.error('Error creating planting calendar', e);
      rethrow;
    }
  }

  /// Update planting calendar
  Future<void> updatePlantingCalendar(PlantingCalendarModel calendar) async {
    try {
      await _db
          .collection(_collectionName)
          .doc(calendar.id)
          .update(calendar.toJson());
      TLoggerHelper.info('Planting calendar updated successfully');
    } catch (e) {
      TLoggerHelper.error('Error updating planting calendar', e);
      rethrow;
    }
  }

  /// Delete planting calendar
  Future<void> deletePlantingCalendar(String calendarId) async {
    try {
      await _db.collection(_collectionName).doc(calendarId).delete();
      TLoggerHelper.info('Planting calendar deleted successfully');
    } catch (e) {
      TLoggerHelper.error('Error deleting planting calendar', e);
      rethrow;
    }
  }

  /// Get planting calendar by ID
  Future<PlantingCalendarModel?> getPlantingCalendarById(String id) async {
    try {
      final doc = await _db.collection(_collectionName).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return PlantingCalendarModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      TLoggerHelper.error('Error getting planting calendar by ID', e);
      return null;
    }
  }
}

