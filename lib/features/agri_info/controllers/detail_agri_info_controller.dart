import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/food_price_model.dart';
import 'package:agrigres/data/repositories/agri_info/level_harga_option_repository.dart';
import 'package:agrigres/utils/constraints/api_constants.dart';
import 'package:agrigres/utils/logging/logger.dart';

class DetailAgriInfoController extends GetxController {
  static DetailAgriInfoController get instance => Get.find();

  final LevelHargaOptionRepository _optionRepository = LevelHargaOptionRepository();

  // Filter states
  final RxInt selectedLevelHargaId = 0.obs; // Will be set after loading options
  final RxString selectedRegion = 'Nasional'.obs;
  final RxString selectedCity = 'Pilih Kab/kota'.obs;
  final Rx<DateTime> startDate = DateTime.now().subtract(const Duration(days: 1)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Data states
  final RxBool isLoading = false.obs;
  final RxList<FoodPriceModel> foodPriceData = <FoodPriceModel>[].obs;
  final RxString errorMessage = ''.obs;

  // Level harga options - now loaded from Firebase
  final RxList<Map<String, dynamic>> levelHargaOptions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLevelHargaOptions();
    // Set default dates to yesterday and today
    _updateDates();
  }

  /// Load level harga options from Firebase
  Future<void> loadLevelHargaOptions() async {
    try {
      final optionsList = await _optionRepository.getLevelHargaOptions();
      // Filter only valid level IDs (1, 2, 3) as API only accepts these
      final validOptions = optionsList
          .where((option) => option.levelId >= 1 && option.levelId <= 3)
          .map((option) => option.toControllerMap())
          .toList();
      
      levelHargaOptions.assignAll(validOptions);
      
      // Set default selected level if options loaded
      if (levelHargaOptions.isNotEmpty) {
        selectedLevelHargaId.value = levelHargaOptions.first['id'] as int;
        TLoggerHelper.info('Set default level harga ID to: ${selectedLevelHargaId.value}');
      } else {
        // Fallback to default if no valid options
        levelHargaOptions.assignAll([
          {'id': 1, 'name': 'Produsen'},
          {'id': 2, 'name': 'Pedagang Grosir'},
          {'id': 3, 'name': 'Konsumen'},
        ]);
        selectedLevelHargaId.value = 1;
        TLoggerHelper.warning('No valid level harga options found, using defaults');
      }
      TLoggerHelper.info('Loaded ${levelHargaOptions.length} valid level harga options from Firebase');
    } catch (e) {
      TLoggerHelper.error('Error loading level harga options', e);
      // Fallback to default options
      levelHargaOptions.assignAll([
        {'id': 1, 'name': 'Produsen'},
        {'id': 2, 'name': 'Pedagang Grosir'},
        {'id': 3, 'name': 'Konsumen'},
      ]);
      selectedLevelHargaId.value = 1;
    }
  }

  void _updateDates() {
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, now.day - 1); // Yesterday
    endDate.value = DateTime(now.year, now.month, now.day); // Today
  }

  void selectLevelHarga(int levelId) {
    selectedLevelHargaId.value = levelId;
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  void clearAllFilters() {
    // Reset to first available option or default
    if (levelHargaOptions.isNotEmpty) {
      selectedLevelHargaId.value = levelHargaOptions.first['id'] as int;
    } else {
      selectedLevelHargaId.value = 1;
    }
    selectedRegion.value = 'Nasional';
    selectedCity.value = 'Pilih Kab/kota';
    _updateDates();
    foodPriceData.clear();
    errorMessage.value = '';
  }

  Future<void> fetchFoodPriceData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate level_harga_id (API only accepts 1, 2, or 3)
      final levelId = selectedLevelHargaId.value;
      if (levelId < 1 || levelId > 3) {
        errorMessage.value = 'Level harga tidak valid. Harus antara 1-3.';
        TLoggerHelper.error('Invalid level_harga_id: $levelId. Must be between 1-3.', null);
        // Auto-fix: use first valid option or default to 1
        if (levelHargaOptions.isNotEmpty) {
          final validOption = levelHargaOptions.firstWhere(
            (opt) => (opt['id'] as int) >= 1 && (opt['id'] as int) <= 3,
            orElse: () => {'id': 1, 'name': 'Produsen'},
          );
          selectedLevelHargaId.value = validOption['id'] as int;
          TLoggerHelper.info('Auto-corrected level_harga_id to: ${selectedLevelHargaId.value}');
        } else {
          selectedLevelHargaId.value = 1;
        }
        isLoading.value = false;
        return;
      }

      // Format dates (for future use in API)
      // final startDateStr = _formatDate(startDate.value);
      // final endDateStr = _formatDate(endDate.value);

      // Build API URL
      final url = Uri.parse(
        '${APIConstants.agriInfoBaseUrl}/harga-pangan-informasi?'
        'province_id=&'
        'city_id=&'
        'level_harga_id=${selectedLevelHargaId.value}'
      );

      TLoggerHelper.debug('Fetching data from: $url');

      // Prepare headers with API key if available
      final headers = <String, String>{};
      if (APIConstants.badanPanganApiKey.isNotEmpty) {
        headers['X-Authorization'] = APIConstants.badanPanganApiKey;
        TLoggerHelper.debug('Using Badan Pangan API key for authentication');
      } else {
        TLoggerHelper.warning('Badan Pangan API key not configured. Request may fail.');
      }

      // Make API request
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final foodPriceResponse = FoodPriceResponse.fromJson(jsonData);
        
        foodPriceData.assignAll(foodPriceResponse.data);
        TLoggerHelper.info('Successfully fetched ${foodPriceResponse.data.length} items');
      } else {
        errorMessage.value = 'Gagal mengambil data: ${response.reasonPhrase}';
        TLoggerHelper.error('API Error: ${response.statusCode} - ${response.reasonPhrase}', null);
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      TLoggerHelper.error('Error fetching data', e);
    } finally {
      isLoading.value = false;
    }
  }

  String get selectedLevelHargaName {
    final option = levelHargaOptions.firstWhere(
      (option) => option['id'] == selectedLevelHargaId.value,
      orElse: () => levelHargaOptions.isNotEmpty ? levelHargaOptions.first : {'name': 'Produsen'},
    );
    return option['name'] as String;
  }
}
