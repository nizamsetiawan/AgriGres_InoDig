class YouTubeChannelModel {
  final String id;
  final String title;
  final String description;
  final String customUrl;
  final String publishedAt;
  final YouTubeChannelThumbnails thumbnails;
  final YouTubeChannelStatistics statistics;
  final YouTubeChannelBrandingSettings brandingSettings;
  final String country;

  YouTubeChannelModel({
    required this.id,
    required this.title,
    required this.description,
    required this.customUrl,
    required this.publishedAt,
    required this.thumbnails,
    required this.statistics,
    required this.brandingSettings,
    required this.country,
  });

  factory YouTubeChannelModel.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelModel(
      id: json['id'] ?? '',
      title: json['snippet']?['title'] ?? '',
      description: json['snippet']?['description'] ?? '',
      customUrl: json['snippet']?['customUrl'] ?? '',
      publishedAt: json['snippet']?['publishedAt'] ?? '',
      thumbnails: YouTubeChannelThumbnails.fromJson(json['snippet']?['thumbnails'] ?? {}),
      statistics: YouTubeChannelStatistics.fromJson(json['statistics'] ?? {}),
      brandingSettings: YouTubeChannelBrandingSettings.fromJson(json['brandingSettings'] ?? {}),
      country: json['snippet']?['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'customUrl': customUrl,
      'publishedAt': publishedAt,
      'thumbnails': thumbnails.toJson(),
      'statistics': statistics.toJson(),
      'brandingSettings': brandingSettings.toJson(),
      'country': country,
    };
  }
}

class YouTubeChannelThumbnails {
  final String defaultUrl;
  final String mediumUrl;
  final String highUrl;

  YouTubeChannelThumbnails({
    required this.defaultUrl,
    required this.mediumUrl,
    required this.highUrl,
  });

  factory YouTubeChannelThumbnails.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelThumbnails(
      defaultUrl: json['default']?['url'] ?? '',
      mediumUrl: json['medium']?['url'] ?? '',
      highUrl: json['high']?['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'default': {'url': defaultUrl},
      'medium': {'url': mediumUrl},
      'high': {'url': highUrl},
    };
  }
}

class YouTubeChannelStatistics {
  final String viewCount;
  final String subscriberCount;
  final bool hiddenSubscriberCount;
  final String videoCount;

  YouTubeChannelStatistics({
    required this.viewCount,
    required this.subscriberCount,
    required this.hiddenSubscriberCount,
    required this.videoCount,
  });

  factory YouTubeChannelStatistics.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelStatistics(
      viewCount: json['viewCount'] ?? '0',
      subscriberCount: json['subscriberCount'] ?? '0',
      hiddenSubscriberCount: json['hiddenSubscriberCount'] ?? false,
      videoCount: json['videoCount'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viewCount': viewCount,
      'subscriberCount': subscriberCount,
      'hiddenSubscriberCount': hiddenSubscriberCount,
      'videoCount': videoCount,
    };
  }
}

class YouTubeChannelBrandingSettings {
  final String title;
  final String description;
  final String keywords;
  final String unsubscribedTrailer;
  final String country;
  final String? bannerExternalUrl;

  YouTubeChannelBrandingSettings({
    required this.title,
    required this.description,
    required this.keywords,
    required this.unsubscribedTrailer,
    required this.country,
    this.bannerExternalUrl,
  });

  factory YouTubeChannelBrandingSettings.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelBrandingSettings(
      title: json['channel']?['title'] ?? '',
      description: json['channel']?['description'] ?? '',
      keywords: json['channel']?['keywords'] ?? '',
      unsubscribedTrailer: json['channel']?['unsubscribedTrailer'] ?? '',
      country: json['channel']?['country'] ?? '',
      bannerExternalUrl: json['image']?['bannerExternalUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': {
        'title': title,
        'description': description,
        'keywords': keywords,
        'unsubscribedTrailer': unsubscribedTrailer,
        'country': country,
      },
      'image': bannerExternalUrl != null ? {'bannerExternalUrl': bannerExternalUrl} : null,
    };
  }
}

class YouTubeChannelListResponse {
  final String kind;
  final String etag;
  final YouTubePageInfo pageInfo;
  final List<YouTubeChannelModel> items;

  YouTubeChannelListResponse({
    required this.kind,
    required this.etag,
    required this.pageInfo,
    required this.items,
  });

  factory YouTubeChannelListResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelListResponse(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      pageInfo: YouTubePageInfo.fromJson(json['pageInfo'] ?? {}),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => YouTubeChannelModel.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'etag': etag,
      'pageInfo': pageInfo.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'totalResults': totalResults,
      'resultsPerPage': resultsPerPage,
    };
  }
}
