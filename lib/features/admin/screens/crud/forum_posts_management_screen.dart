import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/forum_posts_management_controller.dart';
import 'package:agrigres/features/admin/screens/crud/edit_forum_post_screen.dart';
import 'package:agrigres/features/forum/models/forum_post_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:intl/intl.dart';

class ForumPostsManagementScreen extends StatelessWidget {
  const ForumPostsManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForumPostsManagementController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Manajemen Forum'),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              foregroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => controller.loadPosts(),
                  tooltip: 'Refresh',
                ),
              ],
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Cari postingan...',
                    prefixIcon: const Icon(Iconsax.search_normal),
                    suffixIcon: Obx(
                      () => controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Iconsax.close_circle),
                              onPressed: () => controller.searchQuery.value = '',
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),

            // Posts List
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final filteredPosts = controller.filteredPosts;

                if (filteredPosts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Tidak ada postingan'
                            : 'Postingan tidak ditemukan',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = filteredPosts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildPostCard(context, post, controller),
                      );
                    },
                    childCount: filteredPosts.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    ForumPostModel post,
    ForumPostsManagementController controller,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Iconsax.user,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: TSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.isAnonymous ? 'Anonymous' : post.userName,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      dateFormat.format(post.createdAt),
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Iconsax.edit, size: 18),
                          SizedBox(width: TSizes.xs),
                          Text('Edit'),
                        ],
                      ),
                      onTap: () => Future.delayed(
                        const Duration(milliseconds: 100),
                        () => Get.to(() => EditForumPostScreen(post: post)),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Iconsax.trash, size: 18, color: Colors.red),
                          SizedBox(width: TSizes.xs),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      onTap: () => Future.delayed(
                        const Duration(milliseconds: 100),
                        () => _showDeleteConfirmation(context, post, controller),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.sm),
            const Divider(height: 1),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
              child: Text(
                post.content,
                style: textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
            ),

            // Tags
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: TSizes.xs,
                children: post.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    labelStyle: const TextStyle(fontSize: 12),
                  );
                }).toList(),
              ),

            // Stats
            Row(
              children: [
                Icon(Iconsax.heart, size: 14, color: Colors.red[600]),
                const SizedBox(width: TSizes.xs),
                Text(
                  '${post.likes.length}',
                  style: textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
                const SizedBox(width: TSizes.md),
                Icon(Iconsax.message, size: 14, color: Colors.grey[600]),
                const SizedBox(width: TSizes.xs),
                Text(
                  '${post.comments.length}',
                  style: textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      );
  }


  void _showDeleteConfirmation(
    BuildContext context,
    ForumPostModel post,
    ForumPostsManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus postingan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deletePost(post.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

