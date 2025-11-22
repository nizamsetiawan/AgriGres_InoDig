import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/models/banner_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class BannersManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final banners = <BannerModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBanners();
  }

  /// Load all banners
  Future<void> loadBanners() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading banners...');

      final snapshot = await _db.collection('Banners').get();

      banners.assignAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          return BannerModel(
            id: doc.id,
            imageUrl: data['ImageUrl'] ?? '',
            targetScreen: data['TargetScreen'] ?? '',
            active: data['Active'] ?? false,
          );
        }).toList(),
      );

      TLoggerHelper.info('Loaded ${banners.length} banners');
    } catch (e) {
      TLoggerHelper.error('Error loading banners', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat banner: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered banners based on search query
  List<BannerModel> get filteredBanners {
    if (searchQuery.value.isEmpty) {
      return banners;
    }
    return banners.where((banner) {
      final query = searchQuery.value.toLowerCase();
      return banner.targetScreen.toLowerCase().contains(query) ||
          banner.imageUrl.toLowerCase().contains(query);
    }).toList();
  }

  /// Create banner
  Future<void> createBanner(BannerModel banner) async {
    try {
      TLoggerHelper.info('Creating banner');

      final docRef = await _db.collection('Banners').add(banner.toJson());

      final createdBanner = BannerModel(
        id: docRef.id,
        imageUrl: banner.imageUrl,
        targetScreen: banner.targetScreen,
        active: banner.active,
      );

      banners.add(createdBanner);

      await loadBanners();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Banner berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating banner', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat banner: ${e.toString()}',
      );
    }
  }

  /// Update banner
  Future<void> updateBanner(String docId, BannerModel banner) async {
    try {
      TLoggerHelper.info('Updating banner: $docId');

      final updatedBanner = BannerModel(
        id: docId,
        imageUrl: banner.imageUrl,
        targetScreen: banner.targetScreen,
        active: banner.active,
      );

      await _db.collection('Banners').doc(docId).update(updatedBanner.toJson());

      final index = banners.indexWhere((b) => b.id == docId);
      if (index != -1) {
        banners[index] = updatedBanner;
      }

      await loadBanners();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Banner berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating banner', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui banner: ${e.toString()}',
      );
    }
  }

  /// Delete banner
  Future<void> deleteBanner(String docId) async {
    try {
      TLoggerHelper.info('Deleting banner: $docId');

      await _db.collection('Banners').doc(docId).delete();

      await loadBanners();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Banner berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting banner', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus banner: ${e.toString()}',
      );
    }
  }
}

