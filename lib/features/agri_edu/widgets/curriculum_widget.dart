import 'package:flutter/material.dart';

class CurriculumWidget extends StatelessWidget {
  final String description;
  final String channelTitle;
  final String publishedAt;

  const CurriculumWidget({
    Key? key,
    required this.description,
    required this.channelTitle,
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
            'Informasi Video',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          // Channel Info
          _buildInfoItem(
            context,
            textTheme,
            Icons.person,
            'Channel',
            channelTitle,
          ),
          const SizedBox(height: 12),
          
          // Published Date
          _buildInfoItem(
            context,
            textTheme,
            Icons.schedule,
            'Dipublikasikan',
            _formatDate(publishedAt),
          ),
          const SizedBox(height: 12),
          
          // Description
          _buildInfoItem(
            context,
            textTheme,
            Icons.description,
            'Deskripsi',
            description,
            isDescription: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    TextTheme textTheme,
    IconData icon,
    String label,
    String value, {
    bool isDescription = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              height: isDescription ? 1.5 : 1.2,
            ),
            maxLines: isDescription ? null : 2,
            overflow: isDescription ? null : TextOverflow.ellipsis,
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
