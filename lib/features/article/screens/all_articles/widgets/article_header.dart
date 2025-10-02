import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TArticleHeader extends StatelessWidget {
  const TArticleHeader({super.key});

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
                'Hai, Nizam Setiawan 👋',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Semoga selalu dalam keadaan sehat dan panen melimpah 🌾',
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
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Iconsax.notification,
            color: Colors.red[600],
            size: 20,
          ),
        ),
      ],
    );
  }
} 