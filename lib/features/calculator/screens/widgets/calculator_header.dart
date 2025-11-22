import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';

class TCalculatorHeader extends StatelessWidget {
  const TCalculatorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final userController = Get.find<UserController>();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                userController.user.value.fullName.isNotEmpty
                    ? 'Hai, ${userController.user.value.fullName} 👋'
                    : 'Hai, Pengguna 👋',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 4),
              Text(
                'Semoga selalu dalam keadaan sehat dan panen melimpah 🌾',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Iconsax.notification,
            color: Colors.red[400],
            size: 24,
          ),
        ),
      ],
    );
  }
} 