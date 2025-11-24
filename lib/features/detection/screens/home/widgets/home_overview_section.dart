import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/detection/controllers/location_controller.dart';
import 'package:agrigres/features/detection/controllers/weather_controller.dart';
import 'package:agrigres/features/detection/controllers/home_menu_controller.dart';
import 'package:agrigres/features/detection/controllers/category_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class THomeOverviewSection extends StatelessWidget {
  const THomeOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final GeoTaggingController locationController =
        Get.isRegistered<GeoTaggingController>()
            ? Get.find<GeoTaggingController>()
            : Get.put(GeoTaggingController());
    final WeatherController weatherController =
        Get.isRegistered<WeatherController>()
            ? Get.find<WeatherController>()
            : Get.put(WeatherController());
    final HomeMenuController menuController =
        Get.isRegistered<HomeMenuController>()
            ? Get.find<HomeMenuController>()
            : Get.put(HomeMenuController());
    final CategoryController categoryController =
        Get.isRegistered<CategoryController>()
            ? Get.find<CategoryController>()
            : Get.put(CategoryController());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TColors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: TColors.black.withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationWeather(context, locationController, weatherController),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[200], height: 24),
          const SizedBox(height: 12),
          _buildHighlightChips(menuController, categoryController),
        ],
      ),
    );
  }

  Widget _buildLocationWeather(
    BuildContext context,
    GeoTaggingController locationController,
    WeatherController weatherController,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final primary = Theme.of(context).colorScheme.primary;

    return Obx(() {
      final isLoading =
          locationController.loading.value || weatherController.isLoading.value;

      if (isLoading) {
        return _buildOverviewSkeleton(context);
      }

      final locationText = locationController.strLocation.value.isNotEmpty
          ? locationController.strLocation.value
          : weatherController.currentLocation.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Iconsax.location, size: 18, color: TColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  locationText.isNotEmpty ? locationText : 'Lokasi belum tersedia',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _InfoTag(
                icon: Icons.calendar_today_outlined,
                label: weatherController.currentDate.value,
              ),
              const SizedBox(width: 6),
              _InfoTag(
                icon: Icons.access_time,
                label: weatherController.currentTime.value,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weatherController.weatherDescription.value.isNotEmpty
                          ? weatherController.weatherDescription.value
                          : weatherController.weatherCondition.value,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                    color: TColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Terasa ${weatherController.getFormattedFeelsLike()} • '
                      'Kelembaban ${weatherController.getFormattedHumidity()}',
                      style: textTheme.bodySmall?.copyWith(
                    color: TColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Angin ${weatherController.getFormattedWindSpeed()}',
                      style: textTheme.bodySmall?.copyWith(
                    color: TColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        weatherController.getWeatherIcon(),
                        color: weatherController.getWeatherColor(),
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        weatherController.getFormattedTemperature(),
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      weatherController.weatherCondition.value,
                      style: textTheme.bodySmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildHighlightChips(
    HomeMenuController menuController,
    CategoryController categoryController,
  ) {
    return Obx(() {
      final menuLoading = menuController.isLoading.value;
      final categoryLoading = categoryController.isLoading.value;

      return Row(
        children: [
          Expanded(
            child: _OverviewStatCard(
              icon: Iconsax.category,
              label: 'Menu Utama',
              value: menuController.menus.length,
              isLoading: menuLoading,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _OverviewStatCard(
              icon: Iconsax.book,
              label: 'Kategori Artikel',
              value: categoryController.featuredCategories.length,
              isLoading: categoryLoading,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOverviewSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonLine(width: MediaQuery.of(context).size.width * 0.6),
        const SizedBox(height: 8),
        _SkeletonLine(width: 120, height: 12),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(child: _SkeletonLine(height: 40)),
            SizedBox(width: 12),
            _SkeletonCircle(size: 40),
          ],
        ),
      ],
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: TColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: TColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _OverviewStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final bool isLoading;

  const _OverviewStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const primary = TColors.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TColors.borderSecondary),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: TColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                isLoading
                    ? const _SkeletonLine(height: 16, width: 40)
                    : Text(
                        value.toString().padLeft(2, '0'),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TColors.textPrimary,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;

  const _SkeletonLine({this.width, this.height = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: TColors.borderSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  final double size;

  const _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TColors.borderSecondary,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

