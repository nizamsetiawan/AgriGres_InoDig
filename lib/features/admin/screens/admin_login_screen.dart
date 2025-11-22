import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/admin_auth_controller.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';
import 'package:agrigres/utils/validators/validation.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAuthController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title & Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text(
                    'Admin Login',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masuk ke panel administrasi',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),

              /// Form
              Form(
                key: controller.loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: TSizes.spaceBtwSections),
                  child: Column(
                    children: [
                      /// Email
                      TextFormField(
                        controller: controller.email,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_inbox),
                          labelText: TTexts.email,
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Password
                      Obx(
                        () => TextFormField(
                          controller: controller.password,
                          validator: (value) => TValidator.validatePassword(value),
                          obscureText: controller.hidePassword.value,
                          decoration: InputDecoration(
                            labelText: TTexts.password,
                            prefixIcon: const Icon(Iconsax.password_check),
                            suffixIcon: IconButton(
                              onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                              icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.adminLogin(),
                          child: const Text(TTexts.signIn),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// Back to User Login
                      Center(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Kembali ke Login User'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

