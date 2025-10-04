import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/monthly_food_price_model.dart';

class MonthlyDetailAgriInfoController extends GetxController {
  static MonthlyDetailAgriInfoController get instance => Get.find();

  // Filter states
  final RxInt selectedLevelHargaId = 1.obs; // Default: Produsen
  final RxString selectedRegion = 'Jawa Timur'.obs; // Disabled
  final RxString selectedCity = 'Kab. Gresik'.obs; // Disabled
  final RxInt startYear = 2024.obs;
  final RxInt endYear = 2025.obs;
  final Rx<DateTime> startDate = DateTime.now().subtract(const Duration(days: 1)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Data states
  final RxBool isLoading = false.obs;
  final RxMap<String, List<MonthlyFoodPriceModel>> monthlyData = <String, List<MonthlyFoodPriceModel>>{}.obs;
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
    // Set default years and dates
    final now = DateTime.now();
    startYear.value = now.year - 1;
    endYear.value = now.year;
    startDate.value = DateTime(now.year, now.month, now.day - 1);
    endDate.value = DateTime(now.year, now.month, now.day);
  }

  void selectLevelHarga(int levelId) {
    selectedLevelHargaId.value = levelId;
  }

  void setStartYear(int year) {
    startYear.value = year;
  }

  void setEndYear(int year) {
    endYear.value = year;
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  void clearAllFilters() {
    selectedLevelHargaId.value = 1;
    selectedRegion.value = 'Jawa Timur';
    selectedCity.value = 'Kab. Gresik';
    final now = DateTime.now();
    startYear.value = now.year - 1;
    endYear.value = now.year;
    startDate.value = DateTime(now.year, now.month, now.day - 1);
    endDate.value = DateTime(now.year, now.month, now.day);
    monthlyData.clear();
    errorMessage.value = '';
  }

  Future<void> fetchMonthlyFoodPriceData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format dates for API
      final startDateStr = _formatDate(startDate.value);
      final endDateStr = _formatDate(endDate.value);
      final periodDate = '$startDateStr - $endDateStr';

      // Build API URL
      final url = Uri.parse(
        'https://api-panelhargav2.badanpangan.go.id/api/front/harga-pangan-bulanan-v2?'
        'start_year=${startYear.value}&'
        'end_year=${endYear.value}&'
        'period_date=${Uri.encodeComponent(periodDate)}&'
        'province_id=15&'
        'level_harga_id=${selectedLevelHargaId.value}&'
        'city_id=250'
      );

      print('Fetching monthly data from: $url');

      // Make API request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final monthlyResponse = MonthlyFoodPriceResponse.fromJson(jsonData);
        
        monthlyData.assignAll(monthlyResponse.data);
        print('Successfully fetched monthly data for ${monthlyResponse.data.keys.length} years');
      } else {
        errorMessage.value = 'Gagal mengambil data: ${response.reasonPhrase}';
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      print('Error fetching monthly data: $e');
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

  List<MonthlyFoodPriceModel> get allCommodities {
    List<MonthlyFoodPriceModel> allCommodities = [];
    monthlyData.values.forEach((yearData) {
      allCommodities.addAll(yearData);
    });
    return allCommodities;
  }

  List<String> get availableYears {
    return monthlyData.keys.toList()..sort();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
