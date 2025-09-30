import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/common/widgets/texts/product_title_text.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../common/widgets/texts/option_menu_text.dart';
import '../../../../utils/constraints/sizes.dart';

class DetailArticlesScreen extends StatelessWidget {
  const DetailArticlesScreen({super.key, required this.articleModel});

  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text("Detail Artikel"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  TRoundedImage(
                      imageUrl: articleModel.imageUrl,
                      isNetworkImage: true,
                      width: double.infinity,
                      applyImageRadius: true),
                  Positioned(
                    top: 12,
                    child: TRoundedContainer(
                      radius: TSizes.sm,
                      backgroundColor: TColors.primary.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm, vertical: TSizes.xs),
                      child: Text('Kategori - ${articleModel.category}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: TColors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Text(
                articleModel.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: TSizes.borderRadiusLg,
              ),
              TOptionMenuText(
                title: articleModel.createdAt,
                color: TColors.primary,
              ),
              const SizedBox(
                height: TSizes.borderRadiusLg,
              ),
              TProductTitleText(
                title: articleModel.content,
                textAlign: TextAlign.justify,
                smallSize: true,
                maxLines: 1000,
              ),
              const SizedBox(
                height: TSizes.borderRadiusLg,
              ),
              TOptionMenuText(
                textAlign: TextAlign.start,
                maxLines: 2,
                title: 'Penulis : ${articleModel.author}',
                color: TColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
