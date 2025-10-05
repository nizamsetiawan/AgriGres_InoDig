import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/agri_edu_controller.dart';
import '../widgets/video_list_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/load_more_indicator.dart';

class FeaturedVideosScreen extends StatefulWidget {
  const FeaturedVideosScreen({Key? key}) : super(key: key);

  @override
  State<FeaturedVideosScreen> createState() => _FeaturedVideosScreenState();
}

class _FeaturedVideosScreenState extends State<FeaturedVideosScreen> {
  final ScrollController _scrollController = ScrollController();
  final AgriEduController _controller = Get.find<AgriEduController>();
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Load more videos when near bottom
      _loadMoreVideos();
    }
  }

  Future<void> _loadMoreVideos() async {
    // TODO: Implement load more functionality
    // For now, just refresh the list
    await _controller.fetchFeaturedVideos();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          'Konten Unggulan',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _controller.refreshVideos(),
            icon: Icon(
              Icons.refresh,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoadingFeaturedVideos.value) {
            return const VideoListShimmer();
          }
          
          if (_controller.featuredVideos.isEmpty) {
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
                    'Tidak ada video tersedia',
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
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _controller.featuredVideos.length + 1, // +1 for load more
            itemBuilder: (context, index) {
              if (index == _controller.featuredVideos.length) {
                return LoadMoreIndicator(
                  isLoading: _controller.isLoadingFeaturedVideos.value,
                  hasMore: true,
                  onLoadMore: _loadMoreVideos,
                  type: 'videos',
                );
              }
              
              final video = _controller.featuredVideos[index];
              return VideoListCard(
                video: video,
                type: 'featured',
              );
            },
          );
        }),
      ),
    );
  }
}
