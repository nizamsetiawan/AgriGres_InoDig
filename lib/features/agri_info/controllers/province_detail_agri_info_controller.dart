import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/province_food_price_model.dart';
import 'package:agrigres/utils/constraints/api_constants.dart';
import 'package:agrigres/utils/logging/logger.dart';

class ProvinceDetailAgriInfoController extends GetxController {
  static ProvinceDetailAgriInfoController get instance => Get.find();

  // Filter states
  final RxInt selectedLevelHargaId = 1.obs; // Default: Produsen
  final Rx<DateTime> startDate = DateTime.now().subtract(const Duration(days: 1)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Data states
  final RxBool isLoading = false.obs;
  final RxList<ProvinceFoodPriceModel> provinceData = <ProvinceFoodPriceModel>[].obs;
  final RxList<GrandTotalModel> grandTotalData = <GrandTotalModel>[].obs;
  final RxString errorMessage = ''.obs;

  final List<Map<String, dynamic>> levelHargaOptions = [
    {'id': 1, 'name': 'Produsen'},
    {'id': 2, 'name': 'Pedagang Grosir'},
    {'id': 3, 'name': 'Konsumen'},
  ];

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch data on init
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
    startDate.value = DateTime.now().subtract(const Duration(days: 1));
    endDate.value = DateTime.now();
    provinceData.clear();
    grandTotalData.clear();
    errorMessage.value = '';
  }

  Future<void> fetchProvinceFoodPriceData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final startDateStr = _formatDate(startDate.value);
      final endDateStr = _formatDate(endDate.value);
      final periodDate = '$startDateStr - $endDateStr';

      final url = Uri.parse(
        '${APIConstants.agriInfoBaseUrl}/harga-pangan-table-province?'
        'province_id=${APIConstants.agriInfoDefaultProvinceId}&'
        'level_harga_id=${selectedLevelHargaId.value}&'
        'period_date=${Uri.encodeComponent(periodDate)}',
      );

      TLoggerHelper.debug('Fetching province data from: $url');
      final request = http.Request('GET', url);
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final List<dynamic> dataList = jsonResponse['data'];
          provinceData.assignAll(dataList.map((json) => ProvinceFoodPriceModel.fromJson(json)).toList());
          
          // Parse grand_total if available
          if (jsonResponse['grand_total'] != null) {
            final List<dynamic> grandTotalList = jsonResponse['grand_total'];
            grandTotalData.assignAll(grandTotalList.map((json) => GrandTotalModel.fromJson(json)).toList());
          }
          
          TLoggerHelper.info('Successfully fetched ${provinceData.length} provinces');
        } else {
          errorMessage.value = jsonResponse['message'] ?? 'Gagal mendapatkan data provinsi';
          TLoggerHelper.error('API Error: ${errorMessage.value}', null);
        }
      } else {
        errorMessage.value = 'Gagal memuat data provinsi: ${response.reasonPhrase}';
        TLoggerHelper.error('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}', null);
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      TLoggerHelper.error('Error fetching province data', e);
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

