import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TArticleSearchBar extends StatelessWidget {
  const TArticleSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.search_normal,
            color: Colors.grey[500],
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Cari Artikel',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.tune,
              color: Colors.orange[600],
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
} 