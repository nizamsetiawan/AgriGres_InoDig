import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

class TForumHeader extends StatelessWidget {
  const TForumHeader({super.key});

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
                'Hi Niza Setiawan 👋',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'May you always in a good condition',
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