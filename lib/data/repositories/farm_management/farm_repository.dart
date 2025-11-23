import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/farm_management/models/farm_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class FarmRepository extends GetxController {
  static FarmRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collectionName = 'Farms';

  /// Get all farms for a specific user
  Future<List<FarmModel>> getUserFarms(String userId) async {
    try {
      final querySnapshot = await _db
          .collection(_collectionName)
          .where('user_id', isEqualTo: userId)
          .get();


      return querySnapshot.docs
          .map((doc) => FarmModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error getting user farms', e);
      return [];
    }
  }

  /// Get all farms (for admin)
  Future<List<FarmModel>> getAllFarms() async {
    try {
      final querySnapshot = await _db
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FarmModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error getting all farms', e);
      return [];
    }
  }

  /// Get farm by ID
  Future<FarmModel?> getFarmById(String farmId) async {
    try {
      final doc = await _db.collection(_collectionName).doc(farmId).get();
      if (doc.exists && doc.data() != null) {
        return FarmModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      TLoggerHelper.error('Error getting farm by ID', e);
      return null;
    }
  }

  /// Create farm
  Future<void> createFarm(FarmModel farm) async {
    try {
      await _db.collection(_collectionName).add(farm.toJson());
      TLoggerHelper.info('Farm created successfully');
    } catch (e) {
      TLoggerHelper.error('Error creating farm', e);
      rethrow;
    }
  }

  /// Update farm
  Future<void> updateFarm(FarmModel farm) async {
    try {
      await _db
          .collection(_collectionName)
          .doc(farm.id)
          .update(farm.toJson());
      TLoggerHelper.info('Farm updated successfully');
    } catch (e) {
      TLoggerHelper.error('Error updating farm', e);
      rethrow;
    }
  }

  /// Delete farm
  Future<void> deleteFarm(String farmId) async {
    try {
      await _db.collection(_collectionName).doc(farmId).delete();
      TLoggerHelper.info('Farm deleted successfully');
    } catch (e) {
      TLoggerHelper.error('Error deleting farm', e);
      rethrow;
    }
  }
}

