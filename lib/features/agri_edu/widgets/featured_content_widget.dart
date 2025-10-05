import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/agri_edu_controller.dart';
import '../models/youtube_video_model.dart';
import '../../../utils/constraints/colors.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedContentWidget extends StatelessWidget {
  const FeaturedContentWidget({Key? key}) : super(key: key);

  Color _getChannelColor(String channelId) {
    // Use app primary color for consistency
    return TColors.primary;
  }

  Widget _buildFeaturedShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.grey[300]),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(height: 14, width: 200, color: Colors.white),
                            const SizedBox(height: 8),
                            Container(height: 14, width: 160, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChannelChipsShimmer() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.start,
              children: List.generate(3, (index) => index).map((_) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: 80,
                      height: 12,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetChipsShimmer() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(8, (index) => index).map((_) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 90,
              height: 12,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<AgriEduController>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Konten Unggulan',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [

                  IconButton(
                    onPressed: () => _showChannelFilterBottomSheet(context, controller),
                    icon: const Icon(Icons.filter_list, size: 18),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.open_in_new, size: 18),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Obx(() {
            if (controller.isLoadingChannels.value) {
              return _buildChannelChipsShimmer();
            }
            final channels = controller.channels;
            if (channels.isEmpty) return const SizedBox(height: 8);
            final selectedId = controller.selectedFeaturedChannelId.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedId.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            alignment: WrapAlignment.start,
                            children: channels
                                .where((c) => c.id == selectedId)
                                .map((c) {
                              final color = _getChannelColor(c.id);
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        c.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => controller.clearFeaturedSelection(),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if (selectedId.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextButton(
                              onPressed: () => controller.clearFeaturedSelection(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Hapus',
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                // Trigger to open bottom sheet filter
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: TextButton.icon(
                //     onPressed: () => _showChannelFilterBottomSheet(context, controller),
                //     icon: const Icon(Icons.filter_list, size: 18),
                //     label: const Text('Filter Channel'),
                //     style: TextButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //       minimumSize: Size.zero,
                //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //     ),
                //   ),
                // ),
              ],
            );
          }),

          const SizedBox(height: 12),

          SizedBox(
            height: 200,
            child: Obx(() {
              if (controller.isLoadingFeaturedChannel.value) {
                return _buildFeaturedShimmer();
              }
              final items = controller.featuredChannelVideos;
              if (items.isEmpty) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Silahkan pilih channel untuk melihat konten unggulan',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final video = items[index];
                  final color = _getChannelColor(controller.selectedFeaturedChannelId.value);
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < items.length - 1 ? 12 : 0,
                    ),
                    child: _buildVideoFeaturedCard(context, video, color),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showChannelFilterBottomSheet(BuildContext context, AgriEduController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Channel',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoadingChannels.value) {
                return _buildBottomSheetChipsShimmer();
              }
              final channels = controller.channels;
              if (channels.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Belum ada channel tersedia',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                );
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: channels.take(20).map((c) {
                  final isSelected = controller.selectedFeaturedChannelId.value == c.id;
                  final color = _getChannelColor(c.id);
                  return GestureDetector(
                    onTap: () {
                      controller.setFeaturedChannel(c.id);
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? color : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            c.title,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.check, color: Colors.white, size: 14),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearFeaturedSelection();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: Text('Hapus', style: TextStyle(color: Colors.grey[700])),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoFeaturedCard(BuildContext context, YouTubeVideoModel video, Color color) {
    final textTheme = Theme.of(context).textTheme;
    final imageUrl = video.thumbnails.high.url;
    return GestureDetector(
      onTap: () {
        // Navigate to video detail via routes
        Get.toNamed('/video-detail', arguments: {
          'videoId': video.videoId,
          'title': video.title,
        });
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: color.withOpacity(0.1)),
                    )
                  : Container(color: Colors.grey[200]),
              // Gradient overlay
              Container(color: Colors.black.withOpacity(0.35)),
              // Text content
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        video.title,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Channel chip styled like filter chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          video.channelTitle,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Play button
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
