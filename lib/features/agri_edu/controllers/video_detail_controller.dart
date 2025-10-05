import 'package:get/get.dart';
import '../models/youtube_video_detail_model.dart';
import '../repositories/youtube_repository.dart';
import '../../../utils/logging/logger.dart';

class VideoDetailController extends GetxController {
  final YouTubeRepository _youtubeRepository = YouTubeRepository();
  
  final Rx<YouTubeVideoDetailModel?> videoDetail = Rx<YouTubeVideoDetailModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchVideoDetail(String videoId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      TLoggerHelper.info("Fetching video detail for: $videoId");
      final response = await _youtubeRepository.getVideoDetails(videoId);
      
      if (response.items.isNotEmpty) {
        videoDetail.value = response.items.first;
        TLoggerHelper.info("Successfully loaded video detail");
      } else {
        errorMessage.value = 'Video tidak ditemukan';
      }
    } catch (e) {
      TLoggerHelper.error("Error fetching video detail", e);
      errorMessage.value = 'Gagal memuat detail video. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        'Gagal memuat detail video: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }


  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Get course details from API response
  Map<String, dynamic> get courseDetails {
    if (videoDetail.value == null) return {};
    
    final video = videoDetail.value!;
    return {
      'title': video.title,
      'description': video.description,
      'channelTitle': video.channelTitle,
      'publishedAt': video.publishedAt,
      'duration': video.contentDetails.formattedDuration,
      'viewCount': video.statistics.formattedViewCount,
      'likeCount': video.statistics.formattedLikeCount,
      'commentCount': video.statistics.commentCount,
      'categoryId': video.categoryId,
      'defaultLanguage': video.defaultLanguage,
      'thumbnails': {
        'default': video.thumbnails.defaultThumbnail.url,
        'medium': video.thumbnails.medium.url,
        'high': video.thumbnails.high.url,
      },
    };
  }
}
