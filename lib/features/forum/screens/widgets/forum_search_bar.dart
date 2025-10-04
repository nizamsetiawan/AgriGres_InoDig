import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/forum/controllers/forum_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class TForumSearchBar extends StatelessWidget {
  const TForumSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<ForumController>();

    return Column(
      children: [
        // Search Bar
        Container(
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
                  controller: controller.searchController,
                  onChanged: (value) => controller.searchPosts(value),
              style: textTheme.bodyMedium,
              decoration: InputDecoration(
                    hintText: 'Cari Postingan',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[500],
                              size: 18,
                            ),
                            onPressed: () => controller.clearSearch(),
                          )
                        : const SizedBox.shrink()),
              ),
            ),
          ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showFilterBottomSheet(context, controller),
                child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                    color: Colors.green[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.tune,
                    color: Colors.green[600],
              size: 16,
            ),
                ),
              ),
            ],
          ),
        ),
        
        // Filter Chips
        Obx(() {
          if (controller.selectedTagFilters.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    alignment: WrapAlignment.start,
                    children: [
                      ...controller.selectedTagFilters.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: TColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: TColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  color: TColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => controller.toggleTagFilter(tag),
                              child: Icon(
                                Icons.close,
                                color: TColors.primary,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                if (controller.selectedTagFilters.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextButton(
                      onPressed: () => controller.clearTagFilters(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Hapus Semua',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context, ForumController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Postingan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            
            // Tags Section
            Row(
              children: [
                Text(
                  'Tags',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (controller.selectedTagFilters.isNotEmpty)
                  GestureDetector(
                    onTap: () => controller.clearTagFilters(),
                    child: Text(
                      'Hapus Semua',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Tags List
            Obx(() {
              final allTags = controller.getAllTags();
              if (allTags.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Belum ada tag yang tersedia',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              }
              
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allTags.map((tag) {
                  final isSelected = controller.selectedTagFilters.contains(tag);
                  return GestureDetector(
                    onTap: () => controller.toggleTagFilter(tag),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? TColors.primary.withOpacity(0.1) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? TColors.primary.withOpacity(0.3) : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '#$tag',
                            style: TextStyle(
                              color: isSelected ? TColors.primary : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.check,
                              color: TColors.primary,
                              size: 14,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearAllFilters();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: Text(
                      'Hapus Semua',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 