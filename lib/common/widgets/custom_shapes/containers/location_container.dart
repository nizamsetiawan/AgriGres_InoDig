import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/device/device_utility.dart';
import 'package:agrigres/utils/helpers/helper_functions.dart';

class TLocationContainer extends StatelessWidget {
  const TLocationContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.location,
    this.showBackground = true,
    this.showBorder = true,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      child: Padding(
        padding: padding,
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(TSizes.iconXs),
          decoration: BoxDecoration(
              color: showBackground
                  ? dark
                      ? TColors.dark
                      : TColors.light
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              border: showBorder ? Border.all(color: TColors.grey) : null),
          child: Row(
            children: [
              Icon(icon, color: TColors.primary),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                  child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                    ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
