import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/personalization/controllers/feedback_controller.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackController());
    final userController = Get.find<UserController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Masukan Pengguna'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Description
              Text(
                'Berikan Feedback Anda',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bantu kami meningkatkan AgriGresik dengan membagikan pengalaman, saran, atau keluhan Anda.',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Nama Pengguna Field (Pre-filled, Disabled)
              _buildInputField(
                context,
                'Nama Pengguna',
                userController.user.value.fullName.isNotEmpty 
                    ? userController.user.value.fullName 
                    : 'Muhammad Nizam Setiawan',
                isEnabled: false,
                controller: controller.usernameController,
              ),
              
              const SizedBox(height: 16),
              
              // Email Field (Pre-filled, Disabled)
              _buildInputField(
                context,
                'Email',
                userController.user.value.email.isNotEmpty 
                    ? userController.user.value.email 
                    : 'takat89@gmail.com',
                isEnabled: false,
                controller: controller.emailController,
              ),
              
              const SizedBox(height: 16),
              
              // Subject Field (Editable)
              _buildInputField(
                context,
                'Subject',
                'Bug',
                isEnabled: true,
                controller: controller.subjectController,
                hintText: 'Masukkan subjek feedback',
              ),
              
              const SizedBox(height: 16),
              
              // Message Field (Editable, Multi-line)
              _buildInputField(
                context,
                'Pesan',
                'Server masih lambat untuk memproses',
                isEnabled: true,
                controller: controller.messageController,
                hintText: 'Jelaskan feedback Anda secara detail',
                maxLines: 4,
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.submitFeedback(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[500],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Kirim',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context,
    String label,
    String initialValue,
    {bool isEnabled = true,
    TextEditingController? controller,
    String? hintText,
    int maxLines = 1}
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    // Set initial value if controller is provided and it's empty
    if (controller != null && controller.text.isEmpty) {
      controller.text = initialValue;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: isEnabled && controller != null
              ? TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, 
                      vertical: 14,
                    ),
                    hintText: hintText,
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, 
                    vertical: 14,
                  ),
                  child: Text(
                    initialValue,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isEnabled ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
