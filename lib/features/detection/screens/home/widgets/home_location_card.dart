import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/features/detection/controllers/location_controller.dart';

class THomeLocationCard extends StatelessWidget {
  const THomeLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GeoTaggingController());
    final textTheme = Theme.of(context).textTheme;
    
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.location,
              color: Colors.grey[600],
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                controller.strLocation.value.isNotEmpty 
                    ? controller.strLocation.value 
                    : 'Desa Golokan, Sidayu Kab Gresik',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
} 