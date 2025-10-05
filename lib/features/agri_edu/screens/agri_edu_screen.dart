import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/agri_edu_controller.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/channel_categories_widget.dart';
import '../widgets/promotional_banner_widget.dart';
import '../widgets/featured_content_widget.dart';
import '../widgets/popular_course_widget.dart';
import '../widgets/popular_video_lesson_widget.dart';

class AgriEduScreen extends StatelessWidget {
  const AgriEduScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.put(AgriEduController());

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
          'AgriEdu',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.refreshVideos(),
            icon: Icon(
              Icons.refresh,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: custom.SearchBar(
                  hintText: 'Cari Materi / Kursus',
                  initialValue: controller.searchQuery.value,
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      controller.clearSearch();
                    } else {
                      // Debounce search
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (value == controller.searchQuery.value) {
                          controller.searchVideos(value);
                        }
                      });
                    }
                  },
                  onClear: () => controller.clearSearch(),
                  onFilter: () {
                    // TODO: Show filter dialog
                    Get.snackbar(
                      'Filter',
                      'Fitur filter akan segera tersedia',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  isLoading: controller.isLoading.value,
                ),
              ),
              
              // Channel Categories
              const ChannelCategoriesWidget(),
              
              const SizedBox(height: 24),
              
              // Promotional Banner
              const PromotionalBannerWidget(),
              
              const SizedBox(height: 24),
              
              // Featured Content
              const FeaturedContentWidget(),
              
              const SizedBox(height: 24),
              
              // Popular Course Section
              const PopularCourseWidget(),
              
              const SizedBox(height: 24),
              
              // Popular Video Lesson Section
              const PopularVideoLessonWidget(),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

}
