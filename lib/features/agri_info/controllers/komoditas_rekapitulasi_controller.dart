import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrigres/features/agri_info/models/komoditas_rekapitulasi_model.dart';

class KomoditasRekapitulasiController extends GetxController {
  static KomoditasRekapitulasiController get instance => Get.find();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<KomoditasRekapitulasiData> komoditasData = <KomoditasRekapitulasiData>[].obs;
  final RxInt rataRataProvinsi = 0.obs;
  final RxBool isRefreshing = false.obs;

  // Filter states
  final RxInt selectedLevelHargaId = 1.obs; // Default: Produsen
  final RxInt selectedKomoditasId = 5.obs; // Default: Beras Medium Penggilingan
  final Rx<DateTime> startDate = DateTime.now().subtract(const Duration(days: 7)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Level harga options
  final List<Map<String, dynamic>> levelHargaOptions = [
    {'id': 1, 'name': 'Produsen'},
    {'id': 2, 'name': 'Pedagang Grosir'},
    {'id': 3, 'name': 'Konsumen'},
  ];

  // Komoditas options
  final List<Map<String, dynamic>> komoditasOptions = [
    {'id': 1, 'name': 'Luas Panen Padi'},
    {'id': 2, 'name': 'GKP Tingkat Petani'},
    {'id': 3, 'name': 'GKP Tingkat Penggilingan'},
    {'id': 4, 'name': 'GKG Tingkat Penggilingan'},
    {'id': 5, 'name': 'Beras Medium Penggilingan'},
    {'id': 6, 'name': 'Beras Premium Penggilingan'},
    {'id': 7, 'name': 'Jagung Pipilan Kering'},
    {'id': 8, 'name': 'Kedelai Biji Kering (Lokal)'},
    {'id': 9, 'name': 'Bawang Merah'},
    {'id': 10, 'name': 'Cabai Merah Keriting'},
    {'id': 11, 'name': 'Cabai Merah Besar'},
    {'id': 12, 'name': 'Cabai Rawit Merah'},
    {'id': 13, 'name': 'Sapi (Hidup)'},
    {'id': 14, 'name': 'Ayam Ras Pedaging (Hidup)'},
    {'id': 15, 'name': 'Telur Ayam Ras'},
    {'id': 16, 'name': 'Stok GKG Tingkat Penggilingan'},
    {'id': 17, 'name': 'Stok Beras Tingkat Penggilingan'},
    {'id': 18, 'name': 'Gula Konsumsi di Petani/Pabrik Gula'},
  ];

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch data on init
  }

  void selectLevelHarga(int id) {
    selectedLevelHargaId.value = id;
  }

  void selectKomoditas(int id) {
    selectedKomoditasId.value = id;
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  String get selectedLevelHargaName {
    final option = levelHargaOptions.firstWhere(
      (option) => option['id'] == selectedLevelHargaId.value,
      orElse: () => {'name': 'Produsen'},
    );
    return option['name'];
  }

  String get selectedKomoditasName {
    final option = komoditasOptions.firstWhere(
      (option) => option['id'] == selectedKomoditasId.value,
      orElse: () => {'name': 'Beras Medium Penggilingan'},
    );
    return option['name'];
  }

  void clearAllFilters() {
    selectedLevelHargaId.value = 1;
    selectedKomoditasId.value = 5;
    startDate.value = DateTime.now().subtract(const Duration(days: 7));
    endDate.value = DateTime.now();
    komoditasData.clear();
    rataRataProvinsi.value = 0;
    errorMessage.value = '';
  }

  Future<void> fetchKomoditasRekapitulasiData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final startDateStr = _formatDate(startDate.value);
      final endDateStr = _formatDate(endDate.value);
      final periodDate = '$startDateStr - $endDateStr';

      final url = Uri.parse(
        'https://api-panelhargav2.badanpangan.go.id/api/front/table-rekapitulasi-komoditas'
        '?period_date=${Uri.encodeComponent(periodDate)}'
        '&level_harga_id=${selectedLevelHargaId.value}'
        '&province_id=15'
        '&komoditas_id=${selectedKomoditasId.value}'
      );

      print('Fetching komoditas rekapitulasi data from: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final komoditasModel = KomoditasRekapitulasiModel.fromJson(jsonData);
        
        if (komoditasModel.status == 'success') {
          komoditasData.value = komoditasModel.data;
          rataRataProvinsi.value = komoditasModel.rataRataProvinsi;
          print('Successfully fetched ${komoditasData.length} komoditas rekapitulasi items');
        } else {
          errorMessage.value = komoditasModel.message;
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
