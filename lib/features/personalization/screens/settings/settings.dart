import 'package:agrigres/features/personalization/screens/settings/widgets/about_app.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/feedback_form.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/privacy_securty_page.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/settings_profile_header.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/settings_menu_item.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/settings_section_header.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/data/repositories/authentication/authentication_repository.dart';
import 'package:agrigres/features/personalization/screens/profile/profile.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../utils/constraints/text_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Profil'),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              foregroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            
            // Settings Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    const TSettingsProfileHeader(),
                    
                    // Personalisasi Section
                    const TSettingsSectionHeader(title: 'Personalisasi'),
                    
                    TSettingsMenuItem(
                      icon: Iconsax.user,
                      title: 'Data Diri',
                      subtitle: 'Lengkapi Data',
                      onTap: () => Get.to(() => const ProfileScreen()),
                    ),
                    
                    TSettingsMenuItem(
                      icon: Iconsax.setting,
                      title: 'Pengaturan',
                      onTap: () => AppSettings.openAppSettings(
                        type: AppSettingsType.settings
                      ),
                    ),
                    
                    // General Section
                    const TSettingsSectionHeader(title: 'General'),
                    
                    TSettingsMenuItem(
                      icon: Iconsax.information,
                      title: 'Tentang',
                      onTap: () => Get.to(() => AboutAPPPage()),
                    ),
                    
                    TSettingsMenuItem(
                      icon: Iconsax.security_card,
                      title: 'Syart & Ketentuan',
                      onTap: () => Get.to(() => PrivacyAndSecurityPage()),
                    ),
                    
                    TSettingsMenuItem(
                      icon: Iconsax.call,
                      title: 'Masukan Pengguna',
                      onTap: () => Get.to(() => FeedbackForm()),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Logout
                    TSettingsMenuItem(
                      icon: Iconsax.logout,
                      title: 'Keluar',
                      isLogout: true,
                      onTap: () => _showLogoutDialog(context),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
      barrierDismissible: false,
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
