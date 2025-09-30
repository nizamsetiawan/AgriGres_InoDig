import 'package:agrigres/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/controllers/model_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'dart:io';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/texts/option_menu_text.dart';
import '../../../../utils/constraints/colors.dart';
import '../../../../utils/constraints/image_strings.dart';
import '../../../../utils/constraints/sizes.dart';
import '../../../../utils/constraints/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../media/result_analyze/result_analyze.dart';

class HistoryScreen extends StatelessWidget {
  final ModelController _modelController = Get.put(ModelController());

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Riwayat Analisis'),
        showBackArrow: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: TColors.error,),
            onPressed: () {
              _showDeleteAllDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        final results = _modelController.resultAnalyzeModel;
        if (results.isEmpty) {
          return  Center(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset(
                    TImages.failedAnalyze,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.cover,
                  ),
                  Text(
                   TTexts.historyTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TOptionMenuText(
                    title: TTexts.historySubtitle,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return GestureDetector(
              onTap: () {
                      Get.to(() => ResultScreen(
                            label: result.label,
                            confidence: result.probability,
                            resultAnalyzeModel: result,
                            imagePath: result.imagePath,
                            isFromHistory: true,
                          ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.borderRadiusLg * 2,
                    vertical: TSizes.borderRadiusMd),
                child: TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.borderRadiusLg),
                  showBorder: true,
                  borderColor: isDark ? TColors.secondary : TColors.primary,
                  backgroundColor: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(TSizes.cardRadiusLg),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(TSizes.cardRadiusLg),
                          child: Image.file(
                            File(result.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.label,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.w700)
                                  .copyWith(
                                color: isDark
                                    ? TColors.secondary
                                    : TColors.primary,
                              ),
                            ),
                            Text(
                              "Akurasi : ${result.probability}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              "Kategori : ${result.kategori}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: TColors.error,),
                        onPressed: () {
                          _showDeleteDialog(context, index);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    PanaraConfirmDialog.show(
      color: TColors.error,
      context,
      title: 'Hapus Hasil Analisis',
      message: 'Apakah Anda yakin ingin menghapus hasil analisis ini?',
      confirmButtonText: 'Hapus',
      cancelButtonText: 'Batal',
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () {
        _modelController.deleteResultByIndex(index);
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.custom,
      barrierDismissible: false,
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    PanaraConfirmDialog.show(
      color: TColors.error,
      context,
      title: 'Hapus Semua Hasil Analisis',
      message: 'Apakah Anda yakin ingin menghapus semua hasil analisis?',
      confirmButtonText: 'Hapus',
      cancelButtonText: 'Batal',
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () {
        _modelController.deleteAllResults();
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.custom,
      barrierDismissible: false,
    );
  }
}
