import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/agri_edu_controller.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/channel_categories_widget.dart';
import '../widgets/promotional_banner_widget.dart';
import '../widgets/featured_content_widget.dart';

class AgriEduScreen extends StatelessWidget {
  const AgriEduScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.isRegistered<AgriEduController>()
        ? Get.find<AgriEduController>()
        : Get.put(AgriEduController());

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
                child: Obx(() => custom.SearchBar(
                  hintText: 'Cari Materi Pertanian... ',
                  initialValue: controller.searchQuery.value,
                  controller: controller.searchTextController,
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                    if (value.trim().isEmpty) {
                      controller.clearSearch();
                    } else {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (value == controller.searchQuery.value) {
                          controller.searchVideosLocal(value);
                        }
                      });
                    }
                  },
                  onClear: () => controller.clearSearch(),
                  onFilter: () => _showFilterBottomSheet(context, controller),
                )),
              ),
              
              // Channel Categories
              const ChannelCategoriesWidget(),
              
              const SizedBox(height: 24),
              

              
              // Featured Content
              const FeaturedContentWidget(),
              
              const SizedBox(height: 24),
              // Promotional Banner
              const PromotionalBannerWidget(),

              const SizedBox(height: 24),
              
              // Removed Popular Course & Popular Video Lesson per request
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, AgriEduController controller) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Materi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.clearAllFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Kategori',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final categories = controller.categories;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = controller.selectedFilter.value == category;
                  return GestureDetector(
                    onTap: () {
                      controller.filterByCategory(category);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? Colors.orange : Colors.grey[300]!),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
