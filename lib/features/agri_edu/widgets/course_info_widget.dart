import 'package:flutter/material.dart';

class CourseInfoWidget extends StatelessWidget {
  final String title;
  final String channelTitle;
  final String duration;
  final String viewCount;
  final String likeCount;
  final String commentCount;
  final String publishedAt;

  const CourseInfoWidget({
    Key? key,
    required this.title,
    required this.channelTitle,
    required this.duration,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.publishedAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          
          // Channel
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  channelTitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Video Metadata
          Row(
            children: [
              _buildMetadataItem(
                context,
                Icons.access_time,
                duration,
              ),
              const SizedBox(width: 16),
              _buildMetadataItem(
                context,
                Icons.visibility,
                '$viewCount views',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMetadataItem(
                context,
                Icons.thumb_up,
                '$likeCount likes',
              ),
              const SizedBox(width: 16),
              _buildMetadataItem(
                context,
                Icons.comment,
                '$commentCount comments',
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMetadataItem(
            context,
            Icons.schedule,
            _formatDate(publishedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(BuildContext context, IconData icon, String text) {
    final textTheme = Theme.of(context).textTheme;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} tahun lalu';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} bulan lalu';
      } else if (difference.inDays > 7) {
        return '${difference.inDays ~/ 7} minggu lalu';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} hari lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} jam lalu';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return 'Tidak diketahui';
    }
  }
}
