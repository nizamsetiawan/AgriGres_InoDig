import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/video_detail_controller.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/course_info_widget.dart';
import '../widgets/tab_navigation_widget.dart';
import '../widgets/curriculum_widget.dart';
import '../widgets/reviews_widget.dart';

class VideoDetailScreen extends StatelessWidget {
  final String videoId;
  final String title;

  const VideoDetailScreen({
    Key? key,
    required this.videoId,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.put(VideoDetailController());
    
    // Initialize video detail
    controller.fetchVideoDetail(videoId);

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
          'Detail Video',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState(context, textTheme);
          }
          
          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState(context, textTheme, controller);
          }
          
          if (controller.videoDetail.value == null) {
            return _buildEmptyState(context, textTheme);
          }
          
          return _buildContent(context, textTheme, controller);
        }),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat detail video...',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, TextTheme textTheme, VideoDetailController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Terjadi kesalahan',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.fetchVideoDetail(videoId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Coba Lagi',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Video tidak ditemukan',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Detail video tidak tersedia',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TextTheme textTheme, VideoDetailController controller) {
    final videoDetail = controller.videoDetail.value!;
    final courseDetails = controller.courseDetails;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Video Player
          Padding(
            padding: const EdgeInsets.all(16),
            child: VideoPlayerWidget(
              videoId: videoId,
              title: videoDetail.title,
              thumbnailUrl: videoDetail.thumbnails.high.url,
            ),
          ),
          
          // Course Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CourseInfoWidget(
              title: videoDetail.title,
              channelTitle: videoDetail.channelTitle,
              duration: videoDetail.contentDetails.formattedDuration,
              viewCount: videoDetail.statistics.formattedViewCount,
              likeCount: videoDetail.statistics.formattedLikeCount,
              commentCount: videoDetail.statistics.commentCount,
              publishedAt: videoDetail.publishedAt,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tab Navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabNavigationWidget(
              selectedIndex: controller.selectedTab.value,
              onTabChanged: controller.changeTab,
              tabs: const ['Deskripsi', 'Kurikulum', 'Review', 'Kursus'],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tab Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTabContent(context, textTheme, controller, videoDetail, courseDetails),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    TextTheme textTheme,
    VideoDetailController controller,
    dynamic videoDetail,
    Map<String, dynamic> courseDetails,
  ) {
    switch (controller.selectedTab.value) {
      case 0: // Deskripsi
        return _buildDescriptionTab(context, textTheme, videoDetail);
      case 1: // Kurikulum
        return CurriculumWidget(
          description: videoDetail.description,
          channelTitle: videoDetail.channelTitle,
          publishedAt: videoDetail.publishedAt,
        );
      case 2: // Review
        return ReviewsWidget(
          viewCount: videoDetail.statistics.formattedViewCount,
          likeCount: videoDetail.statistics.formattedLikeCount,
          commentCount: videoDetail.statistics.commentCount,
          publishedAt: videoDetail.publishedAt,
        );
      case 3: // Kursus
        return _buildCourseTab(context, textTheme, videoDetail);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDescriptionTab(BuildContext context, TextTheme textTheme, dynamic videoDetail) {
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
            'Deskripsi',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            textAlign: TextAlign.justify,
            videoDetail.description,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseTab(BuildContext context, TextTheme textTheme, dynamic videoDetail) {
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
            'Channel Info',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          
          // Channel Title
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Channel: ',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Text(
                  videoDetail.channelTitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Category
          Row(
            children: [
              Icon(
                Icons.category,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Kategori: ',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                videoDetail.categoryId,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Language
          Row(
            children: [
              Icon(
                Icons.language,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Bahasa: ',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                videoDetail.defaultLanguage.toUpperCase(),
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
