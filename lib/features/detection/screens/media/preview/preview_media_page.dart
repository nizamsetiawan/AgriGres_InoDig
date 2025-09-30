import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../common/widgets/texts/option_menu_text.dart';
import '../../../../../common/widgets/texts/product_title_text.dart';
import '../../../../../utils/constraints/colors.dart';
import '../../../../../utils/constraints/image_strings.dart';
import '../../../../../utils/constraints/sizes.dart';
import '../../../../../utils/constraints/text_strings.dart';
import '../../../../../utils/helpers/loaders.dart';
import '../../../controllers/model_controller.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({
    Key? key,
    required this.imageFile,
    required this.isFromCamera,
  }) : super(key: key);

  final XFile? imageFile;
  final bool isFromCamera;

  @override
  Widget build(BuildContext context) {
    final modelController = Get.put(ModelController());

    return Scaffold(
      appBar: TAppBar(title: const Text("Pratinjau Gambar"), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TOptionMenuText(
                title: TTexts.alertPreviewImage,
                textAlign: TextAlign.center,
                maxLines: 2,
                color: TColors.error,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              if (imageFile != null)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: TColors.grey, width: 2),
                    color: TColors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(imageFile!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                TRoundedImage(
                  imageUrl: TImages.imagePlaceholder,
                  width: double.infinity,
                ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: TProductTitleText(
                  title: "Pilih Jenis Tanaman",
                  smallSize: true,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() => DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: TColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButton<String>(
                    value: modelController.selectedModel.value,
                    onChanged: (String? newValue) {
                      modelController.selectedModel.value = newValue!;
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: '',
                        child: Text(
                          'Belum dipilih',
                          style: TextStyle(color: TColors.error),
                        ),
                      ),
                      ...['Tanaman Tomat', 'Tanaman Singkong', 'Tanaman Jagung']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ],
                    isExpanded: true,
                    underline: Container(),
                    icon: Icon(Icons.arrow_drop_down, color: TColors.primary),
                    style: TextStyle(color: TColors.dark),
                  ),
                ),
              )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (imageFile != null) {
                      if (modelController.selectedModel.value.isEmpty) {
                        TLoaders.errorSnackBar(title: 'Oh tidak...', message: 'Silakan pilih jenis tanaman terlebih dahulu.');
                        return;
                      }
                      await modelController.loadModel();
                      await modelController.runInference(imageFile!.path, isFromCamera: isFromCamera);

                    }
                                    },
                  child: const Text(TTexts.btnPreviewImage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}