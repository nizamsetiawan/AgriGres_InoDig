import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrigres/features/planting_calendar/models/planting_calendar_option_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class PlantingCalendarOptionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get crop types
  Future<List<PlantingCalendarOptionModel>> getCropTypes() async {
    try {
      TLoggerHelper.info('Fetching planting calendar crop types from Firebase...');

      final snapshot = await _db
          .collection('PlantingCalendarOptions')
          .where('is_active', isEqualTo: true)
          .orderBy('order')
          .get();

      final cropTypes = snapshot.docs
          .map((doc) => PlantingCalendarOptionModel.fromSnapshot(doc))
          .where((option) => option.value.isNotEmpty)
          .toList();

      TLoggerHelper.info('Loaded ${cropTypes.length} planting calendar crop types from Firebase');

      // If no crop types found, return default
      if (cropTypes.isEmpty) {
        return _getDefaultCropTypes();
      }

      return cropTypes;
    } catch (e) {
      TLoggerHelper.error('Error fetching planting calendar crop types from Firebase', e);
      // Return default crop types on error
      return _getDefaultCropTypes();
    }
  }

  /// Get default crop types (fallback)
  List<PlantingCalendarOptionModel> _getDefaultCropTypes() {
    TLoggerHelper.info('Using default planting calendar crop types');
    return [
      PlantingCalendarOptionModel(id: 'padi', value: 'Padi', label: 'Padi', order: 1, isActive: true),
      PlantingCalendarOptionModel(id: 'jagung', value: 'Jagung', label: 'Jagung', order: 2, isActive: true),
      PlantingCalendarOptionModel(id: 'sayuran', value: 'Sayuran', label: 'Sayuran', order: 3, isActive: true),
      PlantingCalendarOptionModel(id: 'buah', value: 'Buah-buahan', label: 'Buah-buahan', order: 4, isActive: true),
      PlantingCalendarOptionModel(id: 'palawija', value: 'Palawija', label: 'Palawija', order: 5, isActive: true),
      PlantingCalendarOptionModel(id: 'hortikultura', value: 'Hortikultura', label: 'Hortikultura', order: 6, isActive: true),
      PlantingCalendarOptionModel(id: 'lainnya', value: 'Lainnya', label: 'Lainnya', order: 7, isActive: true),
    ];
  }
}

