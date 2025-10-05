import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilter;
  final bool isLoading;

  const SearchBar({
    Key? key,
    required this.hintText,
    this.initialValue,
    this.onChanged,
    this.onClear,
    this.onFilter,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: initialValue != null 
                  ? TextEditingController(text: initialValue)
                  : null,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
              ),
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            )
          else if (initialValue != null && initialValue!.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.clear,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          const SizedBox(width: 8),
          // Filter Button
          GestureDetector(
            onTap: onFilter,
            child: Container(
              padding: const EdgeInsets.all(8),
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
