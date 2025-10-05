class YouTubeVideoModel {
  final String videoId;
  final String title;
  final String description;
  final String channelTitle;
  final String publishedAt;
  final String publishTime;
  final YouTubeThumbnails thumbnails;

  YouTubeVideoModel({
    required this.videoId,
    required this.title,
    required this.description,
    required this.channelTitle,
    required this.publishedAt,
    required this.publishTime,
    required this.thumbnails,
  });

  factory YouTubeVideoModel.fromJson(Map<String, dynamic> json) {
    return YouTubeVideoModel(
      videoId: json['id']['videoId'] ?? '',
      title: json['snippet']['title'] ?? '',
      description: json['snippet']['description'] ?? '',
      channelTitle: json['snippet']['channelTitle'] ?? '',
      publishedAt: json['snippet']['publishedAt'] ?? '',
      publishTime: json['snippet']['publishTime'] ?? '',
      thumbnails: YouTubeThumbnails.fromJson(json['snippet']['thumbnails']),
    );
  }
}

class YouTubeThumbnails {
  final YouTubeThumbnail defaultThumbnail;
  final YouTubeThumbnail medium;
  final YouTubeThumbnail high;

  YouTubeThumbnails({
    required this.defaultThumbnail,
    required this.medium,
    required this.high,
  });

  factory YouTubeThumbnails.fromJson(Map<String, dynamic> json) {
    return YouTubeThumbnails(
      defaultThumbnail: YouTubeThumbnail.fromJson(json['default']),
      medium: YouTubeThumbnail.fromJson(json['medium']),
      high: YouTubeThumbnail.fromJson(json['high']),
    );
  }
}

class YouTubeThumbnail {
  final String url;
  final int width;
  final int height;

  YouTubeThumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory YouTubeThumbnail.fromJson(Map<String, dynamic> json) {
    return YouTubeThumbnail(
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}

class YouTubeSearchResponse {
  final String kind;
  final String etag;
  final String? nextPageToken;
  final String regionCode;
  final YouTubePageInfo pageInfo;
  final List<YouTubeVideoModel> items;

  YouTubeSearchResponse({
    required this.kind,
    required this.etag,
    this.nextPageToken,
    required this.regionCode,
    required this.pageInfo,
    required this.items,
  });

  factory YouTubeSearchResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeSearchResponse(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      nextPageToken: json['nextPageToken'],
      regionCode: json['regionCode'] ?? '',
      pageInfo: YouTubePageInfo.fromJson(json['pageInfo']),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => YouTubeVideoModel.fromJson(item))
          .toList() ?? [],
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
