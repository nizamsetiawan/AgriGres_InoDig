import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TSettingsMenuItem extends StatelessWidget {
  const TSettingsMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isLogout = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Define colors based on menu type
    Color getIconBackgroundColor() {
      if (isLogout) return Colors.red[50]!;
      
      switch (icon) {
        case Iconsax.user:
          return Colors.blue[50]!;
        case Iconsax.setting:
          return Colors.orange[50]!;
        case Iconsax.information:
          return Colors.green[50]!;
        case Iconsax.security_card:
          return Colors.purple[50]!;
        case Iconsax.call:
          return Colors.teal[50]!;
        default:
          return Colors.grey[100]!;
      }
    }

    Color getIconColor() {
      if (isLogout) return Colors.red[600]!;
      
      switch (icon) {
        case Iconsax.user:
          return Colors.blue[600]!;
        case Iconsax.setting:
          return Colors.orange[600]!;
        case Iconsax.information:
          return Colors.green[600]!;
        case Iconsax.security_card:
          return Colors.purple[600]!;
        case Iconsax.call:
          return Colors.teal[600]!;
        default:
          return Colors.grey[700]!;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: getIconBackgroundColor(),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: getIconColor(),
                size: 16,
              ),
            ),
            
            const SizedBox(width: 10),
            
            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isLogout ? Colors.red[600] : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Arrow Icon
            Icon(
              Iconsax.arrow_right_3,
              color: Colors.grey[400],
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
} 