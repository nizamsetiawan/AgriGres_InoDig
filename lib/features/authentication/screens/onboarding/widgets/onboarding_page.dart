import 'package:agrigres/utils/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:agrigres/features/authentication/controllers/onboarding_controller.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Padding(
      padding: const EdgeInsets.fromLTRB(TSizes.defaultSpace, TSizes.defaultSpace, TSizes.defaultSpace, TSizes.defaultSpace * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              image,
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections*4),
          SmoothPageIndicator(
            controller: controller.pageController,
            onDotClicked: controller.dotNavigationClick,
            count: 3,
            effect: const ExpandingDotsEffect(
              spacing: 5,
              dotHeight: 6,
              dotWidth: 24,
              expansionFactor: 2.5,
              activeDotColor: TColors.primary,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}