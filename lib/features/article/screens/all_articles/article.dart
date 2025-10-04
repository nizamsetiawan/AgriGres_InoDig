import 'package:agrigres/features/article/controllers/articles_controller.dart';
import 'package:agrigres/features/article/screens/all_articles/widgets/article_section_title.dart';
import 'package:agrigres/features/article/screens/all_articles/widgets/article_card.dart';
import 'package:agrigres/features/article/screens/all_articles/widgets/article_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/vertical_product_shimmer.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articleController = Get.put(ArticleController());
    articleController.fetchAllArticles();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Artikel'),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              foregroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            
            // Sticky Search Bar
            SliverAppBar(
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TArticleSearchBar(),
              ),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
            ),
            
            // Article Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    const TArticleSectionTitle(),
                    
                    const SizedBox(height: 16),
                    
                    // Active Filters Indicator
                    Obx(() {
                      if (articleController.searchQuery.value.isEmpty && 
                          articleController.selectedFilter.value == 'Semua') {
                        return const SizedBox.shrink();
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            if (articleController.searchQuery.value.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 16,
                                      color: Colors.blue[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '"${articleController.searchQuery.value}"',
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => articleController.clearSearch(),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (articleController.selectedFilter.value != 'Semua') ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.filter_list,
                                      size: 16,
                                      color: Colors.orange[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      articleController.selectedFilter.value,
                                      style: TextStyle(
                                        color: Colors.orange[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => articleController.filterByCategory('Semua'),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const Spacer(),
                            TextButton(
                              onPressed: () => articleController.clearAllFilters(),
                              child: Text(
                                'Hapus Semua',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Articles List
                    Obx(() {
                      if (articleController.isLoading.value) {
                        return const TVVerticalArticleShimmer();
                      }
                      
                      final articles = articleController.filteredArticles.isNotEmpty 
                          ? articleController.filteredArticles 
                          : articleController.allArticles;
                      
                      if (articles.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  articleController.searchQuery.value.isNotEmpty || 
                                  articleController.selectedFilter.value != 'Semua'
                                      ? 'Tidak ada artikel yang sesuai dengan filter'
                                      : 'Tidak ada artikel tersedia',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (articleController.searchQuery.value.isNotEmpty || 
                                    articleController.selectedFilter.value != 'Semua') ...[
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => articleController.clearAllFilters(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Hapus Filter'),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (_, index) => TArticleCard(
                          article: articles[index],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
