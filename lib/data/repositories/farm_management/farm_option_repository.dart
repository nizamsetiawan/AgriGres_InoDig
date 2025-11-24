import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrigres/features/farm_management/models/farm_option_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class FarmOptionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get crop types
  Future<List<FarmOptionModel>> getCropTypes() async {
    try {
      TLoggerHelper.info('Fetching crop types from Firebase...');

      final snapshot = await _db
          .collection('FarmOptions')
          .where('type', isEqualTo: 'crop_type')
          .where('is_active', isEqualTo: true)
          .orderBy('order')
          .get();

      final cropTypes = snapshot.docs
          .map((doc) => FarmOptionModel.fromSnapshot(doc))
          .where((option) => option.value.isNotEmpty)
          .toList();

      TLoggerHelper.info('Loaded ${cropTypes.length} crop types from Firebase');

      // If no crop types found, return default
      if (cropTypes.isEmpty) {
        return _getDefaultCropTypes();
      }

      return cropTypes;
    } catch (e) {
      TLoggerHelper.error('Error fetching crop types from Firebase', e);
      // Return default crop types on error
      return _getDefaultCropTypes();
    }
  }

  /// Get status options
  Future<List<FarmOptionModel>> getStatusOptions() async {
    try {
      TLoggerHelper.info('Fetching status options from Firebase...');

      final snapshot = await _db
          .collection('FarmOptions')
          .where('type', isEqualTo: 'status')
          .where('is_active', isEqualTo: true)
          .orderBy('order')
          .get();

      final statusOptions = snapshot.docs
          .map((doc) => FarmOptionModel.fromSnapshot(doc))
          .where((option) => option.value.isNotEmpty)
          .toList();

      TLoggerHelper.info('Loaded ${statusOptions.length} status options from Firebase');

      // If no status options found, return default
      if (statusOptions.isEmpty) {
        return _getDefaultStatusOptions();
      }

      return statusOptions;
    } catch (e) {
      TLoggerHelper.error('Error fetching status options from Firebase', e);
      // Return default status options on error
      return _getDefaultStatusOptions();
    }
  }

  /// Get default crop types (fallback)
  List<FarmOptionModel> _getDefaultCropTypes() {
    TLoggerHelper.info('Using default crop types');
    return [
      FarmOptionModel(id: 'padi', type: 'crop_type', value: 'Padi', label: 'Padi', order: 1, isActive: true),
      FarmOptionModel(id: 'jagung', type: 'crop_type', value: 'Jagung', label: 'Jagung', order: 2, isActive: true),
      FarmOptionModel(id: 'sayuran', type: 'crop_type', value: 'Sayuran', label: 'Sayuran', order: 3, isActive: true),
      FarmOptionModel(id: 'buah', type: 'crop_type', value: 'Buah-buahan', label: 'Buah-buahan', order: 4, isActive: true),
      FarmOptionModel(id: 'palawija', type: 'crop_type', value: 'Palawija', label: 'Palawija', order: 5, isActive: true),
      FarmOptionModel(id: 'hortikultura', type: 'crop_type', value: 'Hortikultura', label: 'Hortikultura', order: 6, isActive: true),
      FarmOptionModel(id: 'lainnya', type: 'crop_type', value: 'Lainnya', label: 'Lainnya', order: 7, isActive: true),
    ];
  }

  /// Get default status options (fallback)
  List<FarmOptionModel> _getDefaultStatusOptions() {
    TLoggerHelper.info('Using default status options');
    return [
      FarmOptionModel(id: 'preparing', type: 'status', value: 'preparing', label: 'Persiapan', order: 1, isActive: true, color: 0xFF9E9E9E),
      FarmOptionModel(id: 'planting', type: 'status', value: 'planting', label: 'Menanam', order: 2, isActive: true, color: 0xFF2196F3),
      FarmOptionModel(id: 'growing', type: 'status', value: 'growing', label: 'Tumbuh', order: 3, isActive: true, color: 0xFF4CAF50),
      FarmOptionModel(id: 'harvesting', type: 'status', value: 'harvesting', label: 'Panen', order: 4, isActive: true, color: 0xFFFF9800),
      FarmOptionModel(id: 'harvested', type: 'status', value: 'harvested', label: 'Sudah Panen', order: 5, isActive: true, color: 0xFF8BC34A),
    ];
  }
}

