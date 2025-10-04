import 'package:agrigres/features/detection/controllers/location_controller.dart';
import 'package:agrigres/features/detection/controllers/weather_controller.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_categories.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_header.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_location_card.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_menu_grid.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_weather_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controllers in proper order
    final controller = Get.put(GeoTaggingController());
    
    // Initialize WeatherController after GeoTaggingController is ready
    final weatherController = Get.put(WeatherController());
    
    // Ensure WeatherController can find GeoTaggingController
    weatherController.setLocationController(controller);

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
