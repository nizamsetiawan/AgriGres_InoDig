import 'package:agrigres/features/article/screens/category_articles/category_articles.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
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
        
        // Categories from Controller
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

            return SizedBox(
              height: 80,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoryController.featuredCategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final category = categoryController.featuredCategories[index];
                  final colors = categoryColors[index % categoryColors.length];
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < categoryController.featuredCategories.length - 1 ? 12 : 0,
                    ),
                    child: _buildCategoryCard(
                      context,
                      category.name,
                      category.image,
                      colors[0], // background
                      colors[1], // border
                      Colors.grey[600]!,
                      () => Get.to(() => ArticleByCategoryScreen(), arguments: category.name),
                    ),
                  );
                },
              ),
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
}