import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/agri_info/widgets/agri_info_section_header.dart';
import 'package:agrigres/features/agri_info/widgets/agri_info_list_item.dart';
import 'package:agrigres/features/agri_info/controllers/agri_info_controller.dart';
import 'package:agrigres/features/agri_info/models/agri_info_model.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class AgriInfoScreen extends StatelessWidget {
  const AgriInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AgriInfoController());

    return Scaffold(
      backgroundColor: TColors.light,
      appBar: const TAppBar(
        title: Text('Agri Info'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              const AgriInfoSectionHeader(),
              
              const SizedBox(height: 20),
              
              // Agri Info List
              Obx(() => _buildAgriInfoList(controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgriInfoList(AgriInfoController controller) {
    if (controller.isLoading.value) {
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          children: const [
            LinearProgressIndicator(
              minHeight: 3,
              color: TColors.primary,
              backgroundColor: TColors.primaryBackground,
            ),
            SizedBox(height: 12),
            Text(
              'Memuat dataset terbaru...',
              style: TextStyle(color: TColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (controller.agriInfoList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: const Text(
          'Belum ada dataset yang dapat ditampilkan.',
          style: TextStyle(color: TColors.textSecondary),
        ),
      );
    }

    return Column(
      children: controller.agriInfoList.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AgriInfoListItem(
            agriInfo: item,
            onTap: () => _handleItemTap(item),
          ),
        );
      }).toList(),
    );
  }

  void _handleItemTap(AgriInfoModel agriInfo) {
    final controller = Get.find<AgriInfoController>();
    controller.navigateToDetail(agriInfo.id);
  }
}
