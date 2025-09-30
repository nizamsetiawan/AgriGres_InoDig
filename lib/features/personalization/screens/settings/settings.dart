import 'package:agrigres/features/personalization/screens/settings/widgets/about_app.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/feedback_form.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/privacy_securty_page.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:agrigres/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:agrigres/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:agrigres/common/widgets/texts/section_heading.dart';
import 'package:agrigres/data/repositories/authentication/authentication_repository.dart';
import 'package:agrigres/features/personalization/screens/profile/profile.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../utils/constraints/text_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  ///appbar
                  TAppBar(
                      title: Text('Akun Saya',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: TColors.white))),

                  ///user profile card
                  TUserProfileTile(
                      onPressed: () => Get.to(() => const ProfileScreen())),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            ///Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  ///-- Account settings
                  const TSectionHeading(
                      title: TTexts.accountSettingsTitle, showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TSettingsMenuTile(
                      icon: Iconsax.sun,
                      title: TTexts.changeThemeTitle,
                      onTap: () => AppSettings.openAppSettings(
                          type: AppSettingsType.display),
                      subTitle: TTexts.changeThemeSubtitle),
                  TSettingsMenuTile(
                    icon: Iconsax.location,
                    title: TTexts.locationTitle,
                    subTitle: TTexts.locationSubtitle,
                    onTap: () => AppSettings.openAppSettings(
                        type: AppSettingsType.location),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.setting,
                    title: TTexts.otherOptionsTitle,
                    subTitle: TTexts.otherOptionsSubtitle,
                    onTap: () => AppSettings.openAppSettings(
                        type: AppSettingsType.generalSettings),
                  ),
                  ///-- App settings
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const TSectionHeading(
                      title: TTexts.aboutAppTitle, showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TSettingsMenuTile(
                      icon: Iconsax.information,
                      title: TTexts.aboutAppTitle,
                      onTap: () => Get.to(() => AboutAPPPage()),
                      subTitle: TTexts.aboutAppSubtitle),
                  TSettingsMenuTile(
                    icon: Iconsax.security_user,
                    title: TTexts.giveRatingTitle,
                    onTap: () => Get.to(() => FeedbackForm()),
                    subTitle: TTexts.giveRatingSubtitle,
                  ),
                  TSettingsMenuTile(
                      icon: Iconsax.security_card,
                      title: TTexts.privacyAndSecurity,
                      onTap: () => Get.to(() => PrivacyAndSecurityPage()),
                      subTitle: TTexts.privacyAndSecuritySubtitle),

                  ///--logout button
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          PanaraConfirmDialog.show(
                            color: TColors.primary,
                            context,
                            title: TTexts.logoutConfirmationTitle,
                            message: TTexts.logoutConfirmationMessage,
                            confirmButtonText: TTexts.logoutButtonText,
                            cancelButtonText: TTexts.cancelButtonText,
                            onTapCancel: () {
                              Navigator.pop(context);
                            },
                            onTapConfirm: () {
                              AuthenticationRepository.instance.logout();
                            },
                            panaraDialogType: PanaraDialogType.custom,
                            barrierDismissible:
                            false, // optional parameter (default is true)
                          );
                        },
                        child: const Text(TTexts.logoutButtonText)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showFeatureUnderDevelopmentDialog(BuildContext context) {
  PanaraInfoDialog.show(
    context,
    title: TTexts.featureUnderDevelopmentTitle,
    message: TTexts.featureUnderDevelopmentMessage,
    buttonText: TTexts.okButtonText,
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.normal,
    barrierDismissible: false,
  );
}
