import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/agri_info/widgets/agri_info_section_header.dart';
import 'package:agrigres/features/agri_info/widgets/agri_info_list_item.dart';
import 'package:agrigres/features/agri_info/controllers/agri_info_controller.dart';
import 'package:agrigres/features/agri_info/models/agri_info_model.dart';

class AgriInfoScreen extends StatelessWidget {
  const AgriInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('AgriInfoScreen build called'); // Debug log
    
    final controller = Get.put(AgriInfoController());
    print('AgriInfoController initialized successfully'); // Debug log
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
