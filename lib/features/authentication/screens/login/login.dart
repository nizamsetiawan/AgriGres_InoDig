import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/styles/spacing_styles.dart';
import 'package:agrigres/common/widgets/login_signup/form_divider.dart';
import 'package:agrigres/common/widgets/login_signup/social_buttons.dart';
import 'package:agrigres/features/authentication/screens/login/widgets/login_form.dart';
import 'package:agrigres/features/authentication/screens/login/widgets/login_header.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}








