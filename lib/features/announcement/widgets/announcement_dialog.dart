import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agrigres/features/admin/models/announcement_model.dart';

class AnnouncementDialog extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback? onDismiss;

  const AnnouncementDialog({
    Key? key,
    required this.announcement,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typeColors = {
      'announcement': Colors.blue,
      'update': Colors.green,
      'feature': Colors.purple,
    };
    final typeIcons = {
      'announcement': Iconsax.notification,
      'update': Iconsax.refresh,
      'feature': Iconsax.star,
    };

    final typeColor = typeColors[announcement.type] ?? Colors.blue;
    final typeIcon = typeIcons[announcement.type] ?? Iconsax.info_circle;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 360,
          maxHeight: 600, // batas tinggi dialog biar scroll
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(typeIcon, color: typeColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          announcement.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.close_circle, size: 20),
                      color: Colors.grey[600],
                      onPressed: () {
                        Get.back();
                        onDismiss?.call();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Image
              if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: announcement.imageUrl!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: Colors.grey[100],
                      child: Icon(Iconsax.image, size: 40, color: Colors.grey[400]),
                    ),
                  ),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Text(
                  announcement.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ),

              // Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                      onDismiss?.call();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: typeColor.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Mengerti',
                      style: TextStyle(
                        color: typeColor,
                        fontWeight: FontWeight.w500,
                      ),
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
}

