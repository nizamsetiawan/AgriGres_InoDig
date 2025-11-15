import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/table_food_price_model.dart';
import 'package:agrigres/utils/constraints/api_constants.dart';
import 'package:agrigres/utils/logging/logger.dart';

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
        '${APIConstants.agriInfoBaseUrl}/harga-pangan-table-v2?'
        'period_date=${Uri.encodeComponent(periodDate)}&'
        'level_harga_id=${selectedLevelHargaId.value}&'
        'province_id=${APIConstants.agriInfoDefaultProvinceId}&'
        'city_id=${APIConstants.agriInfoDefaultCityId}',
      );

      TLoggerHelper.debug('Fetching table data from: $url');
      final request = http.Request('GET', url);
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final tableResponse = TableFoodPriceResponse.fromJson(jsonResponse);
          responseData.value = tableResponse;
          tableData.assignAll(tableResponse.data);
          TLoggerHelper.info('Successfully fetched ${tableData.length} commodities');
        } else {
          errorMessage.value = jsonResponse['message'] ?? 'Gagal mendapatkan data tabel';
          TLoggerHelper.error('API Error: ${errorMessage.value}', null);
        }
      } else {
        errorMessage.value = 'Gagal memuat data tabel: ${response.reasonPhrase}';
        TLoggerHelper.error('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}', null);
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      TLoggerHelper.error('Error fetching table data', e);
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
