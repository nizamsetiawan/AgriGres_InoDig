import 'package:agrigres/common/widgets/images/t_rounded_image.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:agrigres/features/article/screens/detail_articles/detail_articles.dart';
import 'package:agrigres/utils/constraints/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constraints/colors.dart';
import '../../../utils/constraints/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../icons/t_circular_icon.dart';
import '../texts/option_menu_text.dart';
import '../texts/product_title_text.dart';

class ArticlesListTile extends StatelessWidget {
  const ArticlesListTile({required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: ()=> Get.to(() => DetailArticlesScreen(articleModel: article)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(color: TColors.primary),
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: isDark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          children: [
            ///thumbnail,wishlist button, discount tag
            TRoundedContainer(
              height: 145,
              width: 180,
              padding: const EdgeInsets.all(TSizes.xs),
              backgroundColor: isDark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  ///thumbnail image
                  Center(
                    child: TRoundedImage(
                        imageUrl: article.imageUrl,
                        applyImageRadius: true,
                        isNetworkImage: true),
                  ),

                  const Positioned(
                    top: 0,
                    right: 0,
                    child: TCircularIcon(
                        icon: Iconsax.bookmark, color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            /// -- details
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: article.title, smallSize: true),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  TOptionMenuText(title: article.createdAt),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),

                  // Text(
                  //   'Kategori : ${article.category}',
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .labelSmall!,
                  //
                  // ),
                  TOptionMenuText(
                    title: 'Kategori ${article.category}',
                    color: TColors.secondary,
                    brandTextSize: TextSizes.small,
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
