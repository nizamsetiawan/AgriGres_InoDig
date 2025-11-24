import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/models/agri_info_model.dart';
import 'package:agrigres/features/agri_info/screens/lahan_screen.dart';
import 'package:agrigres/features/agri_info/screens/sawah_screen.dart';
import 'package:agrigres/features/agri_info/screens/dinas_pertanian_dataset_detail_screen.dart';
import 'package:agrigres/utils/logging/logger.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/data/repositories/agri_info/dinas_pertanian_repository.dart';
import 'package:agrigres/features/agri_info/models/dinas_pertanian_dataset_model.dart';

class AgriInfoController extends GetxController {
  static AgriInfoController get instance => Get.find();

  final RxBool isLoading = false.obs;
  final DinasPertanianRepository _repository = Get.find();
  final RxList<DinasPertanianDatasetModel> datasetList =
      <DinasPertanianDatasetModel>[].obs;
  final RxList<AgriInfoModel> agriInfoList = <AgriInfoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgriInfoList();
  }

  Future<void> fetchAgriInfoList() async {
    try {
      isLoading.value = true;
      final datasets = await _repository.fetchDatasets();
      datasetList.assignAll(datasets);

      final agriInfoItems = datasets
          .map(
            (dataset) => AgriInfoModel(
              id: dataset.datasetId,
              title: dataset.title,
              source: 'Dinas Pertanian Gresik',
              identity: dataset.identity,
              resourceCount: dataset.resources.length,
              iconType: _mapIconType(dataset.title),
            ),
          )
          .toList();

      // Append existing lahan & sawah utilities
      agriInfoItems.addAll([
        AgriInfoModel(
          id: 'LAHAN',
          title: 'Luas Penggunaan Lahan menurut Desa/Kelurahan di Kecamatan (Ha)',
          source: 'Satu Data Gresik',
          iconType: AgriInfoIconType.landUse,
        ),
        AgriInfoModel(
          id: 'SAWAH',
          title: 'Luas Penggunaan Lahan Sawah menurut Desa/Kelurahan di Kecamatan (Ha)',
          source: 'Satu Data Gresik',
          iconType: AgriInfoIconType.landUse,
        ),
      ]);

      agriInfoList.assignAll(agriInfoItems);
    } catch (e) {
      TLoggerHelper.error('Error fetching agri info', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat data pertanian Gresik',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetail(String agriInfoId) {
    TLoggerHelper.debug('Navigate to detail: $agriInfoId');
    
    switch (agriInfoId) {
      case 'LAHAN':
        Get.to(() => const LahanScreen());
        break;
      case 'SAWAH':
        Get.to(() => const SawahScreen());
        break;
      default:
        final dataset = _findDatasetById(agriInfoId);
        if (dataset == null) {
          TLoaders.warningSnackBar(
            title: 'Info',
            message: 'Dataset tidak ditemukan',
          );
          return;
        }
        Get.to(
          () => DinasPertanianDatasetDetailScreen(dataset: dataset),
        );
    }
  }

  DinasPertanianDatasetModel? _findDatasetById(String id) {
    try {
      return datasetList.firstWhere((dataset) => dataset.datasetId == id);
    } catch (_) {
      return null;
    }
  }

  AgriInfoIconType _mapIconType(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('lahan') || lowerTitle.contains('sawah')) {
      return AgriInfoIconType.landUse;
    }

    if (lowerTitle.contains('produksi') ||
        lowerTitle.contains('tanaman') ||
        lowerTitle.contains('perkebunan')) {
      return AgriInfoIconType.plantation;
    }

    return AgriInfoIconType.foodPrice;
  }
}
