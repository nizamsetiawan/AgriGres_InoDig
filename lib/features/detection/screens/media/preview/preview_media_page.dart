import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/constraints/colors.dart';
import '../../../../../utils/constraints/text_strings.dart';
import '../../../../../utils/helpers/loaders.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../controllers/model_controller.dart';

class ImagePreviewScreen extends StatefulWidget {
  const ImagePreviewScreen({
    Key? key,
    required this.imageFile,
    required this.isFromCamera,
  }) : super(key: key);

  final XFile? imageFile;
  final bool isFromCamera;

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    final modelController = Get.put(ModelController());
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async {
        // Cancel analysis if in progress
        if (_isAnalyzing) {
          modelController.cancelAnalysis();
          TFullScreenLoader.stopLoading();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              // Cancel analysis if in progress
              if (_isAnalyzing) {
                modelController.cancelAnalysis();
                TFullScreenLoader.stopLoading();
              }
              // Close snackbar safely before navigation
              TLoaders.closeGetSnackbar();
              Get.back(closeOverlays: false);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
        title: Text(
          'Pratinjau Gambar',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Alert Text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!, width: 1),
                  ),
                  child: Text(
                    TTexts.alertPreviewImage,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // Image Preview
                if (widget.imageFile != null)
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(widget.imageFile!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  ),
                const SizedBox(height: 24),
                // Plant Type Selection
                Text(
                  "Pilih Jenis Tanaman",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                // Dropdown Selection
                Obx(() => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
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
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        ...['Tanaman Tomat', 'Tanaman Singkong', 'Tanaman Jagung']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                      isExpanded: true,
                      underline: Container(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[600],
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                // Analyze Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isAnalyzing ? null : () async {
                      if (widget.imageFile != null) {
                        if (modelController.selectedModel.value.isEmpty) {
                          TLoaders.errorSnackBar(
                            title: 'Oh tidak...', 
                            message: 'Silakan pilih jenis tanaman terlebih dahulu.'
                          );
                          return;
                        }
                        setState(() {
                          _isAnalyzing = true;
                        });
                        try {
                          await modelController.runInference(
                            widget.imageFile!.path, 
                            isFromCamera: widget.isFromCamera
                          );
                        } catch (e) {
                          // Error already handled in controller
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isAnalyzing = false;
                            });
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      side: const BorderSide(color: TColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      TTexts.btnPreviewImage,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel analysis if still in progress when widget is disposed
    if (_isAnalyzing) {
      final modelController = Get.find<ModelController>();
      modelController.cancelAnalysis();
      TFullScreenLoader.stopLoading();
    }
    super.dispose();
  }
}