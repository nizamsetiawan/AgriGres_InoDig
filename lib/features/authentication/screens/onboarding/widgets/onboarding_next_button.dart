import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/authentication/controllers/onboarding_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/device/device_utility.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Positioned(
      left: TSizes.defaultSpace,
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: Obx(() {
        final isLast = controller.currentPageIndex.value == 2;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => controller.nextPage(),
            child: Text(isLast ? 'Mulai Sekarang' : 'Lanjut'),
          ),
        );
      }),
    );
  }
}