import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/youtube_video_model.dart';
import '../models/youtube_channel_model.dart';
import '../repositories/youtube_repository.dart';
import '../../../data/repositories/agri_edu_category_repository.dart';
import '../../../utils/logging/logger.dart';
import '../../../utils/helpers/loaders.dart';

class AgriEduController extends GetxController {
  final YouTubeRepository _youtubeRepository = YouTubeRepository();
  final AgriEduCategoryRepository _categoryRepository = AgriEduCategoryRepository();
  
  final RxList<YouTubeVideoModel> videos = <YouTubeVideoModel>[].obs;
  final RxList<YouTubeVideoModel> allVideos = <YouTubeVideoModel>[].obs;
  final RxList<YouTubeVideoModel> featuredVideos = <YouTubeVideoModel>[].obs;
  // Featured per selected channel
  final RxString selectedFeaturedChannelId = ''.obs;
  final RxList<YouTubeVideoModel> featuredChannelVideos = <YouTubeVideoModel>[].obs;
  final RxBool isLoadingFeaturedChannel = false.obs;
  final RxList<YouTubeChannelModel> channels = <YouTubeChannelModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingFeaturedVideos = false.obs;
  final RxBool isLoadingChannels = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString errorMessage = ''.obs;
  final TextEditingController searchTextController = TextEditingController();
  // Search filters - now loaded from Firebase
  final RxList<String> categories = <String>[].obs;
  final RxString selectedFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    fetchVideos();
    fetchChannels();
    // Fetch featured videos after channels are loaded
    Future.delayed(const Duration(milliseconds: 500), () {
      fetchFeaturedVideos();
    });
  }

  /// Load categories from Firebase
  Future<void> loadCategories() async {
    try {
      final categoryList = await _categoryRepository.getCategories();
      categories.assignAll(categoryList.map((cat) => cat.name).toList());
      TLoggerHelper.info('Loaded ${categories.length} categories from Firebase');
    } catch (e) {
      TLoggerHelper.error('Error loading categories', e);
      // Fallback to default categories
      categories.assignAll([
        'Pertanian',
        'Hidroponik',
        'Organik',
        'Urban',
        'Aquaponik',
        'Teknologi',
        'Tips',
        'Greenhouse',
        'Pascapanen',
      ]);
    }
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      TLoggerHelper.info("Fetching AgriEdu videos...");
      final response = await _youtubeRepository.getVideos(maxResults: 10);
      
      allVideos.value = response.items;
      videos.value = response.items;
      TLoggerHelper.info("Successfully loaded ${videos.length} videos");
    } catch (e) {
      TLoggerHelper.error("Error fetching videos", e);
      errorMessage.value = 'Gagal memuat video. Silakan coba lagi.';
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat video: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchVideosLocal(String query) {
    searchQuery.value = query;
    final lowerQuery = query.toLowerCase();
    if (lowerQuery.isEmpty) {
      videos.value = List<YouTubeVideoModel>.from(allVideos);
      return;
    }
    final filtered = allVideos.where((v) {
      final title = v.title.toLowerCase();
      final channel = v.channelTitle.toLowerCase();
      return title.contains(lowerQuery) || channel.contains(lowerQuery);
    }).toList();
    filtered.sort((a, b) {
      int score(String text) {
        if (text.startsWith(lowerQuery)) return 0;
        final idx = text.indexOf(lowerQuery);
        return idx >= 0 ? 1 : 2;
      }
      final aTitle = a.title.toLowerCase();
      final bTitle = b.title.toLowerCase();
      final aScore = score(aTitle);
      final bScore = score(bTitle);
      if (aScore != bScore) return aScore.compareTo(bScore);
      final aDate = DateTime.tryParse(a.publishedAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = DateTime.tryParse(b.publishedAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    videos.value = filtered;
  }

  void filterByCategory(String category) {
    selectedFilter.value = category;
    searchVideosLocal(category);
  }

  void clearAllFilters() {
    selectedFilter.value = '';
    clearSearch();
  }

  void clearSearch() {
    searchQuery.value = '';
    searchTextController.clear();
    videos.value = List<YouTubeVideoModel>.from(allVideos);
  }

  void refreshVideos() {
    fetchVideos();
  }

  Future<void> fetchChannels() async {
    try {
      isLoadingChannels.value = true;
      errorMessage.value = '';
      
      TLoggerHelper.info("Fetching AgriEdu channels...");
      final response = await _youtubeRepository.getChannels();
      
      TLoggerHelper.debug('API Response: ${response.items.length} channels received');
      TLoggerHelper.debug('Channel titles: ${response.items.map((c) => c.title).toList()}');
      
      channels.value = response.items;
      // Initialize featured channel selection (prefer 'Pemkab gresik' if available)
      if (channels.isNotEmpty && selectedFeaturedChannelId.value.isEmpty) {
        final preferred = channels.firstWhere(
          (c) => c.title.toLowerCase().contains('pemkab gresik'),
          orElse: () => channels.first,
        );
        selectedFeaturedChannelId.value = preferred.id;
        await fetchFeaturedChannelVideos(preferred.id);
      }
      TLoggerHelper.info("Successfully loaded ${channels.length} channels");
    } catch (e) {
      TLoggerHelper.error("Error fetching channels", e);
      
      // Fallback: Create dummy data for testing
      TLoggerHelper.debug('Creating fallback channel data...');
      _createFallbackChannels();
      
      errorMessage.value = 'Gagal memuat channel. Menggunakan data fallback.';
      TLoaders.warningSnackBar(
        title: 'Peringatan',
        message: 'Gagal memuat channel dari API. Menggunakan data fallback.',
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
    TLoggerHelper.info('Created ${fallbackChannels.length} fallback channels');
  }

  Future<void> refreshChannels() {
    return fetchChannels();
  }

  Future<void> setFeaturedChannel(String channelId) async {
    if (selectedFeaturedChannelId.value == channelId) return;
    selectedFeaturedChannelId.value = channelId;
    await fetchFeaturedChannelVideos(channelId);
  }

  Future<void> fetchFeaturedChannelVideos(String channelId) async {
    try {
      isLoadingFeaturedChannel.value = true;
      errorMessage.value = '';
      TLoggerHelper.info("Fetching featured videos for channel: $channelId");
      final response = await _youtubeRepository.getChannelVideos(
        channelId: channelId,
        maxResults: 10,
        order: 'date',
      );
      featuredChannelVideos.value = response.items;
      TLoggerHelper.info("Loaded ${featuredChannelVideos.length} featured videos for $channelId");
    } catch (e) {
      TLoggerHelper.error("Error fetching featured channel videos", e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat video unggulan channel: ${e.toString()}',
      );
    } finally {
      isLoadingFeaturedChannel.value = false;
    }
  }

  void clearFeaturedSelection() {
    selectedFeaturedChannelId.value = '';
    featuredChannelVideos.clear();
  }

  Future<void> fetchFeaturedVideos() async {
    try {
      isLoadingFeaturedVideos.value = true;
      errorMessage.value = '';
      
      TLoggerHelper.info("Fetching featured videos from all channels...");
      
      // Get videos from all channels
      final List<YouTubeVideoModel> allVideos = [];
      
      for (int i = 0; i < channels.length; i++) {
        final channel = channels[i];
        try {
          TLoggerHelper.info("🌐 Fetching channel videos for: ${channel.id}");
          final response = await _youtubeRepository.getChannelVideos(
            channelId: channel.id,
            maxResults: 5,
          );
          allVideos.addAll(response.items);
          
          // Add delay between requests to avoid rate limiting
          if (i < channels.length - 1) {
            await Future.delayed(const Duration(milliseconds: 300));
          }
        } catch (e) {
          TLoggerHelper.error("⚠️ Failed to fetch videos for channel ${channel.id}: $e");
          // Continue with other channels
        }
      }
      
      // Sort by published date (newest first) and take first 10
      allVideos.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      featuredVideos.value = allVideos.take(10).toList();
      
      TLoggerHelper.info("💡 Successfully loaded ${featuredVideos.length} featured videos");
    } catch (e) {
      TLoggerHelper.error("Error fetching featured videos", e);
      errorMessage.value = 'Gagal memuat video unggulan. Silakan coba lagi.';
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat video unggulan: ${e.toString()}',
      );
    } finally {
      isLoadingFeaturedVideos.value = false;
    }
  }
}
