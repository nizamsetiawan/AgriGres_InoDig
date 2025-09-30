import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/common/widgets/loaders/shimmer.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';

import '../../../../../common/widgets/guide/guide_menu_icon.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TTexts.homeAppbarTitle,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: TColors.grey)),
          Obx(
              () {
                if(controller.profileLoading.value) {
                  //display shimmer effect
                  return const TShimmerEffect(width: 80, height: 15);
                } else {
                  return Text(controller.user.value.fullName,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: TColors.white));
                }

              }),
        ],
      ),
      actions:  const [
        TGuideCounterIcon(iconColor: TColors.white)
      ],
    );
  }
}