import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

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
        Container(
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
      ],
    );
  }
} 