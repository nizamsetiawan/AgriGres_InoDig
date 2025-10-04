import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:agrigres/features/article/controllers/favorite_articles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailArticlesScreen extends StatefulWidget {
  const DetailArticlesScreen({super.key, required this.articleModel});

  final ArticleModel articleModel;

  @override
  State<DetailArticlesScreen> createState() => _DetailArticlesScreenState();
}

class _DetailArticlesScreenState extends State<DetailArticlesScreen> {
  final favoriteController = Get.put(FavoriteArticlesController());
  bool isFavorite = false;
  bool isLoadingFavorite = true;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final status = await favoriteController.isFavoriteAsync(widget.articleModel.title);
      if (mounted) {
        setState(() {
          isFavorite = status;
          isLoadingFavorite = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isFavorite = false;
          isLoadingFavorite = false;
        });
      }
    }
  }

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
                    child: widget.articleModel.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.articleModel.imageUrl,
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
                        widget.articleModel.title,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Article Content
                      Text(
                        widget.articleModel.content,
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
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isLoadingFavorite 
                    ? Colors.grey[300] 
                    : (isFavorite ? Colors.red[500] : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: isLoadingFavorite 
                    ? Border.all(color: Colors.grey[300]!, width: 2)
                    : (isFavorite 
                        ? Border.all(color: Colors.red[500]!, width: 2)
                        : null),
                boxShadow: [
                  BoxShadow(
                    color: isLoadingFavorite 
                        ? Colors.grey.withOpacity(0.2)
                        : (isFavorite 
                            ? Colors.red.withOpacity(0.3) 
                            : Colors.grey.withOpacity(0.2)),
                    spreadRadius: 0,
                    blurRadius: isLoadingFavorite ? 4 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoadingFavorite ? null : () async {
                    await favoriteController.toggleFavorite(widget.articleModel);
                    _checkFavoriteStatus(); // Refresh status
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: isLoadingFavorite
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.white : Colors.grey[600],
                          size: 24,
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
