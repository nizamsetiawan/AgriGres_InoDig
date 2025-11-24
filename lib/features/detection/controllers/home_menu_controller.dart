import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/models/home_menu_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class HomeMenuController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final menus = <HomeMenuModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMenus();
  }

  /// Load all home menus from Firebase
  Future<void> loadMenus() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading home menus from Firebase...');

      final snapshot = await _db
          .collection('HomeMenus')
          .where('is_active', isEqualTo: true)
          .orderBy('order')
          .get();

      final loadedMenus = snapshot.docs
          .map((doc) => HomeMenuModel.fromSnapshot(doc))
          .where((menu) => menu.title.isNotEmpty && menu.route.isNotEmpty)
          .toList();

      menus.assignAll(loadedMenus.take(6).toList());
      TLoggerHelper.info('Loaded ${menus.length} home menus from Firebase');

      // If no menus found, use default
      if (menus.isEmpty) {
        _loadDefaultMenus();
      }
    } catch (e) {
      TLoggerHelper.error('Error loading home menus from Firebase', e);
      // Fallback to default menus
      _loadDefaultMenus();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load default menus (fallback)
  void _loadDefaultMenus() {
    TLoggerHelper.info('Using default home menus');
    menus.assignAll([
      HomeMenuModel(
        id: 'agri_info',
        title: 'AgriInfo',
        subtitle: 'Informasi harga pangan harian',
        route: '/agri-info',
        iconName: 'info_outline',
        backgroundColor: 0xFFBBDEFB, // Colors.blue[100]!
        iconColor: 0xFF1976D2, // Colors.blue[600]!
        order: 1,
        isActive: true,
      ),
      HomeMenuModel(
        id: 'agri_edu',
        title: 'AgriEdu',
        subtitle: 'Sekolah tani digital',
        route: '/agri-edu',
        iconName: 'school_outlined',
        backgroundColor: 0xFFFFE0B2, // Colors.orange[100]!
        iconColor: 0xFFF57C00, // Colors.orange[600]!
        order: 2,
        isActive: true,
      ),
      HomeMenuModel(
        id: 'agri_care',
        title: 'AgriCare',
        subtitle: 'Deteksi hama dan penyakit',
        route: '/agri-care',
        iconName: 'health_and_safety_outlined',
        backgroundColor: 0xFFC8E6C9, // Colors.green[100]!
        iconColor: 0xFF388E3C, // Colors.green[600]!
        order: 3,
        isActive: true,
      ),
      HomeMenuModel(
        id: 'agri_mart',
        title: 'AgriMart',
        subtitle: 'Marketplace pertanian',
        route: '/agri-mart',
        iconName: 'store_outlined',
        backgroundColor: 0xFFF8BBD0, // Colors.pink[100]!
        iconColor: 0xFFC2185B, // Colors.pink[600]!
        order: 4,
        isActive: true,
      ),
      HomeMenuModel(
        id: 'planting_calendar',
        title: 'AgriKalender',
        subtitle: 'Rencana tanam ringkas',
        route: '/planting-calendar',
        iconName: 'calendar_today_outlined',
        backgroundColor: 0xFFB2DFDB, // Colors.teal[100]!
        iconColor: 0xFF00796B, // Colors.teal[600]!
        order: 5,
        isActive: true,
      ),
      HomeMenuModel(
        id: 'farm_management',
        title: 'AgriLahan',
        subtitle: 'Kelola lahan pertanian',
        route: '/farm-management',
        iconName: 'agriculture_outlined',
        backgroundColor: 0xFFD7CCC8, // Colors.brown[100]!
        iconColor: 0xFF5D4037, // Colors.brown[600]!
        order: 6,
        isActive: true,
      ),
    ]);
  }
}

