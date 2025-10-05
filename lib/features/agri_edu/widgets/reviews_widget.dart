import 'package:flutter/material.dart';

class ReviewsWidget extends StatelessWidget {
  final String viewCount;
  final String likeCount;
  final String commentCount;
  final String publishedAt;

  const ReviewsWidget({
    Key? key,
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
          Text(
            'Statistik Video',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          // View Count
          _buildStatItem(
            context,
            textTheme,
            Icons.visibility,
            'Total Views',
            viewCount,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          
          // Like Count
          _buildStatItem(
            context,
            textTheme,
            Icons.thumb_up,
            'Likes',
            likeCount,
            Colors.red,
          ),
          const SizedBox(height: 12),
          
          // Comment Count
          _buildStatItem(
            context,
            textTheme,
            Icons.comment,
            'Comments',
            commentCount,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          
          // Published Date
          _buildStatItem(
            context,
            textTheme,
            Icons.schedule,
            'Dipublikasikan',
            _formatDate(publishedAt),
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    TextTheme textTheme,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
