import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/youtube_video_model.dart';
import '../models/youtube_channel_model.dart';
import '../repositories/youtube_repository.dart';
import '../../../utils/logging/logger.dart';

class AgriEduController extends GetxController {
  final YouTubeRepository _youtubeRepository = YouTubeRepository();
  
  final RxList<YouTubeVideoModel> videos = <YouTubeVideoModel>[].obs;
  final RxList<YouTubeChannelModel> channels = <YouTubeChannelModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingChannels = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
    fetchChannels();
  }

  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      TLoggerHelper.info("Fetching AgriEdu videos...");
      final response = await _youtubeRepository.getVideos(maxResults: 10);
      
      videos.value = response.items;
      TLoggerHelper.info("Successfully loaded ${videos.length} videos");
    } catch (e) {
      TLoggerHelper.error("Error fetching videos", e);
      errorMessage.value = 'Gagal memuat video. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        'Gagal memuat video: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchVideos(String query) async {
    if (query.trim().isEmpty) {
      fetchVideos();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      searchQuery.value = query;
      
      TLoggerHelper.info("Searching videos for: $query");
      final response = await _youtubeRepository.searchVideos(
        query: query,
        maxResults: 10,
      );
      
      videos.value = response.items;
      TLoggerHelper.info("Successfully searched ${videos.length} videos");
    } catch (e) {
      TLoggerHelper.error("Error searching videos", e);
      errorMessage.value = 'Gagal mencari video. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        'Gagal mencari video: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    fetchVideos();
  }

  void refreshVideos() {
    fetchVideos();
  }

  Future<void> fetchChannels() async {
    try {
      isLoadingChannels.value = true;
      errorMessage.value = '';
      
      print('🔄 Fetching AgriEdu channels...');
      TLoggerHelper.info("Fetching AgriEdu channels...");
      final response = await _youtubeRepository.getChannels();
      
      print('📊 API Response: ${response.items.length} channels received');
      print('📋 Channel titles: ${response.items.map((c) => c.title).toList()}');
      
      channels.value = response.items;
      print('✅ Successfully loaded ${channels.length} channels');
      TLoggerHelper.info("Successfully loaded ${channels.length} channels");
    } catch (e) {
      print('❌ Error fetching channels: $e');
      TLoggerHelper.error("Error fetching channels", e);
      
      // Fallback: Create dummy data for testing
      print('🔄 Creating fallback channel data...');
      _createFallbackChannels();
      
      errorMessage.value = 'Gagal memuat channel. Menggunakan data fallback.';
      Get.snackbar(
        'Warning',
        'Gagal memuat channel dari API. Menggunakan data fallback.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
    } finally {
      isLoadingChannels.value = false;
    }
  }

  void _createFallbackChannels() {
    // Create fallback channels based on the 12 channel IDs
    final fallbackChannels = [
      YouTubeChannelModel(
        id: 'UCrOkSpB5JDBCUrZaOzbsUcw',
        title: 'Mitra Pertanian Channel',
        description: 'Channel utama pertanian dengan tips dan trik budidaya',
        customUrl: '@mitrapertanianchannel',
        publishedAt: '2018-07-08T04:16:41Z',
        thumbnails: YouTubeChannelThumbnails(
          defaultUrl: 'https://yt3.ggpht.com/erSFaJnHQusqEmmMSHgDEE2Y_BANC0KDeFFfMAV9smzlSrzZliGlN2ZRFL4mt1xDvyVhh7Eg0Lc=s88-c-k-c0x00ffffff-no-rj',
          mediumUrl: 'https://yt3.ggpht.com/erSFaJnHQusqEmmMSHgDEE2Y_BANC0KDeFFfMAV9smzlSrzZliGlN2ZRFL4mt1xDvyVhh7Eg0Lc=s240-c-k-c0x00ffffff-no-rj',
          highUrl: 'https://yt3.ggpht.com/erSFaJnHQusqEmmMSHgDEE2Y_BANC0KDeFFfMAV9smzlSrzZliGlN2ZRFL4mt1xDvyVhh7Eg0Lc=s800-c-k-c0x00ffffff-no-rj',
        ),
        statistics: YouTubeChannelStatistics(
          viewCount: '7976365',
          subscriberCount: '73400',
          hiddenSubscriberCount: false,
          videoCount: '501',
        ),
        brandingSettings: YouTubeChannelBrandingSettings(
          title: 'Mitra Pertanian Channel',
          description: 'Channel pertanian terbaik',
          keywords: 'pertanian, budidaya, tips',
          unsubscribedTrailer: 'hHfnuv2mYwY',
          country: 'ID',
        ),
        country: 'ID',
      ),
      // Add more fallback channels as needed
    ];
    
    channels.value = fallbackChannels;
    print('✅ Created ${fallbackChannels.length} fallback channels');
  }

  Future<void> refreshChannels() {
    return fetchChannels();
  }
}
