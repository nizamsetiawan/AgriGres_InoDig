import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/youtube_channel_model.dart';
import '../controllers/agri_edu_controller.dart';
import '../screens/channel_detail_screen.dart';

class ChannelCategoriesWidget extends StatelessWidget {
  const ChannelCategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<AgriEduController>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Channel Kategori',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Pilih channel favorit Anda',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          
          Obx(() {
            if (controller.isLoadingChannels.value) {
              return const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (controller.channels.isEmpty) {
              return GestureDetector(
                onTap: () {
                  print('Refreshing channels...');
                  controller.refreshChannels();
                },
                child: SizedBox(
                  height: 120,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada channel tersedia',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap untuk refresh',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            
            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.channels.length,
                itemBuilder: (context, index) {
                  final channel = controller.channels[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < controller.channels.length - 1 ? 12 : 0,
                    ),
                    child: _buildChannelCard(context, channel),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChannelCard(BuildContext context, YouTubeChannelModel channel) {
    final textTheme = Theme.of(context).textTheme;
    
    // Generate color based on channel ID
    final color = _getChannelColor(channel.id);
    
    return GestureDetector(
      onTap: () {
        Get.to(() => ChannelDetailScreen(channel: channel));
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      channel.thumbnails.defaultUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 16,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel.title,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getChannelCategory(channel.title),
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isVerifiedChannel(channel.id))
                  Icon(
                    Icons.verified,
                    color: color,
                    size: 14,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getShortDescription(channel.description),
              style: textTheme.bodySmall?.copyWith(
                color: Colors.black87,
                fontSize: 10,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatNumber(channel.statistics.subscriberCount)} subs',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 9,
                  ),
                ),
                Text(
                  '${channel.statistics.videoCount} videos',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getChannelColor(String channelId) {
    // Generate consistent color based on channel ID
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.lime,
      Colors.deepOrange,
    ];
    
    final index = channelId.hashCode % colors.length;
    return colors[index];
  }

  String _getChannelCategory(String title) {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('pertanian') || titleLower.contains('agriculture')) {
      return 'Pertanian';
    } else if (titleLower.contains('hidroponik') || titleLower.contains('hydroponic')) {
      return 'Hidroponik';
    } else if (titleLower.contains('organik') || titleLower.contains('organic')) {
      return 'Organik';
    } else if (titleLower.contains('urban') || titleLower.contains('kota')) {
      return 'Urban';
    } else if (titleLower.contains('aquaponik') || titleLower.contains('aquaponic')) {
      return 'Aquaponik';
    } else if (titleLower.contains('teknologi') || titleLower.contains('tech')) {
      return 'Teknologi';
    } else if (titleLower.contains('tips') || titleLower.contains('tutorial')) {
      return 'Tips';
    } else if (titleLower.contains('greenhouse')) {
      return 'Greenhouse';
    } else if (titleLower.contains('pascapanen') || titleLower.contains('postharvest')) {
      return 'Pascapanen';
    } else {
      return 'Pertanian';
    }
  }

  String _getShortDescription(String description) {
    if (description.length > 100) {
      return '${description.substring(0, 100)}...';
    }
    return description;
  }

  String _formatNumber(String number) {
    final num = int.tryParse(number) ?? 0;
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return num.toString();
  }

  bool _isVerifiedChannel(String channelId) {
    // List of verified channels
    const verifiedChannels = [
      'UCrOkSpB5JDBCUrZaOzbsUcw', // Mitra Pertanian
      'UCdPDUMhCqE6hW2Ja39EJQOw',
      'UCPtpZkU1fNgdW2VUZz6boHw',
    ];
    return verifiedChannels.contains(channelId);
  }
}
