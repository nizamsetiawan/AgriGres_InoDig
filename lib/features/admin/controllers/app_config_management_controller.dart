import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';
import 'package:agrigres/data/services/firebase_config_service.dart';

class AppConfigManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _configCollection = 'AppConfig';
  static const String _configDocId = 'api_config';

  final configData = <String, String>{}.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConfig();
  }

  /// Load AppConfig from Firestore
  Future<void> loadConfig() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading AppConfig...');

      final docSnapshot = await _db
          .collection(_configCollection)
          .doc(_configDocId)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        configData.clear();
        data.forEach((key, value) {
          if (value is String) {
            configData[key] = value;
          } else {
            configData[key] = value.toString();
          }
        });
        TLoggerHelper.info('Loaded ${configData.length} config keys');
      } else {
        // Initialize with empty if document doesn't exist
        configData.clear();
        TLoggerHelper.warning('AppConfig document not found');
      }
    } catch (e) {
      TLoggerHelper.error('Error loading AppConfig', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat konfigurasi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update AppConfig
  Future<void> updateConfig(Map<String, String> updatedConfig) async {
    try {
      isSaving.value = true;
      TLoggerHelper.info('Updating AppConfig...');

      await _db
          .collection(_configCollection)
          .doc(_configDocId)
          .set(updatedConfig, SetOptions(merge: true));

      configData.assignAll(updatedConfig);

      // Force refresh config service cache
      await FirebaseConfigService.instance.refreshConfig();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Konfigurasi berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating AppConfig', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui konfigurasi: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Add new config key
  void addConfigKey(String key, String value) {
    configData[key] = value;
  }

  /// Remove config key
  void removeConfigKey(String key) {
    configData.remove(key);
  }

  /// Update config key value
  void updateConfigKey(String key, String value) {
    configData[key] = value;
  }
}

