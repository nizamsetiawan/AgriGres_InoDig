import 'package:agrigres/features/article/controllers/articles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/navigation_menu.dart';

import '../../../../../common/widgets/loaders/category_shimmer.dart';
import '../../../controllers/category_controller.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final textTheme = Theme.of(context).textTheme;
    
    // Define colors for categories
    final List<List<Color>> categoryColors = [
      [Colors.pink[50]!, Colors.pink[100]!, Colors.pink[700]!],
      [Colors.indigo[50]!, Colors.indigo[100]!, Colors.indigo[700]!],
      [Colors.amber[50]!, Colors.amber[100]!, Colors.amber[700]!],
      [Colors.red[50]!, Colors.red[100]!, Colors.red[700]!],
      [Colors.cyan[50]!, Colors.cyan[100]!, Colors.cyan[700]!],
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Artikel',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Pusat Bacaan & Edukasi',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        
        // Categories from Controller - 2 rows with 5 items each
        Obx(
          () {
            if (categoryController.isLoading.value) {
              return const TCategoryShimmer();
            }

            if (categoryController.featuredCategories.isEmpty) {
              return Center(
                child: Text(
                  'No data found!',
                  style: textTheme.bodyMedium,
                ),
              );
            }

            // Show only first 10 categories (2 rows x 5 items)
            final displayCategories = categoryController.featuredCategories.take(10).toList();
            final hasMoreCategories = categoryController.allCategories.where((category) => category.parentId.isEmpty).length > 10;

            return Column(
              children: [
                // First Row (5 items)
                Row(
                  children: List.generate(
                    displayCategories.length > 5 ? 5 : displayCategories.length,
                    (index) {
                      final category = displayCategories[index];
                      final colors = categoryColors[index % categoryColors.length];
                      
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index < 4 ? 8 : 0,
                          ),
                          child: _buildCategoryCard(
                            context,
                            category.name,
                            category.image,
                            colors[0], // background
                            colors[1], // border
                            Colors.grey[600]!,
                            () => _navigateToArticlesWithFilter(category.name),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Second Row (remaining items, max 5)
                if (displayCategories.length > 5) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      displayCategories.length - 5,
                      (index) {
                        final category = displayCategories[index + 5];
                        final colors = categoryColors[(index + 5) % categoryColors.length];
                        
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index < 4 ? 8 : 0,
                            ),
                            child: _buildCategoryCard(
                              context,
                              category.name,
                              category.image,
                              colors[0], // background
                              colors[1], // border
                              Colors.grey[600]!,
                              () => _navigateToArticlesWithFilter(category.name),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                
                // View More Button (if more than 10 categories)
                if (hasMoreCategories) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _showAllCategoriesPopup(context, categoryController),
                      icon: const Icon(Icons.expand_more, size: 18),
                      label: const Text('Lihat Semua Kategori'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String imageUrl,
    Color backgroundColor,
    Color borderColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? Icon(
                    Icons.category,
                    color: textColor,
                    size: 24,
                  )
                : null,
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to articles screen with category filter active
  void _navigateToArticlesWithFilter(String categoryName) {
    // Initialize ArticleController and set filter
    final articleController = Get.put(ArticleController());
    articleController.filterByCategory(categoryName);
    
    // Navigate to articles tab in navigation menu (index 3)
    final navigationController = Get.find<NavigationController>();
    navigationController.selectedIndex.value = 3;
  }

  // Show all categories popup
  void _showAllCategoriesPopup(BuildContext context, CategoryController controller) {
    final textTheme = Theme.of(context).textTheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 32,
              height: 3,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Semua Kategori',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),
            
            // Categories List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  );
                }

                final allParentCategories = controller.allCategories.where((category) => category.parentId.isEmpty).toList();
                
                if (allParentCategories.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada kategori tersedia',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: allParentCategories.length,
                  itemBuilder: (context, index) {
                    final category = allParentCategories[index];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToArticlesWithFilter(category.name);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!, width: 0.5),
                            ),
                            child: Row(
                              children: [
                                // Category Icon/Image
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(6),
                                    image: category.image.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(category.image),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: category.image.isEmpty
                                      ? Icon(
                                          Icons.category_outlined,
                                          color: Colors.grey[600],
                                          size: 16,
                                        )
                                      : null,
                                ),
                                
                                const SizedBox(width: 12),
                                
                                // Category Name
                                Expanded(
                                  child: Text(
                                    category.name,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                
                                // Arrow Icon
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}