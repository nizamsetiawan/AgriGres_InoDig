import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/notification/screens/notification_list_screen.dart';

class THomeHeader extends StatelessWidget {
  const THomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai, Nizam 👋',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Semoga panen melimpah',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => const NotificationListScreen()),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.notifications,
              color: Colors.orange[600],
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
} 