import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/food_price_model.dart';

class DetailAgriInfoController extends GetxController {
  static DetailAgriInfoController get instance => Get.find();

  // Filter states
  final RxInt selectedLevelHargaId = 1.obs; // Default: Produsen
  final RxString selectedRegion = 'Nasional'.obs;
  final RxString selectedCity = 'Pilih Kab/kota'.obs;
  final Rx<DateTime> startDate = DateTime.now().subtract(const Duration(days: 1)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Data states
  final RxBool isLoading = false.obs;
  final RxList<FoodPriceModel> foodPriceData = <FoodPriceModel>[].obs;
  final RxString errorMessage = ''.obs;

  // Level harga options
  final List<Map<String, dynamic>> levelHargaOptions = [
    {'id': 1, 'name': 'Produsen'},
    {'id': 2, 'name': 'Pedagang Grosir'},
    {'id': 3, 'name': 'Konsumen'},
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default dates to yesterday and today
    _updateDates();
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
    selectedLevelHargaId.value = 1;
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

      // Format dates (for future use in API)
      // final startDateStr = _formatDate(startDate.value);
      // final endDateStr = _formatDate(endDate.value);

      // Build API URL
      final url = Uri.parse(
        'https://api-panelhargav2.badanpangan.go.id/api/front/harga-pangan-informasi?'
        'province_id=&'
        'city_id=&'
        'level_harga_id=${selectedLevelHargaId.value}'
      );

      print('Fetching data from: $url');

      // Make API request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final foodPriceResponse = FoodPriceResponse.fromJson(jsonData);
        
        foodPriceData.assignAll(foodPriceResponse.data);
        print('Successfully fetched ${foodPriceResponse.data.length} items');
      } else {
        errorMessage.value = 'Gagal mengambil data: ${response.reasonPhrase}';
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get selectedLevelHargaName {
    final option = levelHargaOptions.firstWhere(
      (option) => option['id'] == selectedLevelHargaId.value,
      orElse: () => {'name': 'Produsen'},
    );
    return option['name'];
  }
}
