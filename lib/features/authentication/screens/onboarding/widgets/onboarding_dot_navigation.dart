import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:agrigres/features/authentication/controllers/onboarding_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/device/device_utility.dart';
import 'package:agrigres/utils/helpers/helper_functions.dart';

class OnBoardingNavigation extends StatelessWidget {
  const OnBoardingNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 64,
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          spacing: 8,
          dotHeight: 6,
          dotWidth: 24,
          expansionFactor: 2.5,
          activeDotColor: dark ? TColors.secondary : TColors.primary,
          dotColor: TColors.darkGrey.withOpacity(0.2),
        ),
      ),
    );
  }
}