import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/personalization/controllers/feedback_controller.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/text_strings.dart';
import 'package:agrigres/utils/validators/validation.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackController());

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(TTexts.feedbackFormTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TTexts.feedbackDescription, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              TextFormField(
                controller: controller.usernameController, // Display the user's full name
                decoration: InputDecoration(
                  labelText: TTexts.userName,
                  prefixIcon: const Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.emailController, // Display the user's email
                decoration: InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: const Icon(Iconsax.direct_inbox),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Form(
                key: controller.feedbackFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.subjectController,
                      validator: (value) => TValidator.validateGeneral(value),
                      decoration: InputDecoration(
                        labelText: TTexts.subjectLabel,
                        prefixIcon: const Icon(Iconsax.edit),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.messageController,
                      validator: (value) => TValidator.validateGeneral(value),
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: TTexts.messageLabel,
                        prefixIcon: const Icon(Iconsax.message),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.submitFeedback(),
                  child: Text(TTexts.submitButtonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
