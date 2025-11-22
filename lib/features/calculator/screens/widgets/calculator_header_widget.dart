import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';

class TCalculatorHeaderWidget extends StatelessWidget {
  const TCalculatorHeaderWidget({super.key});

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
                userController.user.value.firstName.isNotEmpty
                    ? 'Hai, ${userController.user.value.firstName} 👋'
                    : 'Hai, Pengguna 👋',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              )),
              const SizedBox(height: 2),
              Text(
                'Semoga panen melimpah 🌾',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Iconsax.notification,
            color: Colors.grey[600],
            size: 20,
          ),
        ),
      ],
    );
  }
} 