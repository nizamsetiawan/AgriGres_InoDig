import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/common/widgets/images/t_rounded_image.dart';
import 'package:agrigres/common/widgets/texts/product_title_text.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import '../../../../../common/widgets/texts/option_menu_text.dart';
import '../../../../../utils/constraints/text_strings.dart';

class AboutAPPPage extends StatelessWidget {
  const AboutAPPPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text("Tentang Aplikasi"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: TRoundedImage(
                  imageUrl: TImages.appLogoDark,
                  width: 200,
                  applyImageRadius: true,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Content Section
              TProductTitleText(
                title: TTexts.aboutAppDescription,
                textAlign: TextAlign.justify,
                smallSize: true,
                maxLines: 1000,
              ),
              const SizedBox(height: TSizes.borderRadiusLg),

              // Developer information or additional info
              TOptionMenuText(
                title: 'Pengembang: Tim Pengembang agrigres',
                color: TColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
