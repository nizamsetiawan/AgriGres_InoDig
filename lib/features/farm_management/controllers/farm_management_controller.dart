import 'package:get/get.dart';
import 'package:agrigres/data/repositories/farm_management/farm_repository.dart';
import 'package:agrigres/features/farm_management/models/farm_model.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class FarmManagementController extends GetxController {
  final FarmRepository _repository = Get.find<FarmRepository>();
  final UserController _userController = Get.find<UserController>();

  final farms = <FarmModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final searchQuery = ''.obs;
  final selectedStatus = ''.obs;

  // Status options
  final List<String> statusOptions = [
    'Semua',
    'preparing',
    'planting',
    'growing',
    'harvesting',
    'harvested',
  ];

  @override
  void onInit() {
    super.onInit();
    loadFarms();
  }

  /// Load user's farms
  Future<void> loadFarms() async {
    try {
      isLoading.value = true;
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        await _userController.fetchUserRecord();
      }
      final userIdFinal = _userController.user.value.id;
      if (userIdFinal.isEmpty) {
        TLoaders.warningSnackBar(
          title: 'Peringatan',
          message: 'User tidak ditemukan',
        );
        return;
      }
      final loadedFarms = await _repository.getUserFarms(userIdFinal);
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

  /// Get filtered farms based on search query and status
  List<FarmModel> get filteredFarms {
    var filtered = List<FarmModel>.from(farms);

    // Filter by status
    if (selectedStatus.value.isNotEmpty && selectedStatus.value != 'Semua') {
      filtered = filtered
          .where((farm) => farm.status == selectedStatus.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((farm) {
        return farm.farmName.toLowerCase().contains(query) ||
            farm.cropType.toLowerCase().contains(query) ||
            farm.location.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  /// Create farm
  Future<void> createFarm(FarmModel farm) async {
    try {
      isSaving.value = true;
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        await _userController.fetchUserRecord();
      }
      final farmWithUser = farm.copyWith(
        userId: _userController.user.value.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.createFarm(farmWithUser);
      await loadFarms();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Lahan berhasil ditambahkan',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating farm', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menambahkan lahan: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Update farm
  Future<void> updateFarm(FarmModel farm) async {
    try {
      isSaving.value = true;
      final updatedFarm = farm.copyWith(updatedAt: DateTime.now());
      await _repository.updateFarm(updatedFarm);
      await loadFarms();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Lahan berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating farm', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui lahan: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete farm
  Future<void> deleteFarm(String farmId) async {
    try {
      isSaving.value = true;
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
    } finally {
      isSaving.value = false;
    }
  }
}

