import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/lahan_model.dart';
import 'package:agrigres/utils/constraints/api_constants.dart';
import 'package:agrigres/utils/logging/logger.dart';

class LahanController extends GetxController {
  static LahanController get instance => Get.find();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<LahanModel?> lahanData = Rx<LahanModel?>(null);
  final RxBool isRefreshing = false.obs;

  // Filter states
  final RxString selectedKecamatan = ''.obs;
  final RxString selectedDesaKelurahan = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-fetch data on init
    fetchLahanData();
  }

  void selectKecamatan(String kecamatan) {
    selectedKecamatan.value = kecamatan;
    // Reset desa/kelurahan when kecamatan changes
    selectedDesaKelurahan.value = '';
  }

  void selectDesaKelurahan(String desaKelurahan) {
    selectedDesaKelurahan.value = desaKelurahan;
  }

  void clearAllFilters() {
    selectedKecamatan.value = '';
    selectedDesaKelurahan.value = '';
    lahanData.value = null;
    errorMessage.value = '';
  }

  List<LahanRecord> get filteredRecords {
    if (lahanData.value?.result.records == null) return [];
    
    var records = lahanData.value!.result.records;
    
    // Filter by kecamatan
    if (selectedKecamatan.value.isNotEmpty) {
      records = records.where((record) {
        return record.kecamatan == selectedKecamatan.value;
      }).toList();
    }
    
    // Filter by desa/kelurahan
    if (selectedDesaKelurahan.value.isNotEmpty) {
      records = records.where((record) {
        return record.desaKelurahan == selectedDesaKelurahan.value;
      }).toList();
    }
    
    return records;
  }

  List<String> get kecamatanOptions {
    if (lahanData.value?.result.records == null) return [];
    
    final kecamatans = lahanData.value!.result.records
        .map((record) => record.kecamatan)
        .toSet()
        .toList();
    
    kecamatans.sort();
    return kecamatans;
  }

  List<String> get desaKelurahanOptions {
    if (lahanData.value?.result.records == null) return [];
    
    var records = lahanData.value!.result.records;
    
    // Filter by selected kecamatan first
    if (selectedKecamatan.value.isNotEmpty) {
      records = records.where((record) {
        return record.kecamatan == selectedKecamatan.value;
      }).toList();
    }
    
    final desaKelurahans = records
        .map((record) => record.desaKelurahan)
        .toSet()
        .toList();
    
    desaKelurahans.sort();
    return desaKelurahans;
  }

  Future<void> fetchLahanData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(
        '${APIConstants.satuDataBaseUrl}/datastore_search?resource_id=${APIConstants.satuDataLahanResourceId}'
      );

      TLoggerHelper.debug('Fetching lahan data from: $url');

      final headers = {
        'Cookie': APIConstants.satuDataCookieLahan
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final lahanModel = LahanModel.fromJson(jsonData);
        
        if (lahanModel.success) {
          lahanData.value = lahanModel;
          TLoggerHelper.info('Successfully fetched ${lahanModel.result.records.length} lahan records');
        } else {
          errorMessage.value = 'Gagal mengambil data dari server';
        }
      } else {
        errorMessage.value = 'Gagal mengambil data: ${response.statusCode}';
        TLoggerHelper.error('Error: ${response.statusCode} - ${response.body}', null);
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      TLoggerHelper.error('Exception', e);
    } finally {
      isLoading.value = false;
    }
  }
}
