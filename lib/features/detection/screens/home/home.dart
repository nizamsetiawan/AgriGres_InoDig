import 'package:agrigres/common/widgets/option_menu/option_menu_card.dart';
import 'package:agrigres/features/detection/controllers/location_controller.dart';
import 'package:agrigres/features/detection/screens/history/history_screen.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_appbar.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_categories.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_header.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_location_card.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_menu_grid.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_weather_card.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_slider.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:agrigres/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/custom_shapes/containers/location_container.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../controllers/camera_controller.dart';
import '../../controllers/gallery_controller.dart';
import '../media/preview/preview_media_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GeoTaggingController());
    final controllerCamera = Get.put(CameraController());
    final controllerImage = Get.put(GalleryController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting and notification
                const THomeHeader(),
                
                const SizedBox(height: 16),

                // Location with icon
                const THomeLocationCard(),

                const SizedBox(height: 16),

                // Weather Card
                const THomeWeatherCard(),

                const SizedBox(height: 20),

                // Menu Utama
                const THomeMenuGrid(),

                const SizedBox(height: 20),

                // Kategori Artikel
                const THomeCategories(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
