import 'youtube_video_model.dart' as video;
import 'youtube_channel_model.dart' as channel;

class YouTubePlaylistModel {
  final String id;
  final String title;
  final String description;
  final String channelId;
  final String channelTitle;
  final String publishedAt;
  final video.YouTubeThumbnails thumbnails;
  final YouTubePlaylistContentDetails contentDetails;

  YouTubePlaylistModel({
    required this.id,
    required this.title,
    required this.description,
    required this.channelId,
    required this.channelTitle,
    required this.publishedAt,
    required this.thumbnails,
    required this.contentDetails,
  });

  factory YouTubePlaylistModel.fromJson(Map<String, dynamic> json) {
    return YouTubePlaylistModel(
      id: json['id'] ?? '',
      title: json['snippet']?['title'] ?? '',
      description: json['snippet']?['description'] ?? '',
      channelId: json['snippet']?['channelId'] ?? '',
      channelTitle: json['snippet']?['channelTitle'] ?? '',
      publishedAt: json['snippet']?['publishedAt'] ?? '',
      thumbnails: video.YouTubeThumbnails.fromJson(json['snippet']?['thumbnails'] ?? {}),
      contentDetails: YouTubePlaylistContentDetails.fromJson(json['contentDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'channelId': channelId,
      'channelTitle': channelTitle,
      'publishedAt': publishedAt,
      'thumbnails': {},
      'contentDetails': contentDetails.toJson(),
    };
  }
}

class YouTubePlaylistContentDetails {
  final int itemCount;

  YouTubePlaylistContentDetails({
    required this.itemCount,
  });

  factory YouTubePlaylistContentDetails.fromJson(Map<String, dynamic> json) {
    return YouTubePlaylistContentDetails(
      itemCount: json['itemCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemCount': itemCount,
    };
  }
}

class YouTubePlaylistResponse {
  final String kind;
  final String etag;
  final channel.YouTubePageInfo pageInfo;
  final List<YouTubePlaylistModel> items;

  YouTubePlaylistResponse({
    required this.kind,
    required this.etag,
    required this.pageInfo,
    required this.items,
  });

  factory YouTubePlaylistResponse.fromJson(Map<String, dynamic> json) {
    return YouTubePlaylistResponse(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      pageInfo: channel.YouTubePageInfo.fromJson(json['pageInfo'] ?? {}),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => YouTubePlaylistModel.fromJson(item))
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

class YouTubePlaylistItemModel {
  final String id;
  final String title;
  final String description;
  final String channelId;
  final String channelTitle;
  final String publishedAt;
  final video.YouTubeThumbnails thumbnails;
  final YouTubePlaylistItemResourceId resourceId;
  final int position;

  YouTubePlaylistItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.channelId,
    required this.channelTitle,
    required this.publishedAt,
    required this.thumbnails,
    required this.resourceId,
    required this.position,
  });

  factory YouTubePlaylistItemModel.fromJson(Map<String, dynamic> json) {
    return YouTubePlaylistItemModel(
      id: json['id'] ?? '',
      title: json['snippet']?['title'] ?? '',
      description: json['snippet']?['description'] ?? '',
      channelId: json['snippet']?['channelId'] ?? '',
      channelTitle: json['snippet']?['channelTitle'] ?? '',
      publishedAt: json['snippet']?['publishedAt'] ?? '',
      thumbnails: video.YouTubeThumbnails.fromJson(json['snippet']?['thumbnails'] ?? {}),
      resourceId: YouTubePlaylistItemResourceId.fromJson(json['snippet']?['resourceId'] ?? {}),
      position: json['snippet']?['position'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'channelId': channelId,
      'channelTitle': channelTitle,
      'publishedAt': publishedAt,
      'thumbnails': {},
      'resourceId': resourceId.toJson(),
      'position': position,
    };
  }
}

class YouTubePlaylistItemResourceId {
  final String kind;
  final String videoId;

  YouTubePlaylistItemResourceId({
    required this.kind,
    required this.videoId,
  });

  factory YouTubePlaylistItemResourceId.fromJson(Map<String, dynamic> json) {
    return YouTubePlaylistItemResourceId(
      kind: json['kind'] ?? '',
      videoId: json['videoId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'videoId': videoId,
    };
  }
}

class YouTubePlaylistItemsResponse {
  final String kind;
  final String etag;
  final channel.YouTubePageInfo pageInfo;
  final List<YouTubePlaylistItemModel> items;

  YouTubePlaylistItemsResponse({
    required this.kind,
    required this.etag,
    required this.pageInfo,
    required this.items,
  });

  factory YouTubePlaylistItemsResponse.fromJson(Map<String, dynamic> json) {
    return YouTubePlaylistItemsResponse(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      pageInfo: channel.YouTubePageInfo.fromJson(json['pageInfo'] ?? {}),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => YouTubePlaylistItemModel.fromJson(item))
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
