import 'package:agrigres/utils/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:agrigres/features/authentication/controllers/onboarding_controller.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/device/device_utility.dart';


class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: TDeviceUtils.getAppBarHeight(),
        right: TSizes.defaultSpace,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(TColors.primary),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          onPressed: () =>OnBoardingController.instance.skipPage(),
          child: const Text('Skip'),
        ));
  }
}