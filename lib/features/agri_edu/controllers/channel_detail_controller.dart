import 'package:get/get.dart';
import '../models/youtube_video_model.dart';
import '../models/youtube_video_detail_model.dart';
import '../models/youtube_playlist_model.dart';
import '../repositories/youtube_repository.dart';
import '../../../utils/logging/logger.dart';

class ChannelDetailController extends GetxController {
  final YouTubeRepository _youtubeRepository = YouTubeRepository();
  
  // Channel videos (latest)
  final RxList<YouTubeVideoModel> latestVideos = <YouTubeVideoModel>[].obs;
  final RxBool isLoadingLatestVideos = false.obs;
  final RxBool isLoadingMoreLatestVideos = false.obs;
  final RxString latestVideosNextPageToken = ''.obs;
  final RxBool hasMoreLatestVideos = true.obs;
  
  // Popular videos (trending)
  final RxList<YouTubeVideoDetailModel> popularVideos = <YouTubeVideoDetailModel>[].obs;
  final RxBool isLoadingPopularVideos = false.obs;
  final RxBool isLoadingMorePopularVideos = false.obs;
  final RxString popularVideosNextPageToken = ''.obs;
  final RxBool hasMorePopularVideos = true.obs;
  
  // Channel playlists
  final RxList<YouTubePlaylistModel> playlists = <YouTubePlaylistModel>[].obs;
  final RxBool isLoadingPlaylists = false.obs;
  final RxBool isLoadingMorePlaylists = false.obs;
  final RxString playlistsNextPageToken = ''.obs;
  final RxBool hasMorePlaylists = true.obs;
  
  // Selected playlist videos
  final RxList<YouTubePlaylistItemModel> playlistVideos = <YouTubePlaylistItemModel>[].obs;
  final RxBool isLoadingPlaylistVideos = false.obs;
  final RxBool isLoadingMorePlaylistVideos = false.obs;
  final RxString playlistVideosNextPageToken = ''.obs;
  final RxBool hasMorePlaylistVideos = true.obs;
  final RxString selectedPlaylistId = ''.obs;
  
  // Error messages
  final RxString errorMessage = ''.obs;

  // Get latest videos from channel
  Future<void> fetchLatestVideos(String channelId, {bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isLoadingMoreLatestVideos.value = true;
      } else {
        isLoadingLatestVideos.value = true;
        latestVideos.clear();
        latestVideosNextPageToken.value = '';
        hasMoreLatestVideos.value = true;
      }
      errorMessage.value = '';
      
      print('🔄 Fetching latest videos for channel: $channelId (loadMore: $isLoadMore)');
      TLoggerHelper.info("Fetching latest videos for channel: $channelId (loadMore: $isLoadMore)");
      
      final response = await _youtubeRepository.getChannelVideos(
        channelId: channelId,
        maxResults: 10,
        order: 'date',
        pageToken: isLoadMore ? latestVideosNextPageToken.value : null,
      );
      
      if (isLoadMore) {
        latestVideos.addAll(response.items);
      } else {
        latestVideos.value = response.items;
      }
      
      latestVideosNextPageToken.value = response.nextPageToken ?? '';
      hasMoreLatestVideos.value = response.nextPageToken != null;
      
      print('✅ Successfully loaded ${latestVideos.length} latest videos (hasMore: ${hasMoreLatestVideos.value})');
      TLoggerHelper.info("Successfully loaded ${latestVideos.length} latest videos (hasMore: ${hasMoreLatestVideos.value})");
    } catch (e) {
      print('❌ Error fetching latest videos: $e');
      TLoggerHelper.error("Error fetching latest videos", e);
      errorMessage.value = 'Gagal memuat video terbaru. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        'Gagal memuat video terbaru: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (isLoadMore) {
        isLoadingMoreLatestVideos.value = false;
      } else {
        isLoadingLatestVideos.value = false;
      }
    }
  }

  // Get popular/trending videos
  Future<void> fetchPopularVideos({String regionCode = 'ID', bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isLoadingMorePopularVideos.value = true;
      } else {
        isLoadingPopularVideos.value = true;
        popularVideos.clear();
        popularVideosNextPageToken.value = '';
        hasMorePopularVideos.value = true;
      }
      errorMessage.value = '';
      
      print('🔄 Fetching popular videos for region: $regionCode (loadMore: $isLoadMore)');
      TLoggerHelper.info("Fetching popular videos for region: $regionCode (loadMore: $isLoadMore)");
      
      final response = await _youtubeRepository.getPopularVideos(
        regionCode: regionCode,
        maxResults: 10,
        pageToken: isLoadMore ? popularVideosNextPageToken.value : null,
      );
      
      if (isLoadMore) {
        popularVideos.addAll(response.items);
      } else {
        popularVideos.value = response.items;
      }
      
      popularVideosNextPageToken.value = ''; // Popular videos API doesn't support pagination
      hasMorePopularVideos.value = false; // No more data available
      
      print('✅ Successfully loaded ${popularVideos.length} popular videos (hasMore: ${hasMorePopularVideos.value})');
      TLoggerHelper.info("Successfully loaded ${popularVideos.length} popular videos (hasMore: ${hasMorePopularVideos.value})");
    } catch (e) {
      print('❌ Error fetching popular videos: $e');
      TLoggerHelper.error("Error fetching popular videos", e);
      errorMessage.value = 'Gagal memuat video populer. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        'Gagal memuat video populer: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (isLoadMore) {
        isLoadingMorePopularVideos.value = false;
      } else {
        isLoadingPopularVideos.value = false;
      }
    }
  }

  // Get playlists from channel
  Future<void> fetchPlaylists(String channelId, {bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isLoadingMorePlaylists.value = true;
      } else {
        isLoadingPlaylists.value = true;
        playlists.clear();
        playlistsNextPageToken.value = '';
        hasMorePlaylists.value = true;
      }
      errorMessage.value = '';
      
      print('🔄 Fetching playlists for channel: $channelId (loadMore: $isLoadMore)');
      TLoggerHelper.info("Fetching playlists for channel: $channelId (loadMore: $isLoadMore)");
      
      final response = await _youtubeRepository.getChannelPlaylists(
        channelId: channelId,
        maxResults: 10,
        pageToken: isLoadMore ? playlistsNextPageToken.value : null,
      );
      
      if (isLoadMore) {
        playlists.addAll(response.items);
      } else {
        playlists.value = response.items;
      }
      
      playlistsNextPageToken.value = response.nextPageToken ?? '';
      hasMorePlaylists.value = response.nextPageToken != null;
      
      print('✅ Successfully loaded ${playlists.length} playlists (hasMore: ${hasMorePlaylists.value})');
      TLoggerHelper.info("Successfully loaded ${playlists.length} playlists (hasMore: ${hasMorePlaylists.value})");
    } catch (e) {
      print('❌ Error fetching playlists: $e');
      TLoggerHelper.error("Error fetching playlists", e);
      errorMessage.value = 'Gagal memuat playlist. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        'Gagal memuat playlist: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (isLoadMore) {
        isLoadingMorePlaylists.value = false;
      } else {
        isLoadingPlaylists.value = false;
      }
    }
  }

  // Get videos from specific playlist
  Future<void> fetchPlaylistVideos(String playlistId, {bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isLoadingMorePlaylistVideos.value = true;
      } else {
        isLoadingPlaylistVideos.value = true;
        playlistVideos.clear();
        playlistVideosNextPageToken.value = '';
        hasMorePlaylistVideos.value = true;
      }
      selectedPlaylistId.value = playlistId;
      errorMessage.value = '';
      
      print('🔄 Fetching videos from playlist: $playlistId (loadMore: $isLoadMore)');
      TLoggerHelper.info("Fetching videos from playlist: $playlistId (loadMore: $isLoadMore)");
      
      final response = await _youtubeRepository.getPlaylistVideos(
        playlistId: playlistId,
        maxResults: 20,
        pageToken: isLoadMore ? playlistVideosNextPageToken.value : null,
      );
      
      if (isLoadMore) {
        playlistVideos.addAll(response.items);
      } else {
        playlistVideos.value = response.items;
      }
      
      playlistVideosNextPageToken.value = response.nextPageToken ?? '';
      hasMorePlaylistVideos.value = response.nextPageToken != null;
      
      print('✅ Successfully loaded ${playlistVideos.length} playlist videos (hasMore: ${hasMorePlaylistVideos.value})');
      TLoggerHelper.info("Successfully loaded ${playlistVideos.length} playlist videos (hasMore: ${hasMorePlaylistVideos.value})");
    } catch (e) {
      print('❌ Error fetching playlist videos: $e');
      TLoggerHelper.error("Error fetching playlist videos", e);
      errorMessage.value = 'Gagal memuat video playlist. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        'Gagal memuat video playlist: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (isLoadMore) {
        isLoadingMorePlaylistVideos.value = false;
      } else {
        isLoadingPlaylistVideos.value = false;
      }
    }
  }

  // Load more methods
  Future<void> loadMoreLatestVideos(String channelId) async {
    if (hasMoreLatestVideos.value && !isLoadingMoreLatestVideos.value) {
      await fetchLatestVideos(channelId, isLoadMore: true);
    }
  }

  Future<void> loadMorePopularVideos({String regionCode = 'ID'}) async {
    if (hasMorePopularVideos.value && !isLoadingMorePopularVideos.value) {
      await fetchPopularVideos(regionCode: regionCode, isLoadMore: true);
    }
  }

  Future<void> loadMorePlaylists(String channelId) async {
    if (hasMorePlaylists.value && !isLoadingMorePlaylists.value) {
      await fetchPlaylists(channelId, isLoadMore: true);
    }
  }

  Future<void> loadMorePlaylistVideos(String playlistId) async {
    if (hasMorePlaylistVideos.value && !isLoadingMorePlaylistVideos.value) {
      await fetchPlaylistVideos(playlistId, isLoadMore: true);
    }
  }

  // Refresh all data
  Future<void> refreshAllData(String channelId) async {
    await Future.wait([
      fetchLatestVideos(channelId),
      fetchPopularVideos(),
      fetchPlaylists(channelId),
    ]);
  }

  // Clear all data
  void clearAllData() {
    latestVideos.clear();
    popularVideos.clear();
    playlists.clear();
    playlistVideos.clear();
    selectedPlaylistId.value = '';
    errorMessage.value = '';
    
    // Reset pagination states
    latestVideosNextPageToken.value = '';
    popularVideosNextPageToken.value = '';
    playlistsNextPageToken.value = '';
    playlistVideosNextPageToken.value = '';
    
    hasMoreLatestVideos.value = true;
    hasMorePopularVideos.value = true;
    hasMorePlaylists.value = true;
    hasMorePlaylistVideos.value = true;
  }
}
