import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/youtube_channel_model.dart';
import '../controllers/channel_detail_controller.dart';
import '../widgets/video_list_card.dart';
import '../widgets/playlist_card.dart';
import '../widgets/shimmer_loading.dart';

class ChannelDetailScreen extends StatefulWidget {
  final YouTubeChannelModel channel;
  
  const ChannelDetailScreen({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Initialize controller and fetch data
    final controller = Get.put(ChannelDetailController());
    controller.refreshAllData(widget.channel.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Generate color based on channel ID
    final color = _getChannelColor(widget.channel.id);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text(
          widget.channel.title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Subscribe to channel
              Get.snackbar(
                'Berhasil',
                'Berhasil subscribe ke ${widget.channel.title}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Channel Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Channel Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        widget.channel.thumbnails.highUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 40,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Channel Info
                  Text(
                    widget.channel.title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_isVerifiedChannel(widget.channel.id)) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified,
                          color: color,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Channel Terverifikasi',
                          style: textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    widget.channel.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  
                  // Channel Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        context,
                        'Subscriber',
                        _formatNumber(widget.channel.statistics.subscriberCount),
                        Icons.people,
                        color,
                      ),
                      _buildStatItem(
                        context,
                        'Video',
                        widget.channel.statistics.videoCount,
                        Icons.video_library,
                        color,
                      ),
                      _buildStatItem(
                        context,
                        'Views',
                        _formatNumber(widget.channel.statistics.viewCount),
                        Icons.visibility,
                        color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: color,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: color,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Terbaru'),
                  Tab(text: 'Populer'),
                  Tab(text: 'Playlist'),
                ],
              ),
            ),
            
            // Tab Content
            Container(
              height: 400,
              color: Colors.white,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLatestVideos(),
                  _buildPopularVideos(),
                  _buildPlaylists(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildLatestVideos() {
    final controller = Get.find<ChannelDetailController>();
    
    return Obx(() {
      if (controller.isLoadingLatestVideos.value) {
        return const VideoListShimmer();
      }
      
      if (controller.latestVideos.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.video_library_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Tidak ada video terbaru',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.latestVideos.length,
        itemBuilder: (context, index) {
          final video = controller.latestVideos[index];
          return VideoListCard(
            video: video,
            type: 'latest',
          );
        },
      );
    });
  }

  Widget _buildPopularVideos() {
    final controller = Get.find<ChannelDetailController>();
    
    return Obx(() {
      if (controller.isLoadingPopularVideos.value) {
        return const VideoListShimmer();
      }
      
      if (controller.popularVideos.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_up,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Tidak ada video populer',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.popularVideos.length,
        itemBuilder: (context, index) {
          final video = controller.popularVideos[index];
          return VideoListCard(
            video: video,
            type: 'popular',
          );
        },
      );
    });
  }

  Widget _buildPlaylists() {
    final controller = Get.find<ChannelDetailController>();
    
    return Obx(() {
      if (controller.isLoadingPlaylists.value) {
        return const PlaylistShimmer();
      }
      
      if (controller.playlists.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.playlist_play,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Tidak ada playlist',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.playlists.length,
        itemBuilder: (context, index) {
          final playlist = controller.playlists[index];
          return PlaylistCard(playlist: playlist);
        },
      );
    });
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
