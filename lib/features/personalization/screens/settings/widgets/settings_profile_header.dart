import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/features/personalization/screens/profile/profile.dart';

class TSettingsProfileHeader extends StatelessWidget {
  const TSettingsProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final textTheme = Theme.of(context).textTheme;

    return Obx(() => GestureDetector(
      onTap: () => Get.to(() => const ProfileScreen()),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: controller.user.value.profilePicture.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      controller.user.value.profilePicture,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    ),
                  )
                : _buildDefaultAvatar(),
          ),
          
          const SizedBox(width: 12),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.user.value.fullName.isNotEmpty 
                      ? controller.user.value.fullName 
                      : 'Muhammad Nizam Setiawan',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Golokan Sidayu Gresik',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: Text(
          '👨‍🌾',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
} 