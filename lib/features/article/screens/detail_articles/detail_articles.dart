import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:flutter/material.dart';

class DetailArticlesScreen extends StatelessWidget {
  const DetailArticlesScreen({super.key, required this.articleModel});

  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        title: Text("Detail Artikel"),
        showBackArrow: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article Image
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: articleModel.imageUrl.isNotEmpty
                        ? Image.network(
                            articleModel.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey[500],
                                  size: 40,
                                ),
                              );
                            },
                          )
                        : Icon(
                            Icons.image,
                            color: Colors.grey[500],
                            size: 40,
                          ),
                  ),
                ),

                // Article Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article Title
                      Text(
                        articleModel.title,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Article Content
                      Text(
                        articleModel.content,
                        style: textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(height: 70), // Space for floating button
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Heart Button
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red[500],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle favorite action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Artikel ditambahkan ke favorit'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
