import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/models/agri_info_model.dart';
import 'package:agrigres/features/agri_info/screens/detail_agri_info_screen.dart';

class AgriInfoController extends GetxController {
  static AgriInfoController get instance => Get.find();

  final RxBool isLoading = false.obs;
  final RxList<AgriInfoModel> agriInfoList = <AgriInfoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgriInfoList();
  }

  Future<void> fetchAgriInfoList() async {
    try {
      isLoading.value = true;
      
      // No delay needed for hardcoded data
      final agriInfoItems = [
        AgriInfoModel(
          id: '1',
          title: 'Informasi Harga Pangan Strategis',
          source: 'Sumber: Badan Pangan Nasional',
          iconType: AgriInfoIconType.foodPrice,
        ),
        AgriInfoModel(
          id: '2',
          title: 'Infografis Harga Pangan',
          source: 'Sumber: Badan Pangan Nasional',
          iconType: AgriInfoIconType.foodPrice,
        ),
        AgriInfoModel(
          id: '3',
          title: 'Tabel Harga Pangan Antar Waktu',
          source: 'Sumber: Badan Pangan Nasional',
          iconType: AgriInfoIconType.foodPrice,
        ),
        AgriInfoModel(
          id: '4',
          title: 'Tabel Harga Pangan Antar Wilayah',
          source: 'Sumber: Badan Pangan Nasional',
          iconType: AgriInfoIconType.foodPrice,
        ),
        AgriInfoModel(
          id: '5',
          title: 'Tabel Perkembangan Harga',
          source: 'Sumber: Badan Pangan Nasional',
          iconType: AgriInfoIconType.foodPrice,
        ),
        AgriInfoModel(
          id: '6',
          title: 'Tabel Perkembangan Harga Komoditas',
          source: 'Sumber: Badan Pangan Nasional',
          iconType: AgriInfoIconType.foodPrice,
        ),
        AgriInfoModel(
          id: '7',
          title: 'Luas Penggunaan Lahan menurut Desa/Kelurahan di Kecamatan (Ha)',
          source: 'Sumber: Satu Data Gresik',
          iconType: AgriInfoIconType.landUse,
        ),
        AgriInfoModel(
          id: '8',
          title: 'Luas Penggunaan Lahan Sawah menurut Desa/Kelurahan di Kecamatan (Ha)',
          source: 'Sumber: Satu Data Gresik',
          iconType: AgriInfoIconType.landUse,
        ),
      ];
      
      agriInfoList.assignAll(agriInfoItems);
      
    } catch (e) {
      // Handle error
      print('Error fetching agri info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetail(String agriInfoId) {
    print('Navigate to detail: $agriInfoId');
    
    // Navigate to detail screen based on agriInfoId
    switch (agriInfoId) {
      case '1': // Informasi Harga Pangan Strategis
        Get.to(() => const DetailAgriInfoScreen());
        break;
      default:
        Get.snackbar(
          'Info',
          'Fitur ini sedang dalam pengembangan',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }
}
