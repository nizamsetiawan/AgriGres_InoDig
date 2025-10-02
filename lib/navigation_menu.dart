import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/personalization/screens/settings/settings.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/helpers/helper_functions.dart';
import 'features/article/screens/all_articles/article.dart';
import 'features/detection/screens/home/home.dart';
import 'features/forum/screens/farmer_forum.dart';
import 'features/calculator/screens/calculator_screen.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return TextStyle(color: TColors.primary, fontSize: 12);
                }
                return TextStyle(color: darkMode ? Colors.white60 : Colors.black54, fontSize: 12);
              }),
            ),
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            backgroundColor: darkMode ? TColors.black : Colors.white,
            indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Iconsax.home,
                  color: controller.selectedIndex.value == 0 ? TColors.primary : (darkMode ? Colors.white60 : Colors.black54),
                ),
                label: "Beranda",
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.global,
                  color: controller.selectedIndex.value == 1 ? TColors.primary : (darkMode ? Colors.white60 : Colors.black54),
                ),
                label: "Forum Tani",
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.calculator,
                  color: controller.selectedIndex.value == 2 ? TColors.primary : (darkMode ? Colors.white60 : Colors.black54),
                ),
                label: "Kalkulator",
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.book,
                  color: controller.selectedIndex.value == 3 ? TColors.primary : (darkMode ? Colors.white60 : Colors.black54),
                ),
                label: "Artikel",
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.user,
                  color: controller.selectedIndex.value == 4 ? TColors.primary : (darkMode ? Colors.white60 : Colors.black54),
                ),
                label: "Proil",
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const FarmerForum(),
    const CalculatorScreen(),
    const ArticleScreen(),
    const SettingsScreen(),
  ];
}
