import 'package:get/get.dart';
import 'package:agrigres/data/repositories/farm_management/farm_repository.dart';
import 'package:agrigres/features/farm_management/models/farm_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class FarmsManagementController extends GetxController {
  final FarmRepository _repository = Get.find<FarmRepository>();

  final farms = <FarmModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFarms();
  }

  /// Load all farms
  Future<void> loadFarms() async {
    try {
      isLoading.value = true;
      final loadedFarms = await _repository.getAllFarms();
      farms.assignAll(loadedFarms);
    } catch (e) {
      TLoggerHelper.error('Error loading farms', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat data lahan: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered farms based on search query
  List<FarmModel> get filteredFarms {
    if (searchQuery.value.isEmpty) {
      return farms;
    }
    final query = searchQuery.value.toLowerCase();
    return List<FarmModel>.from(farms.where((farm) {
      return farm.farmName.toLowerCase().contains(query) ||
          farm.cropType.toLowerCase().contains(query) ||
          farm.location.toLowerCase().contains(query) ||
          farm.userId.toLowerCase().contains(query);
    }));
  }

  /// Delete farm
  Future<void> deleteFarm(String farmId) async {
    try {
      await _repository.deleteFarm(farmId);
      await loadFarms();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Lahan berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting farm', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus lahan: ${e.toString()}',
      );
    }
  }
}

