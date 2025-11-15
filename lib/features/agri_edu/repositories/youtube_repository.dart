import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/youtube_video_model.dart' as video;
import '../models/youtube_video_detail_model.dart' as detail;
import '../models/youtube_channel_model.dart' as channel;
import '../models/youtube_playlist_model.dart' as playlist;
import '../../../utils/logging/logger.dart';
import '../../../utils/constraints/api_constants.dart';

class YouTubeRepository {
  // Get base URL from environment variables
  static String get _baseUrl => APIConstants.youtubeBaseUrl;
  
  // Get API key from environment variables
  static String get _apiKey => APIConstants.youtubeApiKey;
  
  // Get default channel ID from environment variables
  static String get _channelId => APIConstants.youtubeDefaultChannelId;
  
  // Get list of channel IDs from environment variables
  static List<String> get _channelIds => APIConstants.youtubeChannelIds;

  Future<video.YouTubeSearchResponse> getVideos({
    int maxResults = 10,
    String order = 'date',
  }) async {
    try {
      TLoggerHelper.info("Fetching YouTube videos...");
      
      final uri = Uri.parse(
        '$_baseUrl/search?part=snippet&channelId=$_channelId&maxResults=$maxResults&order=$order&type=video&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final youtubeResponse = video.YouTubeSearchResponse.fromJson(data);
        
        TLoggerHelper.info("Successfully fetched ${youtubeResponse.items.length} videos");
        return youtubeResponse;
      } else {
        TLoggerHelper.error("Failed to fetch videos: ${response.statusCode}");
        throw Exception('Failed to fetch videos: ${response.statusCode}');
      }
    } catch (e) {
      TLoggerHelper.error("Error fetching YouTube videos", e);
      throw Exception('Error fetching videos: $e');
    }
  }

  Future<video.YouTubeSearchResponse> searchVideos({
    required String query,
    int maxResults = 10,
    String order = 'relevance',
  }) async {
    try {
      TLoggerHelper.info("Searching YouTube videos for: $query");
      
      final uri = Uri.parse(
        '$_baseUrl/search?part=snippet&channelId=$_channelId&q=${Uri.encodeComponent(query)}&maxResults=$maxResults&order=$order&type=video&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final youtubeResponse = video.YouTubeSearchResponse.fromJson(data);
        
        TLoggerHelper.info("Successfully searched ${youtubeResponse.items.length} videos");
        return youtubeResponse;
      } else {
        TLoggerHelper.error("Failed to search videos: ${response.statusCode}");
        throw Exception('Failed to search videos: ${response.statusCode}');
      }
    } catch (e) {
      TLoggerHelper.error("Error searching YouTube videos", e);
      throw Exception('Error searching videos: $e');
    }
  }

  Future<detail.YouTubeVideoDetailResponse> getVideoDetails(String videoId) async {
    try {
      TLoggerHelper.info("Fetching video details for: $videoId");
      
      final uri = Uri.parse(
        '$_baseUrl/videos?part=snippet,statistics,contentDetails&id=$videoId&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final videoDetailResponse = detail.YouTubeVideoDetailResponse.fromJson(data);
        
        TLoggerHelper.info("Successfully fetched video details");
        return videoDetailResponse;
      } else {
        TLoggerHelper.error("Failed to fetch video details: ${response.statusCode}");
        throw Exception('Failed to fetch video details: ${response.statusCode}');
      }
    } catch (e) {
      TLoggerHelper.error("Error fetching video details", e);
      throw Exception('Error fetching video details: $e');
    }
  }

  Future<channel.YouTubeChannelListResponse> getChannels() async {
    try {
      TLoggerHelper.info("Fetching YouTube channels...");
      
      // Fetch channels in batches to avoid quota limits
      final List<channel.YouTubeChannelModel> allChannels = [];
      final int batchSize = 5; // Process 5 channels at a time
      
      for (int i = 0; i < _channelIds.length; i += batchSize) {
        final batch = _channelIds.skip(i).take(batchSize).toList();
        final channelIdsString = batch.join(',');
        
        TLoggerHelper.debug('Fetching batch ${(i ~/ batchSize) + 1}: $channelIdsString');
        
        final uri = Uri.parse(
          '$_baseUrl/channels?part=snippet,statistics,brandingSettings&id=$channelIdsString&key=$_apiKey',
        );
        TLoggerHelper.debug('API URL: $uri');

        final response = await http.get(uri);
        TLoggerHelper.debug('Response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final channelResponse = channel.YouTubeChannelListResponse.fromJson(data);
          allChannels.addAll(channelResponse.items);
          
          TLoggerHelper.debug('Successfully fetched ${channelResponse.items.length} channels in batch');
          
          // Add delay between batches to avoid rate limiting
          if (i + batchSize < _channelIds.length) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        } else {
          TLoggerHelper.warning('Failed to fetch channels batch: ${response.statusCode}');
          TLoggerHelper.debug('Response body: ${response.body}');
          // Continue with next batch instead of throwing error
        }
      }
      
      TLoggerHelper.info("Successfully fetched ${allChannels.length} total channels");
      
      return channel.YouTubeChannelListResponse(
        kind: 'youtube#channelListResponse',
        etag: '',
        pageInfo: channel.YouTubePageInfo(totalResults: allChannels.length, resultsPerPage: allChannels.length),
        items: allChannels,
      );
    } catch (e) {
      TLoggerHelper.error("Error fetching YouTube channels", e);
      throw Exception('Error fetching channels: $e');
    }
  }

  Future<channel.YouTubeChannelModel> getChannelDetails(String channelId) async {
    try {
      TLoggerHelper.info("Fetching channel details for: $channelId");
      
      final uri = Uri.parse(
        '$_baseUrl/channels?part=snippet,statistics,brandingSettings&id=$channelId&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final channelResponse = channel.YouTubeChannelListResponse.fromJson(data);
        
        if (channelResponse.items.isNotEmpty) {
          TLoggerHelper.info("Successfully fetched channel details");
          return channelResponse.items.first;
        } else {
          throw Exception('Channel not found');
        }
      } else {
        TLoggerHelper.error("Failed to fetch channel details: ${response.statusCode}");
        throw Exception('Failed to fetch channel details: ${response.statusCode}');
      }
    } catch (e) {
      TLoggerHelper.error("Error fetching channel details", e);
      throw Exception('Error fetching channel details: $e');
    }
  }

  // Get latest videos from a specific channel
  Future<video.YouTubeSearchResponse> getChannelVideos({
    required String channelId,
    int maxResults = 10,
    String order = 'date',
    String? pageToken,
  }) async {
    try {
      TLoggerHelper.info("Fetching channel videos for: $channelId");
      
      String url = '$_baseUrl/search?part=snippet&channelId=$channelId&maxResults=$maxResults&order=$order&type=video&key=$_apiKey';
      if (pageToken != null && pageToken.isNotEmpty) {
        url += '&pageToken=$pageToken';
      }
      
      final uri = Uri.parse(url);
      TLoggerHelper.debug('API URL: $uri');

      final response = await http.get(uri);
      TLoggerHelper.debug('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final videoResponse = video.YouTubeSearchResponse.fromJson(data);
        
        TLoggerHelper.info("Successfully fetched ${videoResponse.items.length} channel videos");
        return videoResponse;
      } else {
        TLoggerHelper.error("Failed to fetch channel videos: ${response.statusCode}", null);
        throw Exception('Failed to fetch channel videos: ${response.statusCode}');
      }
    } catch (e) {
      TLoggerHelper.error("Error fetching channel videos", e);
      throw Exception('Error fetching channel videos: $e');
    }
  }

  // Get popular/trending videos
  Future<detail.YouTubeVideoDetailResponse> getPopularVideos({
    String regionCode = 'ID',
    int maxResults = 10,
    String? pageToken,
  }) async {
    try {
      TLoggerHelper.info("Fetching popular videos for region: $regionCode");
      
      String url = '$_baseUrl/videos?part=snippet,statistics,contentDetails&chart=mostPopular&regionCode=$regionCode&maxResults=$maxResults&key=$_apiKey';
      if (pageToken != null && pageToken.isNotEmpty) {
        url += '&pageToken=$pageToken';
      }
      
      final uri = Uri.parse(url);
      TLoggerHelper.debug('API URL: $uri');

      final response = await http.get(uri);
      TLoggerHelper.debug('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final videoResponse = detail.YouTubeVideoDetailResponse.fromJson(data);
        
        TLoggerHelper.info("Successfully fetched ${videoResponse.items.length} popular videos");
        return videoResponse;
      } else {
        TLoggerHelper.error("Failed to fetch popular videos: ${response.statusCode}", null);
        throw Exception('Failed to fetch popular videos: ${response.statusCode}');
      }
    } catch (e) {
      TLoggerHelper.error("Error fetching popular videos", e);
      throw Exception('Error fetching popular videos: $e');
    }
  }

  // Get playlists from a specific channel
  Future<playlist.YouTubePlaylistResponse> getChannelPlaylists({
    required String channelId,
    int maxResults = 10,
    String? pageToken,
  }) async {
    try {
      TLoggerHelper.info("Fetching channel playlists for: $channelId");
      
      String url = '$_baseUrl/playlists?part=snippet,contentDetails&channelId=$channelId&maxResults=$maxResults&key=$_apiKey';
      if (pageToken != null && pageToken.isNotEmpty) {
        url += '&pageToken=$pageToken';
      }
      
      final uri = Uri.parse(url);
      TLoggerHelper.debug('API URL: $uri');

      final response = await http.get(uri);
      TLoggerHelper.debug('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final playlistResponse = playlist.YouTubePlaylistResponse.fromJson(data);
        
        TLoggerHelper.info("Successfully fetched ${playlistResponse.items.length} playlists");
        return playlistResponse;
      } else {
        TLoggerHelper.error("Failed to fetch playlists: ${response.statusCode}", null);
        throw Exception('Failed to fetch playlists: ${response.statusCode}');
      }
    } catch (e) {
      TLoggerHelper.error("Error fetching playlists", e);
      throw Exception('Error fetching playlists: $e');
    }
  }

  // Get videos from a specific playlist
  Future<playlist.YouTubePlaylistItemsResponse> getPlaylistVideos({
    required String playlistId,
    int maxResults = 20,
    String? pageToken,
  }) async {
    try {
      TLoggerHelper.info("Fetching playlist videos for: $playlistId");
      
      String url = '$_baseUrl/playlistItems?part=snippet&playlistId=$playlistId&maxResults=$maxResults&key=$_apiKey';
      if (pageToken != null && pageToken.isNotEmpty) {
        url += '&pageToken=$pageToken';
      }
      
      final uri = Uri.parse(url);
      TLoggerHelper.debug('API URL: $uri');

      final response = await http.get(uri);
      TLoggerHelper.debug('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final playlistItemsResponse = playlist.YouTubePlaylistItemsResponse.fromJson(data);
        
        TLoggerHelper.info("Successfully fetched ${playlistItemsResponse.items.length} playlist videos");
        return playlistItemsResponse;
      } else {
        TLoggerHelper.error("Failed to fetch playlist videos: ${response.statusCode}", null);
        throw Exception('Failed to fetch playlist videos: ${response.statusCode}');
      }
    } catch (e) {
      TLoggerHelper.error("Error fetching playlist videos", e);
      throw Exception('Error fetching playlist videos: $e');
    }
  }
}
