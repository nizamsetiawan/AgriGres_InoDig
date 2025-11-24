import 'package:agrigres/features/detection/controllers/location_controller.dart';
import 'package:agrigres/features/detection/controllers/weather_controller.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_feature_tabs.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_header.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_overview_section.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load user data when home screen opens
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userController = Get.find<UserController>();
    // Fetch user data from Firestore if not already loaded
    if (userController.user.value.id.isEmpty) {
      await userController.fetchUserRecord();
    }
  }

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

                // Overview Card (Location + Weather + Highlights)
                const THomeOverviewSection(),

                const SizedBox(height: 20),

                // Menu + Artikel tabs
                const THomeFeatureTabs(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
