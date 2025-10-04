import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/notification/controllers/notification_controller.dart';
import 'package:agrigres/features/notification/screens/notification_upload_screen.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/features/detection/controllers/location_controller.dart';

class NotificationFormScreen extends StatelessWidget {
  const NotificationFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure UserController is initialized first
    Get.put(UserController());
    Get.put(GeoTaggingController());
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        title: Text('Layanan Darurat'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // User Profile Info (as disabled input fields)
              Obx(() => _buildUserProfileInfo(context, controller)),
              const SizedBox(height: 20),
              
              // Form Fields
              _buildFormFields(context, controller),
              const SizedBox(height: 20),
              
              // Continue Button
              _buildContinueButton(context, controller),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildUserProfileInfo(BuildContext context, NotificationController controller) {
    // Get user data from controller
    final userName = controller.userName.isNotEmpty ? controller.userName : 'Loading...';
    final userEmail = controller.userEmail.isNotEmpty ? controller.userEmail : 'Loading...';
    final userPhone = controller.userPhoneNumber.isNotEmpty ? controller.userPhoneNumber : 'Loading...';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Pelapor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 12),
        
        // Nama
        _buildDisabledInputField(
          context,
          'Nama Lengkap',
          userName,
          Icons.person,
        ),
        const SizedBox(height: 12),
        
        // Email
        _buildDisabledInputField(
          context,
          'Email',
          userEmail,
          Icons.email,
        ),
        const SizedBox(height: 12),
        
        // Phone
        _buildDisabledInputField(
          context,
          'Nomor Telepon',
          userPhone,
          Icons.phone,
        ),
      ],
    );
  }

  Widget _buildDisabledInputField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey[600],
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context, NotificationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Jenis Darurat
        _buildTextField(
          context,
          'Jenis Darurat / Kategori',
          'Contoh: Padi, Jagung, Cabai',
          controller.formData.value.jenisDarurat,
          (value) => controller.updateJenisDarurat(value),
        ),
        const SizedBox(height: 16),
        
        // Lokasi Lahan with GPS
        _buildLocationField(context, controller),
        const SizedBox(height: 16),
        
        // Tanggal Terjadi
        _buildDateField(context, controller),
        const SizedBox(height: 16),
        
        // Deskripsi Singkat
        _buildTextField(
          context,
          'Deskripsi Singkat',
          'Jelaskan kondisi darurat secara singkat',
          controller.formData.value.deskripsiSingkat,
          (value) => controller.updateDeskripsiSingkat(value),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    String hint,
    String value,
    Function(String) onChanged, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green[700]!, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, NotificationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tanggal Terjadi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, controller),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(controller.formData.value.tanggalTerjadi),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, NotificationController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : () {
          if (controller.isFormValid) {
            Get.to(() => const NotificationUploadScreen());
          } else {
            Get.snackbar(
              'Perhatian',
              'Mohon lengkapi semua  field yang wajib diisi',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red[400],
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: controller.isLoading.value 
            ? _buildShimmerButton()
            : const Text(
                'Lanjutkan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      )),
    );
  }

  Widget _buildShimmerButton() {
    return Container(
      height: 20,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, NotificationController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.formData.value.tanggalTerjadi,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateTanggalTerjadi(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildLocationField(BuildContext context, NotificationController controller) {
    final locationController = Get.find<GeoTaggingController>();
    
    // Listen to location changes and update the form field
    ever(locationController.strLocation, (String location) {
      if (location.isNotEmpty && 
          location != 'Mencari lokasi...' &&
          location != 'Error fetching address') {
        controller.updateLokasiLahan(location);
      }
    });
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lokasi Lahan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => controller.updateLokasiLahan(value),
                decoration: InputDecoration(
                  hintText: 'Contoh: Desa ABC, Kecamatan XYZ',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => Container(
              height: 48,
              child: ElevatedButton(
                onPressed: locationController.loading.value 
                    ? null 
                    : () {
                        locationController.fetchGeoLocation();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  side: locationController.loading.value
                      ? BorderSide(color: Colors.grey[400]!)
                      : BorderSide(color: Colors.green[700]!),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'GPS',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            )),
          ],
        ),
        // GPS Information below input field
        Obx(() {
          if (locationController.loading.value) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Mencari lokasi...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          } else if (locationController.strLocation.value.isNotEmpty && 
                     locationController.strLocation.value != 'Mencari lokasi...' &&
                     locationController.strLocation.value != 'Error fetching address') {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.green[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'GPS: ${locationController.strLocation.value}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

}
