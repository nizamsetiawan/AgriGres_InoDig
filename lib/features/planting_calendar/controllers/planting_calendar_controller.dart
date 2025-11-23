import 'package:get/get.dart';
import 'package:agrigres/data/repositories/planting_calendar/planting_calendar_repository.dart';
import 'package:agrigres/features/planting_calendar/models/planting_calendar_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class PlantingCalendarController extends GetxController {
  final PlantingCalendarRepository _repository = Get.find<PlantingCalendarRepository>();

  final calendars = <PlantingCalendarModel>[].obs;
  final isLoading = false.obs;
  final selectedMonth = ''.obs;
  final selectedCropType = ''.obs;
  final searchQuery = ''.obs;

  // Month names in Indonesian
  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // Crop types
  final List<String> cropTypes = [
    'Padi',
    'Jagung',
    'Sayuran',
    'Buah-buahan',
    'Palawija',
    'Hortikultura',
    'Lainnya',
  ];

  @override
  void onInit() {
    super.onInit();
    loadPlantingCalendars();
    // Set current month as default
    final currentMonth = DateTime.now().month;
    selectedMonth.value = months[currentMonth - 1];
  }

  /// Load all active planting calendars
  Future<void> loadPlantingCalendars() async {
    try {
      isLoading.value = true;
      final loadedCalendars = await _repository.getActivePlantingCalendars();
      calendars.assignAll(loadedCalendars);
    } catch (e) {
      TLoggerHelper.error('Error loading planting calendars', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered calendars based on selected month, type, and search query
  List<PlantingCalendarModel> get filteredCalendars {
    var filtered = List<PlantingCalendarModel>.from(calendars);

    // Filter by month
    if (selectedMonth.value.isNotEmpty) {
      filtered = filtered
          .where((calendar) => calendar.plantingMonth == selectedMonth.value)
          .toList();
    }

    // Filter by crop type
    if (selectedCropType.value.isNotEmpty) {
      filtered = filtered
          .where((calendar) => calendar.cropType == selectedCropType.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((calendar) {
        return calendar.cropName.toLowerCase().contains(query) ||
            calendar.cropType.toLowerCase().contains(query) ||
            calendar.description.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  /// Get calendars for current month
  List<PlantingCalendarModel> get currentMonthCalendars {
    final currentMonth = DateTime.now().month;
    final monthName = months[currentMonth - 1];
    return List<PlantingCalendarModel>.from(
      calendars.where((calendar) => calendar.plantingMonth == monthName),
    );
  }

  /// Get calendars grouped by month
  Map<String, List<PlantingCalendarModel>> get calendarsByMonth {
    final grouped = <String, List<PlantingCalendarModel>>{};
    for (var calendar in calendars) {
      if (!grouped.containsKey(calendar.plantingMonth)) {
        grouped[calendar.plantingMonth] = [];
      }
      grouped[calendar.plantingMonth]!.add(calendar);
    }
    return grouped;
  }
}

