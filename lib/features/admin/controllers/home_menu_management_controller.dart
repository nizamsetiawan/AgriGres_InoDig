import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/models/home_menu_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class HomeMenuManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final menus = <HomeMenuModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMenus();
  }

  /// Load all home menus
  Future<void> loadMenus() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading home menus...');

      final snapshot = await _db.collection('HomeMenus').orderBy('order').get();

      menus.assignAll(
        snapshot.docs.map((doc) => HomeMenuModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${menus.length} home menus');
    } catch (e) {
      TLoggerHelper.error('Error loading home menus', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat menu: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered menus based on search query
  List<HomeMenuModel> get filteredMenus {
    if (searchQuery.value.isEmpty) {
      return menus;
    }
    final query = searchQuery.value.toLowerCase();
    return menus.where((menu) {
      return menu.title.toLowerCase().contains(query) ||
          menu.subtitle.toLowerCase().contains(query);
    }).toList();
  }

  /// Create menu
  Future<void> createMenu(HomeMenuModel menu) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Creating menu: ${menu.title}');

      await _db.collection('HomeMenus').add(menu.toJson());

      await loadMenus();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Menu berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating menu', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat menu: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update menu
  Future<void> updateMenu(String docId, HomeMenuModel menu) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Updating menu: $docId');

      await _db.collection('HomeMenus').doc(docId).update(menu.toJson());

      await loadMenus();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Menu berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating menu', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui menu: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete menu
  Future<void> deleteMenu(String docId) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Deleting menu: $docId');

      await _db.collection('HomeMenus').doc(docId).delete();

      await loadMenus();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Menu berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting menu', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus menu: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}

