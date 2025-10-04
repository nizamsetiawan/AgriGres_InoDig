import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/screens/agri_info_screen.dart';

class THomeMenuGrid extends StatelessWidget {
  const THomeMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Utama',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Fitur Interaktif Aplikasi',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        
        // Menu Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildMenuCard(
              context,
              'AgriInfo',
              'Informasi harga pangan harian',
              Colors.blue[100]!,
              Colors.blue[600]!,
              Icons.info_outline,
              () {
                print('AgriInfo clicked!'); // Debug log
                try {
                  Get.to(() => const AgriInfoScreen());
                  print('Navigation successful!');
                } catch (e) {
                  print('Navigation error: $e');
                  Get.snackbar(
                    'Error',
                    'Gagal membuka AgriInfo: $e',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            _buildMenuCard(
              context,
              'AgriEdu',
              'Sekolah tani digital',
              Colors.orange[100]!,
              Colors.orange[600]!,
              Icons.school_outlined,
              () {},
            ),
            _buildMenuCard(
              context,
              'AgriCare',
              'Deteksi hama dan penyakit',
              Colors.green[100]!,
              Colors.green[600]!,
              Icons.health_and_safety_outlined,
              () {},
            ),
            _buildMenuCard(
              context,
              'AgriMart',
              'Marketplace pertanian',
              Colors.pink[100]!,
              Colors.pink[600]!,
              Icons.store_outlined,
              () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    Color backgroundColor,
    Color iconColor,
    IconData icon,
    VoidCallback onTap,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 