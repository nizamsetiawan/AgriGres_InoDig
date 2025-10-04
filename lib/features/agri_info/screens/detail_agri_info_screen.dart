import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/agri_info/controllers/detail_agri_info_controller.dart';
import 'package:agrigres/features/agri_info/widgets/filter_section.dart';
import 'package:agrigres/features/agri_info/widgets/food_price_list.dart';
import 'package:agrigres/features/agri_info/widgets/food_price_shimmer.dart';

class DetailAgriInfoScreen extends StatelessWidget {
  const DetailAgriInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailAgriInfoController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        title: Text('Detail Informasi Pangan'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Section
              const FilterSection(),
              
              const SizedBox(height: 20),
              
              // Action Buttons
              _buildActionButtons(controller),
              
              const SizedBox(height: 20),
              
              // Data Display
              _buildDataSection(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(DetailAgriInfoController controller) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => controller.clearAllFilters(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red[700],
              side: BorderSide(color: Colors.red[700]!),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus Semua'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.fetchFoodPriceData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Terapkan'),
          ),
        ),
      ],
    );
  }

  Widget _buildDataSection(DetailAgriInfoController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Harga Pangan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            FoodPriceShimmer(),
          ],
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Builder(
          builder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal Memuat Data',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (controller.foodPriceData.isEmpty) {
        return Builder(
          builder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum Ada Data',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Klik "Terapkan" untuk memuat data harga pangan',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return FoodPriceList(data: controller.foodPriceData);
    });
  }
}
