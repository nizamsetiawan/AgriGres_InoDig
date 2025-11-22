import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/login_signup/social_buttons.dart';
import 'package:agrigres/features/authentication/screens/login/widgets/login_form.dart';
import 'package:agrigres/features/authentication/screens/login/widgets/login_header.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constraints/colors.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ///logo,title,subtitle
              const TLoginHeader(),

              ///form
              const TLoginForm(),

              ///footer
              const TSocialButtons(),

              const SizedBox(height: 24),

              Center(
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    children: [
                      const TextSpan(text: 'Belum punya akun?  '),
                      TextSpan(
                        text: 'Daftar',
                        style: textTheme.bodyMedium?.copyWith(
                          color: TColors.primary, 
                          fontWeight: FontWeight.w600
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(TRoutes.signup),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Admin Panel Access
              Center(
                child: TextButton.icon(
                  onPressed: () => Get.toNamed(TRoutes.adminLogin),
                  icon: const Icon(Iconsax.shield, size: 18),
                  label: const Text('Akses Admin Panel'),
                  style: TextButton.styleFrom(
                    foregroundColor: TColors.primary,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Credit Line
              Column(
                children: [
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Powered by GenZ',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'M Nizam Setiawan & Eka Aninda A',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}








