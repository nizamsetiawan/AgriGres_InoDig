import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/features/forum/controllers/forum_controller.dart';
import 'package:agrigres/features/forum/screens/widgets/forum_post_card.dart';
import 'package:agrigres/features/forum/screens/create_post_screen.dart';
import 'package:agrigres/common/widgets/loaders/article_shimmer.dart';
import 'package:agrigres/features/forum/screens/widgets/forum_search_bar.dart';

class FarmerForum extends StatelessWidget {
  const FarmerForum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForumController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Forum Petani'),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              foregroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            
            // Search Bar
            SliverAppBar(
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TForumSearchBar(),
              ),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
            ),
            
            // Forum Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Obx(() => Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.forum, color: TColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${controller.filteredPosts.length} Postingan',
                            style: TextStyle(
                              color: TColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people, color: Colors.green[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Aktif',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ),

            // Forum Posts
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: TArticleShimmer(),
                  ),
                );
              }

              if (controller.filteredPosts.isEmpty) {
                return SliverToBoxAdapter(
                  child: _buildEmptyState(context),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = controller.filteredPosts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ForumPostCard(post: post),
                    );
                  },
                  childCount: controller.filteredPosts.length,
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        if (controller.isLoading.value || controller.filteredPosts.isEmpty) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () => Get.to(() => const CreatePostScreen()),
          backgroundColor: TColors.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: TColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.forum_outlined,
                size: 64,
                color: TColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Postingan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Jadilah yang pertama berbagi cerita atau pertanyaan di forum ini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const CreatePostScreen()),
              icon: const Icon(Icons.add),
              label: const Text('Buat Postingan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 