import 'dart:io';

import 'package:agrigres/common/widgets/images/t_circular_image.dart';
import 'package:agrigres/features/detection/models/result_analyze_model.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../common/widgets/texts/product_title_text.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../utils/constraints/colors.dart';
import '../../../../../utils/constraints/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/model_controller.dart';

class ResultScreen extends StatefulWidget {
  final String label;
  final String confidence;
  final ResultAnalyzeModel resultAnalyzeModel;
  final String imagePath;
  final bool? isFromHistory;

  const ResultScreen({
    Key? key,
    required this.label,
    required this.confidence,
    required this.resultAnalyzeModel,
    required this.imagePath,
    this.isFromHistory = false,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showMoreHayati = false;
  bool _showMoreKimiawi = false;
  bool _showMorePenyebab = false;
  bool _showMorePencegahan = false;

  @override
  Widget build(BuildContext context) {
    final modelController = Get.put(ModelController());
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: const Text("Hasil Analisis"),
        showBackArrow: widget.isFromHistory!,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imagePath.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: TColors.primary, width: 2),
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        child: TRoundedContainer(
                          radius: TSizes.sm,
                          backgroundColor: TColors.primary.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm, vertical: TSizes.xs),
                          child: Text(
                            'Kategori - ${widget.resultAnalyzeModel.kategori}',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .apply(color: TColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: TSizes.spaceBtwSections / 2,
              ),
              Center(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Center(
                child: Text(
                  "Akurasi : ${widget.confidence}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections / 2,
              ),
              Text(
                "Gejala",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
              const SizedBox(
                height: TSizes.borderRadiusMd,
              ),
              TProductTitleText(
                title: widget.resultAnalyzeModel.gejala,
                textAlign: TextAlign.justify,
                smallSize: true,
                maxLines: 1000,
              ),
              Text(
                "Rekomendasi",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
              const SizedBox(
                height: TSizes.borderRadiusMd,
              ),
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                showBorder: true,
                borderColor: isDark ? TColors.secondary : TColors.primary,
                backgroundColor: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TCircularImage(
                          padding: 0,
                          image:
                              "https://img.icons8.com/?size=100&id=117418&format=png&color=000000",
                          isNetworkImage: true,
                          width: 25,
                          height: 25,
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems / 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pengendalian Hayati",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? TColors.primary
                                      : TColors.secondary,
                                ),
                              ),
                              const SizedBox(
                                height: TSizes.borderRadiusMd,
                              ),
                              TProductTitleText(
                                title: widget
                                    .resultAnalyzeModel.pengendalianHayati,
                                textAlign: TextAlign.justify,
                                smallSize: true,
                                maxLines: _showMoreHayati ? 1000 : 3,
                              ),
                              if (widget.resultAnalyzeModel.pengendalianHayati
                                      .length >
                                  100)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showMoreHayati = !_showMoreHayati;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    _showMoreHayati
                                        ? 'Lihat Lebih Sedikit'
                                        : 'Lihat Selengkapnya',
                                    style: TextStyle(
                                      color: TColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TCircularImage(
                          padding: 0,
                          image:
                              "https://img.icons8.com/?size=100&id=W5RvDYCw70Wr&format=png&color=000000",
                          isNetworkImage: true,
                          width: 25,
                          height: 25,
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems / 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pengendalian Kimiawi",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? TColors.primary
                                      : TColors.secondary,
                                ),
                              ),
                              const SizedBox(
                                height: TSizes.borderRadiusMd,
                              ),
                              TProductTitleText(
                                title: widget
                                    .resultAnalyzeModel.pengendalianKimiawi,
                                textAlign: TextAlign.justify,
                                smallSize: true,
                                maxLines: _showMoreKimiawi ? 1000 : 3,
                              ),
                              if (widget.resultAnalyzeModel.pengendalianKimiawi
                                      .length >
                                  100)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showMoreKimiawi = !_showMoreKimiawi;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    _showMoreKimiawi
                                        ? 'Lihat Lebih Sedikit'
                                        : 'Lihat Selengkapnya',
                                    style: TextStyle(
                                      color: TColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections / 2,
              ),
              Text(
                "Apa Penyebabnya ?",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
              const SizedBox(
                height: TSizes.borderRadiusMd,
              ),
              TProductTitleText(
                title: widget.resultAnalyzeModel.penyebab,
                textAlign: TextAlign.justify,
                smallSize: true,
                maxLines: _showMorePenyebab ? 1000 : 3,
              ),
              if (widget.resultAnalyzeModel.penyebab.length > 100)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showMorePenyebab = !_showMorePenyebab;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _showMorePenyebab
                          ? 'Lihat Lebih Sedikit'
                          : 'Lihat Selengkapnya',
                      style: TextStyle(
                        color: TColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: TSizes.spaceBtwSections / 2,
              ),
              Text(
                "Pencegahan",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
              const SizedBox(
                height: TSizes.borderRadiusMd,
              ),
              TProductTitleText(
                title: widget.resultAnalyzeModel.pencegahan,
                textAlign: TextAlign.justify,
                smallSize: true,
                maxLines: _showMorePencegahan ? 1000 : 3,
              ),
              if (widget.resultAnalyzeModel.pencegahan.length > 100)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showMorePencegahan = !_showMorePencegahan;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _showMorePencegahan
                          ? 'Lihat Lebih Sedikit'
                          : 'Lihat Selengkapnya',
                      style: TextStyle(
                        color: TColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: TSizes.spaceBtwSections / 2,
              ),
              if ((!widget.isFromHistory!))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            modelController.saveCurrentResult(widget.imagePath);
                          },
                          child: const Text(TTexts.btnSaveToHistory),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: TSizes.defaultSpace,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offAll(NavigationMenu());
                          },
                          child: const Text(TTexts.btnBackAll),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
