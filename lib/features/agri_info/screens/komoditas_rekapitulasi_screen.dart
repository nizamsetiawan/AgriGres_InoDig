import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/agri_info/controllers/komoditas_rekapitulasi_controller.dart';
import 'package:agrigres/features/agri_info/widgets/komoditas_rekapitulasi_filter_section.dart';
import 'package:agrigres/features/agri_info/widgets/komoditas_rekapitulasi_data_list.dart';
import 'package:agrigres/features/agri_info/widgets/komoditas_rekapitulasi_shimmer.dart';

class KomoditasRekapitulasiScreen extends StatelessWidget {
  const KomoditasRekapitulasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KomoditasRekapitulasiController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        title: Text('Rekapitulasi Komoditas'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Section (Container with shadow and border)
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
                    const KomoditasRekapitulasiFilterSection(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => controller.fetchKomoditasRekapitulasiData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Terapkan'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => controller.clearAllFilters(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red[600],
                              side: BorderSide(color: Colors.red[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Hapus Semua'),
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

  Widget _buildDataSection(KomoditasRekapitulasiController controller) {
    return Obx(() {
      // Show empty state first time (no data fetched yet)
      if (controller.komoditasData.isEmpty && !controller.isLoading.value) {
        return _buildEmptyState();
      }
      // Show loading shimmer when fetching data
      if (controller.isLoading.value) {
        return const KomoditasRekapitulasiShimmer();
      }
      // Show error state
      if (controller.errorMessage.value.isNotEmpty) {
        return _buildErrorState(controller.errorMessage.value);
      }
      // Show data
      return KomoditasRekapitulasiDataList(
        data: controller.komoditasData,
        rataRataProvinsi: controller.rataRataProvinsi.value,
      );
    });
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 48),
          const SizedBox(height: 12),
          Text(
            'Terjadi Kesalahan',
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
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, color: Colors.grey[400], size: 48),
          const SizedBox(height: 12),
          Text(
            'Belum ada Data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Klik "Terapkan" untuk memuat data rekapitulasi komoditas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
