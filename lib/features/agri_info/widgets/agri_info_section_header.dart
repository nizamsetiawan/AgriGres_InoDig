import 'package:flutter/material.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class AgriInfoSectionHeader extends StatelessWidget {
  const AgriInfoSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Pertanian Gresik',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: TColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Dataset resmi Dinas Pertanian & Ketahanan Pangan Kabupaten Gresik',
          style: textTheme.bodyMedium?.copyWith(
            color: TColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
