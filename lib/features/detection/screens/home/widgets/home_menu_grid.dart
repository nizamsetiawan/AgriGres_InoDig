import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/screens/agri_info_screen.dart';
import 'package:agrigres/utils/logging/logger.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/features/detection/controllers/home_menu_controller.dart';
import 'package:agrigres/features/detection/models/home_menu_model.dart';
import 'package:agrigres/utils/helpers/icon_helper.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class THomeMenuGrid extends StatelessWidget {
  final bool showHeader;

  const THomeMenuGrid({
    super.key,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final menuController = Get.isRegistered<HomeMenuController>()
        ? Get.find<HomeMenuController>()
        : Get.put(HomeMenuController());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          Text(
            'Menu Utama',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Fitur Interaktif Aplikasi',
            style: textTheme.bodyMedium?.copyWith(
              color: TColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        // Menu Grid
        Obx(
          () {
            if (menuController.isLoading.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: const [
                    LinearProgressIndicator(
                      minHeight: 3,
                      color: TColors.primary,
                      backgroundColor: TColors.primaryBackground,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Memuat menu utama...',
                      style: TextStyle(color: TColors.textSecondary),
                    ),
                  ],
                ),
              );
            }

            final displayMenus = menuController.menus.take(6).toList();

            if (displayMenus.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Tidak ada menu tersedia',
                    style: textTheme.bodyMedium?.copyWith(
                      color: TColors.textSecondary,
                    ),
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemCount: displayMenus.length,
              itemBuilder: (context, index) {
                return _buildMenuCardFromModel(context, displayMenus[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuCardFromModel(BuildContext context, HomeMenuModel menu) {
    final textTheme = Theme.of(context).textTheme;
    final icon = IconHelper.getIconFromName(menu.iconName) ?? Icons.help_outline;
    final backgroundColor = IconHelper.intToColor(menu.backgroundColor);
    final iconColor = IconHelper.intToColor(menu.iconColor);
    
    final displayTitle = _formatTitle(menu.title);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          try {
            if (menu.route == '/agri-info' || menu.route.contains('agri-info')) {
              Get.to(() => const AgriInfoScreen());
            } else {
              Get.toNamed(menu.route);
            }
          } catch (e) {
            TLoggerHelper.error('Navigation error for ${menu.title}', e);
            TLoaders.errorSnackBar(
              title: 'Kesalahan',
              message: 'Gagal membuka ${menu.title}: $e',
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: TColors.borderSecondary),
            boxShadow: [
              BoxShadow(
                color: TColors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                displayTitle,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                menu.subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: TColors.textSecondary,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTitle(String title) {
    final trimmed = title.trim();
    if (trimmed.toLowerCase().startsWith('agri')) return trimmed;
    if (trimmed.isEmpty) return 'Agri';
    final capitalized =
        trimmed[0].toUpperCase() + (trimmed.length > 1 ? trimmed.substring(1) : '');
    return 'Agri$capitalized';
  }
} 