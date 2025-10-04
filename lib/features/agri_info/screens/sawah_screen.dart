import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/agri_info/controllers/sawah_controller.dart';
import 'package:agrigres/features/agri_info/widgets/sawah_filter_section.dart';
import 'package:agrigres/features/agri_info/widgets/sawah_data_list.dart';
import 'package:agrigres/features/agri_info/widgets/sawah_shimmer.dart';

class SawahScreen extends StatelessWidget {
  const SawahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SawahController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        title: Text('Luas Sawah Menurut Desa/Kelurahan'),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.filter_list, color: Colors.green[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Filter Data',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SawahFilterSection(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => controller.clearAllFilters(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red[600],
                              side: BorderSide(color: Colors.red[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Hapus Semua Filter'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildDataSection(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataSection(SawahController controller) {
    return Obx(() {
      // Show loading shimmer when fetching data
      if (controller.isLoading.value) {
        return const SawahShimmer();
      }
      // Show error state
      if (controller.errorMessage.value.isNotEmpty) {
        return _buildErrorState(controller.errorMessage.value);
      }
      // Show data
      if (controller.sawahData.value != null) {
        return SawahDataList(data: controller.sawahData.value!);
      }
      // Show empty state if no data
      return _buildEmptyState();
    });
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[600], size: 48),
            const SizedBox(height: 12),
            Text(
              'Terjadi Kesalahan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture, color: Colors.grey[400], size: 48),
            const SizedBox(height: 12),
            Text(
              'Belum ada Data',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data sedang dimuat...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
