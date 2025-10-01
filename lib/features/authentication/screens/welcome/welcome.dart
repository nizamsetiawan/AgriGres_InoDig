import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/routes/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header logo
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  TImages.icFirstPageAuth,
                  width: 120,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),

              // Illustration + tagline
              Padding(
                padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage(TImages.icFarmerAuth),
                      width: 220,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Text(
                      'Mulai perjalananmu menuju pertanian modern & sejahtera!',
                      style: textTheme.bodyMedium?.copyWith(color: TColors.darkGrey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Email button (go to phone-register flow as requested)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(TRoutes.phoneRegister);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Lanjutkan dengan Email'),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              // Google outlined button (full-width)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(TRoutes.signIn),
                  icon: const Image(
                    image: AssetImage(TImages.google),
                    width: 20,
                    height: 20,
                  ),
                  label: const Text('Lanjutkan dengan Google', style: TextStyle(color: TColors.primary),),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: TColors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              // Apple button (orange)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.apple),
                  label: const Text('Lanjutkan dengan Apple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.secondary,
                    foregroundColor: Colors.white,
                    side: BorderSide(color: TColors.secondary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              // Login link with clickable 'Masuk'
              Center(
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(color: TColors.darkGrey),
                    children: [
                      const TextSpan(text: 'Sudah punya akun?  '),
                      TextSpan(
                        text: 'Masuk',
                        style: textTheme.bodyMedium?.copyWith(color: TColors.primary, fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(TRoutes.signIn),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections*3),

              // Terms text with clickable green links
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textTheme.labelMedium?.copyWith(color: TColors.darkGrey),
                  children: [
                    const TextSpan(text: 'Dengan mendaftar atau masuk, saya menyetujui '),
                    TextSpan(
                      text: 'Syarat Layanan',
                      style: textTheme.labelMedium?.copyWith(color: TColors.primary),
                      recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(TRoutes.privacyAndSecurity),
                    ),
                    const TextSpan(text: ' dan '),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: textTheme.labelMedium?.copyWith(color: TColors.primary),
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