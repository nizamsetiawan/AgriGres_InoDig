import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/youtube_video_model.dart';
import '../models/youtube_video_detail_model.dart';
import '../models/youtube_channel_model.dart';
import '../models/youtube_playlist_model.dart';
import '../../../utils/logging/logger.dart';

class YouTubeRepository {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  static const String _apiKey = 'AIzaSyAvlpBNPwEWtyPowmF9Pp9Bnd4b3t-nm_0';
  static const String _channelId = 'UCrOkSpB5JDBCUrZaOzbsUcw';
  
  // List of 12 channel IDs
  static const List<String> _channelIds = [
    'UCrOkSpB5JDBCUrZaOzbsUcw',
    'UCdPDUMhCqE6hW2Ja39EJQOw',
    'UCPtpZkU1fNgdW2VUZz6boHw',
    'UC757MLmzhe5QXlr9yWyHcpQ',
    'UCB0IUuzY203wj7jPLDlBsRg',
    'UC2M0KWQ7_e3oCqnWL4urUVQ',
    'UCNnCpWr9yvBiHwNlHpSNgSA',
    'UCBStUYo5AKwqVP_iPANSqsw',
    'UCVo4uXlUX14ra051-i3AbMg',
    'UCb1C-wSCygELT8P294qocHw',
    'UCpv_DdfS-_HIbJmE4va8MPg',
    'UCXzOJru703AhCJXikZEEmsw',
  ];

  Future<YouTubeSearchResponse> getVideos({
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
        final youtubeResponse = YouTubeSearchResponse.fromJson(data);
        
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

  Future<YouTubeSearchResponse> searchVideos({
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
        final youtubeResponse = YouTubeSearchResponse.fromJson(data);
        
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

  Future<YouTubeVideoDetailResponse> getVideoDetails(String videoId) async {
    try {
      TLoggerHelper.info("Fetching video details for: $videoId");
      
      final uri = Uri.parse(
        '$_baseUrl/videos?part=snippet,statistics,contentDetails&id=$videoId&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final videoDetailResponse = YouTubeVideoDetailResponse.fromJson(data);
        
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

  Future<YouTubeChannelListResponse> getChannels() async {
    try {
      print('🌐 Fetching YouTube channels...');
      TLoggerHelper.info("Fetching YouTube channels...");
      
      // Join all channel IDs with comma
      final channelIdsString = _channelIds.join(',');
      print('📝 Channel IDs: $channelIdsString');
      
      final uri = Uri.parse(
        '$_baseUrl/channels?part=snippet,statistics,brandingSettings&id=$channelIdsString&key=$_apiKey',
      );
      print('🔗 API URL: $uri');

      final response = await http.get(uri);
      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('📄 Response body length: ${responseBody.length}');
        
        final Map<String, dynamic> data = json.decode(responseBody);
        print('📊 Parsed data keys: ${data.keys.toList()}');
        print('📋 Items count: ${data['items']?.length ?? 0}');
        
        final channelResponse = YouTubeChannelListResponse.fromJson(data);
        
        print('✅ Successfully fetched ${channelResponse.items.length} channels');
        TLoggerHelper.info("Successfully fetched ${channelResponse.items.length} channels");
        return channelResponse;
      } else {
        print('❌ Failed to fetch channels: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        TLoggerHelper.error("Failed to fetch channels: ${response.statusCode}");
        throw Exception('Failed to fetch channels: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching YouTube channels: $e');
      TLoggerHelper.error("Error fetching YouTube channels", e);
      throw Exception('Error fetching channels: $e');
    }
  }

  Future<YouTubeChannelModel> getChannelDetails(String channelId) async {
    try {
      TLoggerHelper.info("Fetching channel details for: $channelId");
      
      final uri = Uri.parse(
        '$_baseUrl/channels?part=snippet,statistics,brandingSettings&id=$channelId&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final channelResponse = YouTubeChannelListResponse.fromJson(data);
        
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
  Future<YouTubeSearchResponse> getChannelVideos({
    required String channelId,
    int maxResults = 10,
    String order = 'date',
  }) async {
    try {
      print('🌐 Fetching channel videos for: $channelId');
      TLoggerHelper.info("Fetching channel videos for: $channelId");
      
      final uri = Uri.parse(
        '$_baseUrl/search?part=snippet&channelId=$channelId&maxResults=$maxResults&order=$order&type=video&key=$_apiKey',
      );
      print('🔗 API URL: $uri');

      final response = await http.get(uri);
      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final videoResponse = YouTubeSearchResponse.fromJson(data);
        
        print('✅ Successfully fetched ${videoResponse.items.length} channel videos');
        TLoggerHelper.info("Successfully fetched ${videoResponse.items.length} channel videos");
        return videoResponse;
      } else {
        print('❌ Failed to fetch channel videos: ${response.statusCode}');
        TLoggerHelper.error("Failed to fetch channel videos: ${response.statusCode}");
        throw Exception('Failed to fetch channel videos: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching channel videos: $e');
      TLoggerHelper.error("Error fetching channel videos", e);
      throw Exception('Error fetching channel videos: $e');
    }
  }

  // Get popular/trending videos
  Future<YouTubeVideoDetailResponse> getPopularVideos({
    String regionCode = 'ID',
    int maxResults = 10,
  }) async {
    try {
      print('🌐 Fetching popular videos for region: $regionCode');
      TLoggerHelper.info("Fetching popular videos for region: $regionCode");
      
      final uri = Uri.parse(
        '$_baseUrl/videos?part=snippet,statistics,contentDetails&chart=mostPopular&regionCode=$regionCode&maxResults=$maxResults&key=$_apiKey',
      );
      print('🔗 API URL: $uri');

      final response = await http.get(uri);
      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final videoResponse = YouTubeVideoDetailResponse.fromJson(data);
        
        print('✅ Successfully fetched ${videoResponse.items.length} popular videos');
        TLoggerHelper.info("Successfully fetched ${videoResponse.items.length} popular videos");
        return videoResponse;
      } else {
        print('❌ Failed to fetch popular videos: ${response.statusCode}');
        TLoggerHelper.error("Failed to fetch popular videos: ${response.statusCode}");
        throw Exception('Failed to fetch popular videos: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching popular videos: $e');
      TLoggerHelper.error("Error fetching popular videos", e);
      throw Exception('Error fetching popular videos: $e');
    }
  }

  // Get playlists from a specific channel
  Future<YouTubePlaylistResponse> getChannelPlaylists({
    required String channelId,
    int maxResults = 10,
  }) async {
    try {
      print('🌐 Fetching channel playlists for: $channelId');
      TLoggerHelper.info("Fetching channel playlists for: $channelId");
      
      final uri = Uri.parse(
        '$_baseUrl/playlists?part=snippet,contentDetails&channelId=$channelId&maxResults=$maxResults&key=$_apiKey',
      );
      print('🔗 API URL: $uri');

      final response = await http.get(uri);
      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final playlistResponse = YouTubePlaylistResponse.fromJson(data);
        
        print('✅ Successfully fetched ${playlistResponse.items.length} playlists');
        TLoggerHelper.info("Successfully fetched ${playlistResponse.items.length} playlists");
        return playlistResponse;
      } else {
        print('❌ Failed to fetch playlists: ${response.statusCode}');
        TLoggerHelper.error("Failed to fetch playlists: ${response.statusCode}");
        throw Exception('Failed to fetch playlists: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching playlists: $e');
      TLoggerHelper.error("Error fetching playlists", e);
      throw Exception('Error fetching playlists: $e');
    }
  }

  // Get videos from a specific playlist
  Future<YouTubePlaylistItemsResponse> getPlaylistVideos({
    required String playlistId,
    int maxResults = 20,
  }) async {
    try {
      print('🌐 Fetching playlist videos for: $playlistId');
      TLoggerHelper.info("Fetching playlist videos for: $playlistId");
      
      final uri = Uri.parse(
        '$_baseUrl/playlistItems?part=snippet&playlistId=$playlistId&maxResults=$maxResults&key=$_apiKey',
      );
      print('🔗 API URL: $uri');

      final response = await http.get(uri);
      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final playlistItemsResponse = YouTubePlaylistItemsResponse.fromJson(data);
        
        print('✅ Successfully fetched ${playlistItemsResponse.items.length} playlist videos');
        TLoggerHelper.info("Successfully fetched ${playlistItemsResponse.items.length} playlist videos");
        return playlistItemsResponse;
      } else {
        print('❌ Failed to fetch playlist videos: ${response.statusCode}');
        TLoggerHelper.error("Failed to fetch playlist videos: ${response.statusCode}");
        throw Exception('Failed to fetch playlist videos: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching playlist videos: $e');
      TLoggerHelper.error("Error fetching playlist videos", e);
      throw Exception('Error fetching playlist videos: $e');
    }
  }
}
