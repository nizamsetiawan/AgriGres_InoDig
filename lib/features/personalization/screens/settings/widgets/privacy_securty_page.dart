import 'package:flutter/material.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/texts/option_menu_text.dart';
import '../../../../../common/widgets/texts/product_title_text.dart';
import '../../../../../utils/constraints/text_strings.dart';

class PrivacyAndSecurityPage extends StatelessWidget {
  const PrivacyAndSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text("Privasi dan Keamanan"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.privacyAndSecurityTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TOptionMenuText(
                title: TTexts.privacyAndSecurityDescription,
                maxLines: 10,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              _buildSection(
                title: TTexts.dataCollectionTitle,
                content: TTexts.dataCollectionContent,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              _buildSection(
                title: TTexts.dataProtectionTitle,
                content: TTexts.dataProtectionContent,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              _buildSection(
                title: TTexts.privacyPolicyTitle,
                content: TTexts.privacyPolicyContent,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              _buildSection(
                title: TTexts.userControlTitle,
                content: TTexts.userControlContent,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              _buildSection(
                title: TTexts.thirdPartyDataSharingTitle,
                content: TTexts.thirdPartyDataSharingContent,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              _buildSection(
                title: TTexts.securityFeaturesTitle,
                content: TTexts.securityFeaturesContent,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              _buildSection(
                title: TTexts.contactUsTitle,
                content: TTexts.contactUsContent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: TColors.primary,
          ),
        ),
        const SizedBox(height: 8),

        TProductTitleText(
          title: content,
          textAlign: TextAlign.justify,
          smallSize: true,
          maxLines: 1000,
        ),
      ],
    );
  }
}
