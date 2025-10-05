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
  
  // Popular videos (trending)
  final RxList<YouTubeVideoDetailModel> popularVideos = <YouTubeVideoDetailModel>[].obs;
  final RxBool isLoadingPopularVideos = false.obs;
  
  // Channel playlists
  final RxList<YouTubePlaylistModel> playlists = <YouTubePlaylistModel>[].obs;
  final RxBool isLoadingPlaylists = false.obs;
  
  // Selected playlist videos
  final RxList<YouTubePlaylistItemModel> playlistVideos = <YouTubePlaylistItemModel>[].obs;
  final RxBool isLoadingPlaylistVideos = false.obs;
  final RxString selectedPlaylistId = ''.obs;
  
  // Error messages
  final RxString errorMessage = ''.obs;

  // Get latest videos from channel
  Future<void> fetchLatestVideos(String channelId) async {
    try {
      isLoadingLatestVideos.value = true;
      errorMessage.value = '';
      
      print('🔄 Fetching latest videos for channel: $channelId');
      TLoggerHelper.info("Fetching latest videos for channel: $channelId");
      
      final response = await _youtubeRepository.getChannelVideos(
        channelId: channelId,
        maxResults: 10,
        order: 'date',
      );
      
      latestVideos.value = response.items;
      print('✅ Successfully loaded ${latestVideos.length} latest videos');
      TLoggerHelper.info("Successfully loaded ${latestVideos.length} latest videos");
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
      isLoadingLatestVideos.value = false;
    }
  }

  // Get popular/trending videos
  Future<void> fetchPopularVideos({String regionCode = 'ID'}) async {
    try {
      isLoadingPopularVideos.value = true;
      errorMessage.value = '';
      
      print('🔄 Fetching popular videos for region: $regionCode');
      TLoggerHelper.info("Fetching popular videos for region: $regionCode");
      
      final response = await _youtubeRepository.getPopularVideos(
        regionCode: regionCode,
        maxResults: 10,
      );
      
      popularVideos.value = response.items;
      print('✅ Successfully loaded ${popularVideos.length} popular videos');
      TLoggerHelper.info("Successfully loaded ${popularVideos.length} popular videos");
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
      isLoadingPopularVideos.value = false;
    }
  }

  // Get playlists from channel
  Future<void> fetchPlaylists(String channelId) async {
    try {
      isLoadingPlaylists.value = true;
      errorMessage.value = '';
      
      print('🔄 Fetching playlists for channel: $channelId');
      TLoggerHelper.info("Fetching playlists for channel: $channelId");
      
      final response = await _youtubeRepository.getChannelPlaylists(
        channelId: channelId,
        maxResults: 10,
      );
      
      playlists.value = response.items;
      print('✅ Successfully loaded ${playlists.length} playlists');
      TLoggerHelper.info("Successfully loaded ${playlists.length} playlists");
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
      isLoadingPlaylists.value = false;
    }
  }

  // Get videos from specific playlist
  Future<void> fetchPlaylistVideos(String playlistId) async {
    try {
      isLoadingPlaylistVideos.value = true;
      selectedPlaylistId.value = playlistId;
      errorMessage.value = '';
      
      print('🔄 Fetching videos from playlist: $playlistId');
      TLoggerHelper.info("Fetching videos from playlist: $playlistId");
      
      final response = await _youtubeRepository.getPlaylistVideos(
        playlistId: playlistId,
        maxResults: 20,
      );
      
      playlistVideos.value = response.items;
      print('✅ Successfully loaded ${playlistVideos.length} playlist videos');
      TLoggerHelper.info("Successfully loaded ${playlistVideos.length} playlist videos");
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
      isLoadingPlaylistVideos.value = false;
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
  }
}
