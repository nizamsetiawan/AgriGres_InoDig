import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/styles/spacing_styles.dart';
import 'package:agrigres/common/widgets/login_signup/social_buttons.dart';
import 'package:agrigres/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/helpers/helper_functions.dart';
import 'package:agrigres/routes/routes.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dark = THelperFunctions.isDarkMode(context);

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
              Text(
                TTexts.signUpTitle,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                TTexts.signUpSubTitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              /// form
              const TSignupForm(),
              const SizedBox(height: 12),

              /// footer social buttons (matching login)
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
