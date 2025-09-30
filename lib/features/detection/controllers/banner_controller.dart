import 'package:agrigres/utils/logging/logger.dart';
import 'package:get/get.dart';
import 'package:agrigres/data/repositories/banners/banners_repository.dart';
import 'package:agrigres/features/detection/models/banner_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class BannerController extends GetxController {

  ///variables
  final carouselCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  ///update page navigational dots
  void updatePageIndicator(index){
    carouselCurrentIndex.value = index;
  }

  ///fetch banners
  Future<void> fetchBanners() async {
    try {

      // Show loader while loading banners
      isLoading.value = true;

      // Fetch banners from BannerRepository
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      TLoggerHelper.info('Successfully fetched ${banners.length} banners');

      for (var banner in banners) {
        TLoggerHelper.debug('Status: ${banner.active}, Image URL: ${banner.imageUrl}');
      }

      // Assign banners to the list
      this.banners.assignAll(banners);

    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh tidak...', message: e.toString());
    } finally {
      // Remove loader after fetching is done
      isLoading.value = false;
    }
  }

}