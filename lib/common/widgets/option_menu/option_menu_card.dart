import 'package:agrigres/common/widgets/texts/option_menu_text.dart';
import 'package:agrigres/common/widgets/texts/product_title_text.dart';
import 'package:agrigres/utils/constraints/enums.dart';
import 'package:flutter/material.dart';

import '../../../utils/constraints/colors.dart';
import '../../../utils/constraints/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../images/t_circular_image.dart';

class TOptionMenuCard extends StatelessWidget {
  const TOptionMenuCard({
    super.key,
    required this.showBorder,
    this.onTap,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final bool showBorder;
  final void Function()? onTap;
  final String title;
  final String subtitle;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: TRoundedContainer(
        showBorder: showBorder,
        borderColor: isDark ? TColors.secondary : TColors.primary ,
        backgroundColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: TCircularImage(
                width: 100,
                height: 100,
                isNetworkImage: true,
                image: imagePath,
                backgroundColor: Colors.transparent,
                // overlayColor: isDark ? TColors.white : TColors.black,
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems / 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TOptionMenuText(title: title, brandTextSize: TextSizes.medium,),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
