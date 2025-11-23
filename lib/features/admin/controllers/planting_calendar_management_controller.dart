import 'package:get/get.dart';
import 'package:agrigres/data/repositories/planting_calendar/planting_calendar_repository.dart';
import 'package:agrigres/features/planting_calendar/models/planting_calendar_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';
import 'package:agrigres/features/admin/controllers/admin_auth_controller.dart';

class PlantingCalendarManagementController extends GetxController {
  final PlantingCalendarRepository _repository = Get.find<PlantingCalendarRepository>();

  final calendars = <PlantingCalendarModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final searchQuery = ''.obs;

  /// Get AdminAuthController (lazy access)
  AdminAuthController? get _adminAuthController {
    try {
      return Get.find<AdminAuthController>();
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCalendars();
  }

  /// Load all calendars
  Future<void> loadCalendars() async {
    try {
      isLoading.value = true;
      final loadedCalendars = await _repository.getAllPlantingCalendars();
      calendars.assignAll(loadedCalendars);
    } catch (e) {
      TLoggerHelper.error('Error loading calendars', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat kalender tanam: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered calendars based on search query
  List<PlantingCalendarModel> get filteredCalendars {
    if (searchQuery.value.isEmpty) {
      return calendars;
    }
    final query = searchQuery.value.toLowerCase();
    return List<PlantingCalendarModel>.from(calendars.where((calendar) {
      return calendar.cropName.toLowerCase().contains(query) ||
          calendar.cropType.toLowerCase().contains(query) ||
          calendar.location.toLowerCase().contains(query);
    }));
  }

  /// Create calendar
  Future<void> createCalendar(PlantingCalendarModel calendar) async {
    try {
      isSaving.value = true;
      final admin = _adminAuthController?.currentAdmin.value;
      final calendarWithCreator = calendar.copyWith(
        createdBy: admin?.email ?? admin?.name ?? 'Admin',
      );
      await _repository.createPlantingCalendar(calendarWithCreator);
      await loadCalendars();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kalender tanam berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating calendar', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat kalender tanam: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Update calendar
  Future<void> updateCalendar(PlantingCalendarModel calendar) async {
    try {
      isSaving.value = true;
      await _repository.updatePlantingCalendar(calendar);
      await loadCalendars();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kalender tanam berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating calendar', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui kalender tanam: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete calendar
  Future<void> deleteCalendar(String calendarId) async {
    try {
      isSaving.value = true;
      await _repository.deletePlantingCalendar(calendarId);
      await loadCalendars();
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kalender tanam berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting calendar', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus kalender tanam: ${e.toString()}',
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Toggle calendar active status
  Future<void> toggleCalendarStatus(PlantingCalendarModel calendar) async {
    try {
      final updated = calendar.copyWith(isActive: !calendar.isActive);
      await updateCalendar(updated);
    } catch (e) {
      TLoggerHelper.error('Error toggling calendar status', e);
    }
  }
}

