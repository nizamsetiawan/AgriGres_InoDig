import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/features/forum/controllers/forum_controller.dart';
import 'package:agrigres/features/forum/screens/widgets/forum_post_card.dart';
import 'package:agrigres/features/forum/screens/create_post_screen.dart';
import 'package:agrigres/common/widgets/loaders/shimmer.dart';
import 'package:agrigres/features/forum/screens/widgets/forum_search_bar.dart';

class FarmerForum extends StatelessWidget {
  const FarmerForum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForumController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.loadForumPosts();
          },
          color: TColors.primary,
          backgroundColor: Colors.white,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: const TForumSearchBar(),
                ),
              ),
              

              // Related Posts Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: TColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Postingan Terkait',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Navigate to all posts or implement filter
                        },
                        child: Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: TColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Forum Posts List
              Obx(() {
                if (controller.isLoading.value) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const TShimmerEffect(
                        width: double.infinity,
                        height: 200,
                      ),
                      childCount: 5,
                    ),
                  );
                }

                if (controller.filteredPosts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada postingan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Jadilah yang pertama berbagi pengalaman di forum ini',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = controller.filteredPosts[index];
                      return ForumPostCard(post: post);
                    },
                    childCount: controller.filteredPosts.length,
                  ),
                );
              }),

              // Additional Info Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: TColors.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: TColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tips Berbagi di Forum',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: TColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bagikan pengalaman, tips, dan pengetahuan Anda dengan komunitas petani lainnya.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildTipChip('Gunakan foto yang jelas'),
                          _buildTipChip('Jelaskan lokasi'),
                          _buildTipChip('Tulis dengan detail'),
                          _buildTipChip('Respon komentar'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildTipChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TColors.primary.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: TColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}