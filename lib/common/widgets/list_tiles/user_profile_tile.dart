import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/images/t_circular_image.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading: TCircularImage(
        image: controller.user.value.profilePicture.isNotEmpty
            ? controller.user.value.profilePicture
            : TImages.user,
        isNetworkImage: controller.user.value.profilePicture.isNotEmpty,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text(controller.user.value.fullName, style: Theme.of(context).textTheme.titleMedium!.apply(color: TColors.white)),
      subtitle: Text(controller.user.value.email, style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white)),
      trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: TColors.white)),
    );
  }
}