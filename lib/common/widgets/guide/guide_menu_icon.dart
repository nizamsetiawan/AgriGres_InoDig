import 'package:agrigres/features/detection/screens/guidelines/guidelines_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constraints/colors.dart';


class TGuideCounterIcon extends StatelessWidget {
  const TGuideCounterIcon({
    super.key,
    this.iconColor,
  });

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
            onPressed: () => Get.to(() => const GuidelinesScreen()),
            icon: Icon(Iconsax.lamp_on, color: iconColor)),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: TColors.error,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text('!',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: TColors.white, fontSizeFactor: 0.8)),
            ),
          ),
        )
      ],
    );
  }
}