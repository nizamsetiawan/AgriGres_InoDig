import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/article/controllers/favorite_articles_controller.dart';
import 'package:agrigres/features/article/screens/detail_articles/detail_articles.dart';
import 'package:agrigres/common/widgets/loaders/article_shimmer.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class FavoriteArticlesScreen extends StatelessWidget {
  const FavoriteArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteArticlesController());
    
    // Load favorite articles when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadFavoriteArticles();
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Artikel Favorit'),
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          if (controller.favoriteArticles.isNotEmpty)
            IconButton(
              onPressed: () => _showDeleteAllDialog(context, controller),
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              tooltip: 'Hapus Semua',
            ),
          IconButton(
            onPressed: () => controller.loadFavoriteArticles(),
            icon: const Icon(Icons.refresh, color: TColors.primary),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: TArticleShimmer(),
          );
        }

        if (controller.favoriteArticles.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadFavoriteArticles(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.favoriteArticles.length,
            itemBuilder: (context, index) {
              final favoriteArticle = controller.favoriteArticles[index];
              final article = favoriteArticle.toArticleModel();
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: InkWell(
                  onTap: () => Get.to(() => DetailArticlesScreen(articleModel: article)),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Article Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                            child: article.imageUrl.isNotEmpty
                                ? Image.network(
                                    article.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.image,
                                          color: Colors.grey[500],
                                          size: 16,
                                        ),
                                      );
                                    },
                                  )
                                : Icon(
                                    Icons.image,
                                    color: Colors.grey[500],
                                    size: 16,
                                  ),
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Article Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                article.content,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Delete Button
                        IconButton(
                          onPressed: () => controller.removeFromFavorites(favoriteArticle.articleId),
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                          tooltip: 'Hapus dari Favorit',
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.favorite_border,
                size: 64,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Artikel Favorit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan artikel ke favorit dengan menekan tombol love di detail artikel',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.article_outlined),
              label: const Text('Lihat Artikel'),
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

  void _showDeleteAllDialog(BuildContext context, FavoriteArticlesController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_sweep, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Hapus Semua Favorit'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin menghapus semua artikel dari favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAllFavorites(controller);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }

  void _deleteAllFavorites(FavoriteArticlesController controller) {
    final articles = List<String>.from(controller.favoriteArticles.map((fav) => fav.articleId));
    for (String articleId in articles) {
      controller.removeFromFavorites(articleId);
    }
  }
}
