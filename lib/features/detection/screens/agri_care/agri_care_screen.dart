import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/camera_controller.dart';
import '../../controllers/gallery_controller.dart';
import '../media/preview/preview_media_page.dart';
import '../history/history_screen.dart';
import '../guidelines/guidelines_page.dart';

class AgriCareScreen extends StatelessWidget {
  const AgriCareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    // Initialize controllers
    final controllerCamera = Get.put(CameraController());
    final controllerImage = Get.put(GalleryController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text(
          'AgriCare',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Title
              Text(
                'Deteksi Hama & Penyakit Tanaman',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Unggah foto tanamanmu untuk mengenali gejala hama atau penyakit secara cepat.',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Menu Cards
              Expanded(
                child: Column(
                  children: [
                    // Camera Card
                    _buildMenuCard(
                      context,
                      'Kamera',
                      'Gunakan kamera untuk mengambil foto baru.',
                      Colors.green[50]!,
                      Colors.green[100]!,
                      Colors.green[600]!,
                      Icons.camera_alt_outlined,
                      () async {
                        await controllerCamera.captureImage();
                        if (controllerCamera.capturedImage.value != null) {
                          Get.to(() => ImagePreviewScreen(
                            isFromCamera: true,
                            imageFile: controllerCamera.capturedImage.value,
                          ));
                        }
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Gallery Card
                    _buildMenuCard(
                      context,
                      'Galeri',
                      'Pilih gambar dari galeri perangkat anda',
                      Colors.pink[50]!,
                      Colors.pink[100]!,
                      Colors.pink[600]!,
                      Icons.photo_library_outlined,
                      () async {
                        await controllerImage.selectImageFromGallery();
                        if (controllerImage.selectedImage.value != null) {
                          Get.to(() => ImagePreviewScreen(
                            imageFile: controllerImage.selectedImage.value,
                            isFromCamera: false,
                          ));
                        }
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Detection History Card
                    _buildMenuCard(
                      context,
                      'Riwayat Deteksi',
                      'Pilih untuk melihat hasil riwayat hasil deteksi.',
                      Colors.amber[50]!,
                      Colors.amber[100]!,
                      Colors.amber[600]!,
                      Icons.history_outlined,
                      () {
                        Get.to(() => HistoryScreen());
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // User Guide Card
                    _buildMenuCard(
                      context,
                      'Panduan Penggunaan',
                      'Cara pengggunaan fitur AgriCare',
                      Colors.purple[50]!,
                      Colors.purple[100]!,
                      Colors.purple[600]!,
                      Icons.lightbulb_outline,
                      () {
                        Get.to(() => const GuidelinesScreen());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String description,
    Color backgroundColor,
    Color borderColor,
    Color iconColor,
    IconData icon,
    VoidCallback onTap,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Container with wavy background
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: borderColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
