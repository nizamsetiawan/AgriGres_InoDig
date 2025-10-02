import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:agrigres/features/article/screens/detail_articles/detail_articles.dart';

class TArticleCard extends StatelessWidget {
  const TArticleCard({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Get.to(() => DetailArticlesScreen(articleModel: article)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green[300]!,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Article Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
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
                                size: 20,
                              ),
                            );
                          },
                        )
                      : Icon(
                          Icons.image,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                ),
              ),
              
              const SizedBox(width: 10),
              
              // Article Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      article.content,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        height: 1.2,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 