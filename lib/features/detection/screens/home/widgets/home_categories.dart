import 'package:agrigres/features/article/screens/category_articles/category_articles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Obx(
      () {
        if(categoryController.isLoading.value) return const TCategoryShimmer();

        if(categoryController.featuredCategories.isEmpty){
          return Center(child: Text('No data found!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
        }
        return SizedBox(
          height: 80,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categoryController.featuredCategories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final category = categoryController.featuredCategories[index];
              return TVerticalImageText(
                image: category.image,
                title: category.name,
                onTap: () => Get.to(() => ArticleByCategoryScreen(), arguments: category.name)
              );
            },
          ),
        );
      }
    );
  }
}