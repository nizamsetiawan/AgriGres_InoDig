import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilter;
  final bool isLoading;

  const SearchBar({
    Key? key,
    required this.hintText,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.onClear,
    this.onFilter,
    this.isLoading = false,
  }) : super(key: key);

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
              controller: controller ?? (initialValue != null ? TextEditingController(text: initialValue) : null),
              onChanged: onChanged,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: (initialValue != null && initialValue!.isNotEmpty)
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[500],
                          size: 18,
                        ),
                        onPressed: onClear,
                      )
                    : null,
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Filter Button
          GestureDetector(
            onTap: onFilter,
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
