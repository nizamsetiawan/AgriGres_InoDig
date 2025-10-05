import 'youtube_video_model.dart';

class YouTubeVideoDetailModel {
  final String videoId;
  final String title;
  final String description;
  final String channelTitle;
  final String publishedAt;
  final String categoryId;
  final String defaultLanguage;
  final YouTubeThumbnails thumbnails;
  final YouTubeContentDetails contentDetails;
  final YouTubeStatistics statistics;
  final YouTubeLocalized localized;

  YouTubeVideoDetailModel({
    required this.videoId,
    required this.title,
    required this.description,
    required this.channelTitle,
    required this.publishedAt,
    required this.categoryId,
    required this.defaultLanguage,
    required this.thumbnails,
    required this.contentDetails,
    required this.statistics,
    required this.localized,
  });

  factory YouTubeVideoDetailModel.fromJson(Map<String, dynamic> json) {
    return YouTubeVideoDetailModel(
      videoId: json['id'] ?? '',
      title: json['snippet']['title'] ?? '',
      description: json['snippet']['description'] ?? '',
      channelTitle: json['snippet']['channelTitle'] ?? '',
      publishedAt: json['snippet']['publishedAt'] ?? '',
      categoryId: json['snippet']['categoryId'] ?? '',
      defaultLanguage: json['snippet']['defaultLanguage'] ?? '',
      thumbnails: YouTubeThumbnails.fromJson(json['snippet']['thumbnails']),
      contentDetails: YouTubeContentDetails.fromJson(json['contentDetails']),
      statistics: YouTubeStatistics.fromJson(json['statistics']),
      localized: YouTubeLocalized.fromJson(json['snippet']['localized']),
    );
  }
}

class YouTubeContentDetails {
  final String duration;
  final String dimension;
  final String definition;
  final bool caption;
  final bool licensedContent;
  final String projection;

  YouTubeContentDetails({
    required this.duration,
    required this.dimension,
    required this.definition,
    required this.caption,
    required this.licensedContent,
    required this.projection,
  });

  factory YouTubeContentDetails.fromJson(Map<String, dynamic> json) {
    return YouTubeContentDetails(
      duration: json['duration'] ?? '',
      dimension: json['dimension'] ?? '',
      definition: json['definition'] ?? '',
      caption: json['caption'] == 'true',
      licensedContent: json['licensedContent'] == true,
      projection: json['projection'] ?? '',
    );
  }

  String get formattedDuration {
    // Convert PT15M32S to 15:32 format
    String duration = this.duration.replaceAll('PT', '');
    String result = '';
    
    if (duration.contains('H')) {
      final parts = duration.split('H');
      result += parts[0] + ':';
      duration = parts[1];
    }
    
    if (duration.contains('M')) {
      final parts = duration.split('M');
      result += parts[0].padLeft(2, '0') + ':';
      duration = parts[1];
    } else {
      result += '00:';
    }
    
    if (duration.contains('S')) {
      final parts = duration.split('S');
      result += parts[0].padLeft(2, '0');
    } else {
      result += '00';
    }
    
    return result;
  }
}

class YouTubeStatistics {
  final String viewCount;
  final String likeCount;
  final String favoriteCount;
  final String commentCount;

  YouTubeStatistics({
    required this.viewCount,
    required this.likeCount,
    required this.favoriteCount,
    required this.commentCount,
  });

  factory YouTubeStatistics.fromJson(Map<String, dynamic> json) {
    return YouTubeStatistics(
      viewCount: json['viewCount'] ?? '0',
      likeCount: json['likeCount'] ?? '0',
      favoriteCount: json['favoriteCount'] ?? '0',
      commentCount: json['commentCount'] ?? '0',
    );
  }

  String get formattedViewCount {
    final count = int.tryParse(viewCount) ?? 0;
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String get formattedLikeCount {
    final count = int.tryParse(likeCount) ?? 0;
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class YouTubeLocalized {
  final String title;
  final String description;

  YouTubeLocalized({
    required this.title,
    required this.description,
  });

  factory YouTubeLocalized.fromJson(Map<String, dynamic> json) {
    return YouTubeLocalized(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class YouTubeVideoDetailResponse {
  final String kind;
  final String etag;
  final List<YouTubeVideoDetailModel> items;
  final YouTubePageInfo pageInfo;

  YouTubeVideoDetailResponse({
    required this.kind,
    required this.etag,
    required this.items,
    required this.pageInfo,
  });

  factory YouTubeVideoDetailResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeVideoDetailResponse(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => YouTubeVideoDetailModel.fromJson(item))
          .toList() ?? [],
      pageInfo: YouTubePageInfo.fromJson(json['pageInfo']),
    );
  }
}

class YouTubePageInfo {
  final int totalResults;
  final int resultsPerPage;

  YouTubePageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  factory YouTubePageInfo.fromJson(Map<String, dynamic> json) {
    return YouTubePageInfo(
      totalResults: json['totalResults'] ?? 0,
      resultsPerPage: json['resultsPerPage'] ?? 0,
    );
  }
}
