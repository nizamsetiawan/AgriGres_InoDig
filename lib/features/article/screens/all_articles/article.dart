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

                    // Articles List
                    Obx(() {
                      if (articleController.isLoading.value) {
                        return const TVVerticalArticleShimmer();
                      }
                      
                      if (articleController.allArticles.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              'Tidak ada artikel tersedia',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: articleController.allArticles.length,
                        itemBuilder: (_, index) => TArticleCard(
                          article: articleController.allArticles[index],
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
