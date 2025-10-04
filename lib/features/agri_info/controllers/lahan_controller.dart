import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/lahan_model.dart';

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
        'https://satudata.gresikkab.go.id/api/3/action/datastore_search?resource_id=919459eb-413b-11f0-8b48-005056016148'
      );

      print('Fetching lahan data from: $url');

      final headers = {
        'Cookie': 'cookie-satudata_2024=sg6l3o4jqu0ie91ii0p7912rc8sdm515'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final lahanModel = LahanModel.fromJson(jsonData);
        
        if (lahanModel.success) {
          lahanData.value = lahanModel;
          print('Successfully fetched ${lahanModel.result.records.length} lahan records');
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
