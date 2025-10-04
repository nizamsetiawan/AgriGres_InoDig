import 'package:flutter/material.dart';

class AgriInfoSectionHeader extends StatelessWidget {
  const AgriInfoSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Pangan',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Update harga pangan harian & data pertanian Gresik',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
