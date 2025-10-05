import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/youtube_video_model.dart';
import '../models/youtube_video_detail_model.dart';
import '../models/youtube_playlist_model.dart';
import '../../../routes/routes.dart';

class VideoListCard extends StatelessWidget {
  final dynamic video; // Can be YouTubeVideoModel, YouTubeVideoDetailModel, or YouTubePlaylistItemModel
  final String type; // 'latest', 'popular', 'playlist'
  
  const VideoListCard({
    Key? key,
    required this.video,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return GestureDetector(
      onTap: () => _handleVideoTap(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: Stack(
                children: [
                  Image.network(
                    _getThumbnailUrl(),
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 80,
                        color: Colors.grey[100],
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 24,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                  // Duration overlay
                  if (_getDuration() != null)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          _getDuration()!,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      _getTitle(),
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    
                    // Channel
                    Text(
                      _getChannelTitle(),
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Stats and date
                    Row(
                      children: [
                        if (_getViewCount() != null) ...[
                          Icon(
                            Icons.visibility_outlined,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _getViewCount()!,
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Icon(
                          Icons.access_time_outlined,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getPublishedDate(),
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Play button
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVideoTap() {
    final videoId = _getVideoId();
    final title = _getTitle();
    
    if (videoId.isNotEmpty) {
      Get.toNamed(TRoutes.videoDetail, arguments: {
        'videoId': videoId,
        'title': title,
      });
    }
  }

  String _getThumbnailUrl() {
    switch (type) {
      case 'latest':
        if (video is YouTubeVideoModel) {
          return (video as YouTubeVideoModel).thumbnails.high.url;
        }
        break;
      case 'popular':
        if (video is YouTubeVideoDetailModel) {
          return (video as YouTubeVideoDetailModel).thumbnails.high.url;
        }
        break;
      case 'playlist':
        if (video is YouTubePlaylistItemModel) {
          return (video as YouTubePlaylistItemModel).thumbnails.high.url;
        }
        break;
    }
    return '';
  }

  String _getTitle() {
    switch (type) {
      case 'latest':
        if (video is YouTubeVideoModel) {
          return (video as YouTubeVideoModel).title;
        }
        break;
      case 'popular':
        if (video is YouTubeVideoDetailModel) {
          return (video as YouTubeVideoDetailModel).title;
        }
        break;
      case 'playlist':
        if (video is YouTubePlaylistItemModel) {
          return (video as YouTubePlaylistItemModel).title;
        }
        break;
    }
    return 'Video Title';
  }

  String _getChannelTitle() {
    switch (type) {
      case 'latest':
        if (video is YouTubeVideoModel) {
          return (video as YouTubeVideoModel).channelTitle;
        }
        break;
      case 'popular':
        if (video is YouTubeVideoDetailModel) {
          return (video as YouTubeVideoDetailModel).channelTitle;
        }
        break;
      case 'playlist':
        if (video is YouTubePlaylistItemModel) {
          return (video as YouTubePlaylistItemModel).channelTitle;
        }
        break;
    }
    return 'Channel Name';
  }

  String _getVideoId() {
    switch (type) {
      case 'latest':
        if (video is YouTubeVideoModel) {
          return (video as YouTubeVideoModel).videoId;
        }
        break;
      case 'popular':
        if (video is YouTubeVideoDetailModel) {
          return (video as YouTubeVideoDetailModel).videoId;
        }
        break;
      case 'playlist':
        if (video is YouTubePlaylistItemModel) {
          return (video as YouTubePlaylistItemModel).resourceId.videoId;
        }
        break;
    }
    return '';
  }

  String? _getDuration() {
    switch (type) {
      case 'popular':
        if (video is YouTubeVideoDetailModel) {
          return _formatDuration((video as YouTubeVideoDetailModel).contentDetails.duration);
        }
        break;
      default:
        return null;
    }
    return null;
  }

  String? _getViewCount() {
    switch (type) {
      case 'popular':
        if (video is YouTubeVideoDetailModel) {
          return _formatNumber((video as YouTubeVideoDetailModel).statistics.viewCount);
        }
        break;
      default:
        return null;
    }
    return null;
  }

  String _getPublishedDate() {
    String publishedAt = '';
    switch (type) {
      case 'latest':
        if (video is YouTubeVideoModel) {
          publishedAt = (video as YouTubeVideoModel).publishedAt;
        }
        break;
      case 'popular':
        if (video is YouTubeVideoDetailModel) {
          publishedAt = (video as YouTubeVideoDetailModel).publishedAt;
        }
        break;
      case 'playlist':
        if (video is YouTubePlaylistItemModel) {
          publishedAt = (video as YouTubePlaylistItemModel).publishedAt;
        }
        break;
    }
    return _formatDate(publishedAt);
  }

  String _formatDuration(String duration) {
    // Convert ISO 8601 duration (PT15M32S) to readable format (15:32)
    if (duration.startsWith('PT')) {
      final cleanDuration = duration.substring(2);
      final hours = RegExp(r'(\d+)H').firstMatch(cleanDuration)?.group(1);
      final minutes = RegExp(r'(\d+)M').firstMatch(cleanDuration)?.group(1);
      final seconds = RegExp(r'(\d+)S').firstMatch(cleanDuration)?.group(1);
      
      if (hours != null) {
        return '${hours}:${minutes?.padLeft(2, '0') ?? '00'}:${seconds?.padLeft(2, '0') ?? '00'}';
      } else if (minutes != null) {
        return '${minutes}:${seconds?.padLeft(2, '0') ?? '00'}';
      } else if (seconds != null) {
        return '0:${seconds.padLeft(2, '0')}';
      }
    }
    return duration;
  }

  String _formatNumber(String number) {
    final num = int.tryParse(number) ?? 0;
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M views';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K views';
    }
    return '$num views';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years tahun yang lalu';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months bulan yang lalu';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} hari yang lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} jam yang lalu';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} menit yang lalu';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return 'Tanggal tidak valid';
    }
  }
}
