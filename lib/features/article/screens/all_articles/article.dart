import 'package:agrigres/common/widgets/list_tiles/articles_list_tile.dart';
import 'package:agrigres/features/article/controllers/articles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/loaders/vertical_product_shimmer.dart';
import '../../../../utils/constraints/sizes.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articleController = Get.put(ArticleController());
    articleController.fetchAllArticles();


    return Scaffold(
      appBar: const TAppBar(
        title: Text('Artikel Pertanian'),
      ),
      body: Padding(
          padding:  const EdgeInsets.only(left: TSizes.defaultSpace, right: TSizes.defaultSpace, bottom: TSizes.defaultSpace),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: TSizes.spaceBtwSections),
                Obx(() {
                  if (articleController.isLoading.value)
                    return const TVVerticalArticleShimmer();
                  return TGridLayout(
                      itemCount: articleController.allArticles.length,
                      itemBuilder: (_, index) => ArticlesListTile(
                          article: articleController.allArticles[index]));
                })
              ],
            ),
          )),
    );
  }
}
