import 'package:flutter/material.dart';
import 'package:agrigres/common/widgets/login_signup/social_buttons.dart';
import 'package:agrigres/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

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
              
              const SizedBox(height: 24),
              
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
