import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrigres/features/agri_info/models/level_harga_option_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class LevelHargaOptionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get level harga options
  Future<List<LevelHargaOptionModel>> getLevelHargaOptions() async {
    try {
      TLoggerHelper.info('Fetching level harga options from Firebase...');

      final snapshot = await _db
          .collection('LevelHargaOptions')
          .where('is_active', isEqualTo: true)
          .orderBy('order')
          .get();

      final options = snapshot.docs
          .map((doc) => LevelHargaOptionModel.fromSnapshot(doc))
          .where((option) => option.name.isNotEmpty && option.levelId > 0)
          .toList();

      TLoggerHelper.info('Loaded ${options.length} level harga options from Firebase');

      // If no options found, return default
      if (options.isEmpty) {
        return _getDefaultOptions();
      }

      return options;
    } catch (e) {
      TLoggerHelper.error('Error fetching level harga options from Firebase', e);
      // Return default options on error
      return _getDefaultOptions();
    }
  }

  /// Get default options (fallback)
  List<LevelHargaOptionModel> _getDefaultOptions() {
    TLoggerHelper.info('Using default level harga options');
    return [
      LevelHargaOptionModel(id: 'produsen', levelId: 1, name: 'Produsen', order: 1, isActive: true),
      LevelHargaOptionModel(id: 'grosir', levelId: 2, name: 'Pedagang Grosir', order: 2, isActive: true),
      LevelHargaOptionModel(id: 'konsumen', levelId: 3, name: 'Konsumen', order: 3, isActive: true),
    ];
  }
}

