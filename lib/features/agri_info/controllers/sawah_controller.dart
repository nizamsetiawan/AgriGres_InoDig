import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/sawah_model.dart';

class SawahController extends GetxController {
  static SawahController get instance => Get.find();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<SawahModel?> sawahData = Rx<SawahModel?>(null);
  final RxBool isRefreshing = false.obs;

  // Filter states
  final RxString selectedKecamatan = ''.obs;
  final RxString selectedDesaKelurahan = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-fetch data on init
    fetchSawahData();
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
    sawahData.value = null;
    errorMessage.value = '';
  }

  List<SawahRecord> get filteredRecords {
    if (sawahData.value?.result.records == null) return [];
    
    var records = sawahData.value!.result.records;
    
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
    if (sawahData.value?.result.records == null) return [];
    
    final kecamatans = sawahData.value!.result.records
        .map((record) => record.kecamatan)
        .toSet()
        .toList();
    
    kecamatans.sort();
    return kecamatans;
  }

  List<String> get desaKelurahanOptions {
    if (sawahData.value?.result.records == null) return [];
    
    var records = sawahData.value!.result.records;
    
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

  Future<void> fetchSawahData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(
        'https://satudata.gresikkab.go.id/api/3/action/datastore_search?resource_id=6558d003-413c-11f0-8b48-005056016148'
      );

      print('Fetching sawah data from: $url');

      final headers = {
        'Cookie': 'cookie-satudata_2024=u9528obkpk99sg3sa6b23psaln6ma26f'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final sawahModel = SawahModel.fromJson(jsonData);
        
        if (sawahModel.success) {
          sawahData.value = sawahModel;
          print('Successfully fetched ${sawahModel.result.records.length} sawah records');
        } else {
          errorMessage.value = 'Gagal mengambil data dari server';
        }
      } else {
        errorMessage.value = 'Gagal mengambil data: ${response.statusCode}';
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      print('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
