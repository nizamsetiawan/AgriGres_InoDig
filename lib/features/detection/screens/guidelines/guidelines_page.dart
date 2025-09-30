import 'package:flutter/material.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/common/widgets/texts/product_title_text.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

import '../../../../utils/constraints/text_strings.dart';

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text("Panduan Penggunaan"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.guidelinesTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: TColors.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildStepSection(
                context,
                TTexts.step1Title,
                TTexts.step1Description,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildStepSection(
                context,
                TTexts.step2Title,
                TTexts.step2Description,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildStepSection(
                context,
                TTexts.step3Title,
                TTexts.step3Description,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildStepSection(
                context,
                TTexts.step4Title,
                TTexts.step4Description,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildStepSection(
                context,
                TTexts.step5Title,
                TTexts.step5Description,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildStepSection(
                context,
                TTexts.additionalFeatureHistoryTitle,
                TTexts.additionalFeatureHistoryDescription,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildStepSection(
                context,
                TTexts.additionalFeatureArticleTitle,
                TTexts.additionalFeatureArticleDescription,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          )

        ),
      ),
    );
  }

  Widget _buildStepSection(BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: TColors.primary,
          ),
        ),
        const SizedBox(height: 8),

        TProductTitleText(
          title: description,
          textAlign: TextAlign.justify,
          smallSize: true,
          maxLines: 1000,
        ),
      ],
    );
  }
}
