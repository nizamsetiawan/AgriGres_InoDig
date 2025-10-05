import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/agri_edu_controller.dart';
import 'course_card_widget.dart';
import '../../../utils/constraints/colors.dart';

class PopularCourseWidget extends StatefulWidget {
  const PopularCourseWidget({Key? key}) : super(key: key);

  @override
  State<PopularCourseWidget> createState() => _PopularCourseWidgetState();
}

class _PopularCourseWidgetState extends State<PopularCourseWidget> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.put(AgriEduController());
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Course',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all courses
                },
                child: Text(
                  'Lihat Semua >',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Category Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryTab('Semua', 0),
                const SizedBox(width: 8),
                _buildCategoryTab('Terbaru', 1),
                const SizedBox(width: 8),
                _buildCategoryTab('Populer', 2),
                const SizedBox(width: 8),
                _buildCategoryTab('Terlama', 3),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Course Cards
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }
            
            if (controller.videos.isEmpty) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Belum ada course tersedia',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.videos.length,
                itemBuilder: (context, index) {
                  final video = controller.videos[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < controller.videos.length - 1 ? 12 : 0,
                    ),
                    child: CourseCardWidget(
                      video: video,
                      onTap: () {
                        Get.toNamed('/video-detail', arguments: {
                          'videoId': video.videoId,
                          'title': video.title,
                        });
                      },
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, int index) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
        // TODO: Implement filtering logic based on selected tab
        _handleTabSelection(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _handleTabSelection(int index) {
    // TODO: Implement filtering logic
    switch (index) {
      case 0: // Semua
        // Show all videos
        break;
      case 1: // Terbaru
        // Sort by newest
        break;
      case 2: // Populer
        // Sort by most popular
        break;
      case 3: // Terlama
        // Sort by oldest
        break;
    }
  }
}
