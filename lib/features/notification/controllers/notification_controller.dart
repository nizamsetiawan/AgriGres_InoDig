import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agrigres/features/notification/models/notification_model.dart';
import 'package:agrigres/features/notification/repositories/notification_repository.dart';
import 'package:agrigres/features/notification/screens/notification_detail_screen.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final NotificationRepository _repository = Get.put(NotificationRepository());
  final UserController _userController = Get.find<UserController>();

  // Form data
  final Rx<NotificationFormData> formData = NotificationFormData().obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxBool isUploaded = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString errorMessage = ''.obs;
  
  // Notifications list
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  final RxList<String> selectedImages = <String>[].obs;
  final RxList<String> uploadedImageUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    resetForm();
    // Ensure user data is loaded
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await _userController.fetchUserRecord();
  }

  void resetForm() {
    formData.value = NotificationFormData();
    selectedImages.clear();
    uploadedImageUrls.clear();
    errorMessage.value = '';
    uploadProgress.value = 0.0;
    isUploaded.value = false;
  }

  // Update form fields
  void updateJenisDarurat(String value) {
    formData.value.jenisDarurat = value;
    formData.refresh();
  }

  void updateLokasiLahan(String value) {
    formData.value.lokasiLahan = value;
    formData.refresh();
  }

  // Get user profile data
  String get userEmail => _userController.user.value.email;
  String get userName => _userController.user.value.fullName;
  String get userPhoneNumber => _userController.user.value.phoneNumber;

  void updateTanggalTerjadi(DateTime date) {
    formData.value.tanggalTerjadi = date;
    formData.refresh();
  }

  void updateDeskripsiSingkat(String value) {
    formData.value.deskripsiSingkat = value;
    formData.refresh();
  }

  // Image handling
  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        selectedImages.addAll(images.map((image) => image.path));
      }
    } catch (e) {
      errorMessage.value = 'Gagal memilih gambar: $e';
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImages.add(image.path);
      }
    } catch (e) {
      errorMessage.value = 'Gagal mengambil foto: $e';
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  // Upload images only
  Future<void> uploadImages() async {
    try {
      if (selectedImages.isEmpty) {
        errorMessage.value = 'Pilih gambar terlebih dahulu';
        return;
      }

      isUploading.value = true;
      errorMessage.value = '';
      uploadProgress.value = 0.0;

      // Upload images to Cloudinary
      uploadedImageUrls.value = await _repository.uploadImages(selectedImages);
      
      // Simulate progress
      for (int i = 0; i <= 100; i += 10) {
        uploadProgress.value = i / 100;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      isUploaded.value = true;

      Get.snackbar(
        'Berhasil',
        'Gambar berhasil diupload',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUploading.value = false;
    }
  }

  // Submit notification
  Future<void> submitNotification() async {
    try {
      if (!formData.value.isValid) {
        errorMessage.value = 'Mohon lengkapi semua field yang wajib diisi';
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';
      uploadProgress.value = 0.0;

      // Ensure user data is loaded before creating notification
      if (_userController.user.value.id.isEmpty) {
        await _userController.fetchUserRecord();
      }

      // Simulate progress for submit process
      for (int i = 0; i <= 100; i += 10) {
        uploadProgress.value = i / 100;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Create notification model
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        jenisDarurat: formData.value.jenisDarurat,
        lokasiLahan: formData.value.lokasiLahan,
        kontakPetani: userPhoneNumber, // Use phone number from profile
        namaPelapor: userName, // Use full name from profile
        tanggalTerjadi: formData.value.tanggalTerjadi,
        deskripsiSingkat: formData.value.deskripsiSingkat,
        imageUrls: uploadedImageUrls,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      // Save to Firebase
      await _repository.saveNotification(notification);

      // Reset form
      resetForm();

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Notifikasi darurat berhasil dikirim',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate back to navigation menu (home screen with navbar)
      Get.offAllNamed('/navigation-menu');

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validation
  bool get isFormValid => formData.value.isValid;
  bool get hasImages => selectedImages.isNotEmpty;

  // CRUD Operations
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      notifications.value = await _repository.getAllNotifications();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat data notifikasi: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getNotificationById(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final notification = await _repository.getNotificationById(id);
      if (notification != null) {
        // Navigate to detail screen
        Get.to(() => NotificationDetailScreen(notification: notification));
      } else {
        Get.snackbar(
          'Error',
          'Notifikasi tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[600],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat detail notifikasi: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNotificationStatus(String id, String status) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _repository.updateNotificationStatus(id, status);
      
      // Update local list
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
      }
      
      Get.snackbar(
        'Berhasil',
        'Status notifikasi berhasil diupdate',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal mengupdate status: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _repository.deleteNotification(id);
      
      // Remove from local list
      notifications.removeWhere((n) => n.id == id);
      
      Get.snackbar(
        'Berhasil',
        'Notifikasi berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal menghapus notifikasi: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

