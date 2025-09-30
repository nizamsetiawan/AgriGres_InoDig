import 'package:agrigres/common/widgets/option_menu/option_menu_card.dart';
import 'package:agrigres/features/detection/controllers/location_controller.dart';
import 'package:agrigres/features/detection/screens/history/history_screen.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_appbar.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_categories.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_slider.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:agrigres/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:get/get.dart';

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
    final  controllerCamera = Get.put(CameraController());
    final  controllerImage = Get.put(GalleryController());



    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  ///appbar
                  const THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  //
                  Obx(() {
                    return TLocationContainer(
                      text: '${controller.strLocation.value}',
                    );
                  }),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  ///categories
                  const Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        TSectionHeading(
                            title: 'Kategori Artikel',
                            showActionButton: false,
                            textColor: Colors.white),
                        SizedBox(height: TSizes.spaceBtwItems),
                        THomeCategories(),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            ///Body
            Padding(
              padding: const EdgeInsets.only(
                  left: TSizes.defaultSpace,
                  right: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  const TPromoSlider(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(
                      title: 'Menu Pilihan',
                      showActionButton: false,
                      textColor: Colors.black),
                  SizedBox(height: TSizes.spaceBtwItems),
                  TOptionMenuCard(
                    onTap: () async {
                      await controllerCamera.captureImage();
                      if (controllerCamera.capturedImage.value != null) {
                        Get.to(() => ImagePreviewScreen(
                          isFromCamera: true,
                          imageFile: controllerCamera.capturedImage.value,
                        ));
                      }
                    },
                    showBorder: true,
                    title: TTexts.cameraTitle,
                    subtitle: TTexts.cameraSubTitle,
                    imagePath: TImages.urlCameraIcon,
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  TOptionMenuCard(
                    onTap: () async {
                      await controllerImage.selectImageFromGallery();
                      if (controllerImage.selectedImage.value != null) {
                        Get.to(() => ImagePreviewScreen(
                          imageFile: controllerImage.selectedImage.value,
                          isFromCamera: false,
                        ));
                      }
                    },
                    showBorder: true,
                    title: TTexts.galleryTitle,
                    subtitle: TTexts.gallerySubTitle,
                    imagePath: TImages.urlGalleryIcon,
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  TOptionMenuCard(
                    onTap: () {
                      Get.to(() =>  HistoryScreen());
                    },
                      showBorder: true,
                      title: TTexts.historyDetectionTitle,
                      subtitle: TTexts.historyDetectionSubTitle,
                      imagePath: TImages.urlHistoryIcon),
                  const SizedBox(height: TSizes.spaceBtwSections),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
