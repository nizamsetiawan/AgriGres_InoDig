import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/utils/local_storage/storange_utility.dart';
import 'package:agrigres/utils/logging/logger.dart';

/// Service untuk mengambil konfigurasi dari Firebase Firestore
/// dengan fallback ke .env file dan caching di local storage
class FirebaseConfigService extends GetxController {
  static FirebaseConfigService get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TLocalStorage _localStorage = TLocalStorage();
  
  // Cache duration: 24 hours (dalam milliseconds)
  static const int _cacheDuration = 24 * 60 * 60 * 1000;
  static const String _cacheTimestampKey = 'firebase_config_timestamp';
  static const String _configCollection = 'AppConfig';
  static const String _configDocId = 'api_config';

  /// Map untuk menyimpan konfigurasi yang sudah di-fetch
  final Map<String, String> _configCache = {};

  /// Flag untuk menandai apakah config sudah di-load
  bool _isConfigLoaded = false;

  /// Initialize dan fetch config dari Firebase
  /// Returns true jika berhasil, false jika gagal (akan fallback ke .env)
  Future<bool> initialize() async {
    try {
      TLoggerHelper.info('Fetching configuration from Firebase...');
      
      // Cek apakah cache masih valid
      final cachedTimestamp = _localStorage.readData<int>(_cacheTimestampKey);
      final now = DateTime.now().millisecondsSinceEpoch;
      
      if (cachedTimestamp != null && 
          (now - cachedTimestamp) < _cacheDuration &&
          _configCache.isNotEmpty) {
        TLoggerHelper.info('Using cached Firebase configuration');
        _isConfigLoaded = true;
        return true;
      }

      // Fetch dari Firestore
      final docSnapshot = await _db
          .collection(_configCollection)
          .doc(_configDocId)
          .get();

      if (!docSnapshot.exists) {
        TLoggerHelper.warning('Firebase config document not found, using .env fallback');
        return false;
      }

      final data = docSnapshot.data();
      if (data == null) {
        TLoggerHelper.warning('Firebase config data is null, using .env fallback');
        return false;
      }

      // Simpan ke cache
      _configCache.clear();
      data.forEach((key, value) {
        if (value is String) {
          _configCache[key] = value;
        }
      });

      // Update cache timestamp
      await _localStorage.saveData(_cacheTimestampKey, now);
      _isConfigLoaded = true;

      TLoggerHelper.info('Firebase configuration loaded successfully (${_configCache.length} keys)');
      return true;

    } catch (e) {
      TLoggerHelper.error('Error fetching Firebase config', e);
      TLoggerHelper.info('Falling back to .env configuration');
      return false;
    }
  }

  /// Get config value dari Firebase
  /// Returns empty string jika tidak ditemukan (akan di-handle fallback di APIConstants)
  /// [firebaseKey] adalah key di Firestore
  String getConfigValue({
    required String firebaseKey,
    required String envKey,
    String defaultValue = '',
  }) {
    // Prioritaskan Firebase config jika sudah di-load dan ada di cache
    if (_isConfigLoaded && _configCache.containsKey(firebaseKey)) {
      final value = _configCache[firebaseKey]!;
      // Return value jika tidak kosong, jika kosong return empty string untuk fallback
      return value.isNotEmpty ? value : '';
    }

    // Return empty string untuk trigger fallback ke .env di APIConstants
    return '';
  }

  /// Force refresh config dari Firebase (bypass cache)
  Future<bool> refreshConfig() async {
    _isConfigLoaded = false;
    _configCache.clear();
    await _localStorage.removeData(_cacheTimestampKey);
    return await initialize();
  }

  /// Check apakah config sudah di-load dari Firebase
  bool get isConfigLoaded => _isConfigLoaded;

  /// Get semua config yang sudah di-cache
  Map<String, String> get cachedConfig => Map.unmodifiable(_configCache);
}

