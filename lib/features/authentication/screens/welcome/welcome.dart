import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/routes/routes.dart';

import '../../controllers/login/login_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header logo
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  TImages.icFirstPageAuth,
                  width: 100,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // Illustration + tagline
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(TImages.icFarmerAuth),
                    width: 180,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mulai perjalananmu menuju pertanian modern & sejahtera!',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Email button (go to phone-register flow as requested)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(TRoutes.signup);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Daftar Sekarang'),
                ),
              ),

              const SizedBox(height: 12),

              // Google outlined button (full-width)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.googleSignIn(),
                  icon: const Image(
                    image: AssetImage(TImages.google),
                    width: 18,
                    height: 18,
                  ),
                  label: const Text(
                    'Lanjutkan dengan Google', 
                    style: TextStyle(color: TColors.primary)
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Apple button (orange)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.apple, size: 18),
                  label: const Text('Lanjutkan dengan Apple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Login link with clickable 'Masuk'
              Center(
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    children: [
                      const TextSpan(text: 'Sudah punya akun?  '),
                      TextSpan(
                        text: 'Masuk',
                        style: textTheme.bodyMedium?.copyWith(
                          color: TColors.primary, 
                          fontWeight: FontWeight.w600
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(TRoutes.signIn),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Terms text with clickable green links
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  children: [
                    const TextSpan(text: 'Dengan mendaftar atau masuk, saya menyetujui '),
                    TextSpan(
                      text: 'Syarat Layanan',
                      style: textTheme.bodySmall?.copyWith(color: TColors.primary),
                      recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(TRoutes.privacyAndSecurity),
                    ),
                    const TextSpan(text: ' dan '),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: textTheme.bodySmall?.copyWith(color: TColors.primary),
                      recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(TRoutes.privacyAndSecurity),
                    ),
                    const TextSpan(text: ' aplikasi.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 