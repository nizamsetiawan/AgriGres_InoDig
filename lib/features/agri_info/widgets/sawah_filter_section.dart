import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/agri_info/controllers/sawah_controller.dart';

class SawahFilterSection extends StatelessWidget {
  const SawahFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SawahController>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kecamatan Filter
        Obx(() => _buildFilterItem(
          context,
          'Kecamatan',
          Text(
            controller.selectedKecamatan.value.isEmpty 
                ? 'Pilih Kecamatan' 
                : controller.selectedKecamatan.value,
            style: textTheme.bodyMedium?.copyWith(
              color: controller.selectedKecamatan.value.isEmpty 
                  ? Colors.grey[500] 
                  : Colors.grey[800],
            ),
          ),
          onTap: () => _showKecamatanPicker(context, controller),
        )),
        
        const SizedBox(height: 16),
        
        // Desa/Kelurahan Filter
        Obx(() => _buildFilterItem(
          context,
          'Desa/Kelurahan',
          Text(
            controller.selectedDesaKelurahan.value.isEmpty 
                ? 'Pilih Desa/Kelurahan' 
                : controller.selectedDesaKelurahan.value,
            style: textTheme.bodyMedium?.copyWith(
              color: controller.selectedDesaKelurahan.value.isEmpty 
                  ? Colors.grey[500] 
                  : Colors.grey[800],
            ),
          ),
          onTap: controller.selectedKecamatan.value.isNotEmpty 
              ? () => _showDesaKelurahanPicker(context, controller)
              : null,
          isEnabled: controller.selectedKecamatan.value.isNotEmpty,
        )),
      ],
    );
  }

  Widget _buildFilterItem(
    BuildContext context,
    String label,
    Widget valueWidget, {
    VoidCallback? onTap,
    bool isEnabled = true,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.green[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: isEnabled ? onTap : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isEnabled ? Colors.grey[300]! : Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(child: valueWidget),
                if (isEnabled)
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showKecamatanPicker(BuildContext context, SawahController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Pilih Kecamatan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final kecamatans = controller.kecamatanOptions;
                return ListView.builder(
                  itemCount: kecamatans.length + 1, // +1 for "Semua Kecamatan"
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Text(
                          'Semua Kecamatan',
                          style: const TextStyle(fontSize: 14),
                        ),
                        leading: Radio<String>(
                          value: '',
                          groupValue: controller.selectedKecamatan.value,
                          onChanged: (value) {
                            controller.selectKecamatan('');
                            Get.back();
                          },
                        ),
                      );
                    }
                    
                    final kecamatan = kecamatans[index - 1];
                    return ListTile(
                      title: Text(
                        kecamatan,
                        style: const TextStyle(fontSize: 14),
                      ),
                      leading: Radio<String>(
                        value: kecamatan,
                        groupValue: controller.selectedKecamatan.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectKecamatan(value);
                            Get.back();
                          }
                        },
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDesaKelurahanPicker(BuildContext context, SawahController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Pilih Desa/Kelurahan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final desaKelurahans = controller.desaKelurahanOptions;
                return ListView.builder(
                  itemCount: desaKelurahans.length + 1, // +1 for "Semua Desa/Kelurahan"
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Text(
                          'Semua Desa/Kelurahan',
                          style: const TextStyle(fontSize: 14),
                        ),
                        leading: Radio<String>(
                          value: '',
                          groupValue: controller.selectedDesaKelurahan.value,
                          onChanged: (value) {
                            controller.selectDesaKelurahan('');
                            Get.back();
                          },
                        ),
                      );
                    }
                    
                    final desaKelurahan = desaKelurahans[index - 1];
                    return ListTile(
                      title: Text(
                        desaKelurahan,
                        style: const TextStyle(fontSize: 14),
                      ),
                      leading: Radio<String>(
                        value: desaKelurahan,
                        groupValue: controller.selectedDesaKelurahan.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectDesaKelurahan(value);
                            Get.back();
                          }
                        },
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
