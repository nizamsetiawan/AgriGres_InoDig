import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/table_food_price_model.dart';

class TableDetailAgriInfoController extends GetxController {
  static TableDetailAgriInfoController get instance => Get.find();

  // Filter states
  final RxInt selectedLevelHargaId = 1.obs; // Default: Produsen
  final Rx<DateTime> startDate = DateTime.now().subtract(const Duration(days: 3)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Data states
  final RxBool isLoading = false.obs;
  final RxList<TableFoodPriceModel> tableData = <TableFoodPriceModel>[].obs;
  final RxString errorMessage = ''.obs;
  final Rx<TableFoodPriceResponse?> responseData = Rx<TableFoodPriceResponse?>(null);

  final List<Map<String, dynamic>> levelHargaOptions = [
    {'id': 1, 'name': 'Produsen'},
    {'id': 2, 'name': 'Pedagang Grosir'},
    {'id': 3, 'name': 'Konsumen'},
  ];

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, now.day - 3);
    endDate.value = DateTime(now.year, now.month, now.day);
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
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, now.day - 3);
    endDate.value = DateTime(now.year, now.month, now.day);
    tableData.clear();
    errorMessage.value = '';
    responseData.value = null;
  }

  Future<void> fetchTableFoodPriceData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format dates for API
      final startDateStr = _formatDate(startDate.value);
      final endDateStr = _formatDate(endDate.value);
      final periodDate = '$startDateStr - $endDateStr';

      // Build API URL
      final url = Uri.parse(
        'https://api-panelhargav2.badanpangan.go.id/api/front/harga-pangan-table-v2?'
        'period_date=${Uri.encodeComponent(periodDate)}&'
        'level_harga_id=${selectedLevelHargaId.value}&'
        'province_id=15&' // Jawa Timur
        'city_id=250', // Kab. Gresik
      );

      print('Fetching table data from: $url');
      final request = http.Request('GET', url);
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final tableResponse = TableFoodPriceResponse.fromJson(jsonResponse);
          responseData.value = tableResponse;
          tableData.assignAll(tableResponse.data);
          print('Successfully fetched ${tableData.length} commodities');
        } else {
          errorMessage.value = jsonResponse['message'] ?? 'Gagal mendapatkan data tabel';
          print('API Error: ${errorMessage.value}');
        }
      } else {
        errorMessage.value = 'Gagal memuat data tabel: ${response.reasonPhrase}';
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      print('Error fetching table data: $e');
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
