import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:agrigres/data/repositories/admin/admin_repository.dart';
import 'package:agrigres/features/admin/models/admin_model.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/helpers/network_manager.dart';
import 'package:agrigres/utils/popups/full_screen_loader.dart';
import 'package:agrigres/utils/logging/logger.dart';
import 'package:agrigres/features/admin/screens/admin_dashboard.dart';
import 'package:agrigres/routes/routes.dart';

class AdminAuthController extends GetxController {
  /// Variables
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final adminRepository = Get.put(AdminRepository());
  
  final currentAdmin = Rxn<AdminModel>();
  final isAdminLoggedIn = false.obs;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    checkAdminStatus();
  }

  /// Check if admin is logged in
  Future<void> checkAdminStatus() async {
    try {
      final admin = await adminRepository.getCurrentAdmin();
      if (admin != null) {
        currentAdmin.value = admin;
        isAdminLoggedIn.value = true;
      }
    } catch (e) {
      TLoggerHelper.error('Error checking admin status', e);
    }
  }

  /// Admin login
  Future<void> adminLogin() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog('Sedang masuk...', TImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Login admin
      final admin = await adminRepository.loginAdmin(
        email.text.trim(),
        password.text.trim(),
      );

      // Update current admin
      currentAdmin.value = admin;
      isAdminLoggedIn.value = true;

      // Remove loader
      TFullScreenLoader.stopLoading();

      // Show success message
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Selamat datang, ${admin.name}!',
      );

      // Navigate to admin dashboard
      Get.offAll(() => const AdminDashboard());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Gagal Masuk',
        message: e.toString(),
      );
    }
  }

  /// Admin logout
  Future<void> adminLogout() async {
    try {
      // Show confirmation dialog
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      TFullScreenLoader.openLoadingDialog('Sedang logout...', TImages.docerAnimation);

      await adminRepository.logoutAdmin();

      // Clear current admin
      currentAdmin.value = null;
      isAdminLoggedIn.value = false;

      // Clear form
      email.clear();
      password.clear();

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Anda telah logout',
      );

      // Navigate to user login
      Get.offAllNamed(TRoutes.signIn);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Gagal Logout',
        message: e.toString(),
      );
    }
  }
}

