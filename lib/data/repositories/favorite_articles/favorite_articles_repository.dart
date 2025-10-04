import 'package:agrigres/features/article/models/favorite_article_model.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/logging/logger.dart';

class FavoriteArticlesRepository extends GetxController {
  static FavoriteArticlesRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _userController = Get.find<UserController>();

  // Add article to favorites
  Future<void> addToFavorites(ArticleModel article) async {
    try {
      TLoggerHelper.info('Adding article to favorites: ${article.title}');
      
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        throw 'User not logged in';
      }

      // Check if already in favorites
      final existing = await _db
          .collection('FavoriteArticles')
          .where('user_id', isEqualTo: userId)
          .where('article_id', isEqualTo: article.title)
          .get();

      if (existing.docs.isNotEmpty) {
        TLoggerHelper.info('Article already in favorites');
        return;
      }

      // Create favorite article model
      final favoriteArticle = FavoriteArticleModel.fromArticleModel(
        userId: userId,
        article: article,
      );

      // Add to Firestore
      await _db.collection('FavoriteArticles').add(favoriteArticle.toJson());
      
      TLoggerHelper.info('Successfully added article to favorites');
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      TLoggerHelper.error('Format error: $e');
      throw const TFormatException();
    } on PlatformException catch (e) {
      TLoggerHelper.error('Platform error: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error while adding to favorites: $e');
      throw 'Something went wrong while adding to favorites';
    }
  }

  // Remove article from favorites
  Future<void> removeFromFavorites(String articleId) async {
    try {
      TLoggerHelper.info('Removing article from favorites: $articleId');
      
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        throw 'User not logged in';
      }

      // Find and delete the favorite
      final querySnapshot = await _db
          .collection('FavoriteArticles')
          .where('user_id', isEqualTo: userId)
          .where('article_id', isEqualTo: articleId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      
      TLoggerHelper.info('Successfully removed article from favorites');
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      TLoggerHelper.error('Platform error: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error while removing from favorites: $e');
      throw 'Something went wrong while removing from favorites';
    }
  }

  // Get all favorite articles for current user
  Future<List<FavoriteArticleModel>> getFavoriteArticles() async {
    try {
      TLoggerHelper.info('Fetching favorite articles...');
      
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        TLoggerHelper.warning('User not logged in, returning empty list');
        return [];
      }

      final snapshot = await _db
          .collection('FavoriteArticles')
          .where('user_id', isEqualTo: userId)
          .get();
      
      TLoggerHelper.info('Firebase snapshot received with ${snapshot.docs.length} favorite articles');
      
      if (snapshot.docs.isEmpty) {
        TLoggerHelper.info('No favorite articles found');
        return [];
      }
      
      final result = snapshot.docs.map((e) {
        return FavoriteArticleModel.fromSnapshot(e);
      }).toList();
      
      // Sort by added_at in descending order (newest first)
      result.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      
      TLoggerHelper.info('Successfully parsed ${result.length} favorite articles');
      return result;
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      TLoggerHelper.error('Format error: $e');
      throw const TFormatException();
    } on PlatformException catch (e) {
      TLoggerHelper.error('Platform error: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error while fetching favorite articles: $e');
      throw 'Something went wrong while fetching favorite articles';
    }
  }

  // Check if article is in favorites
  Future<bool> isFavorite(String articleId) async {
    try {
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        return false;
      }

      final querySnapshot = await _db
          .collection('FavoriteArticles')
          .where('user_id', isEqualTo: userId)
          .where('article_id', isEqualTo: articleId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      TLoggerHelper.error('Error checking if article is favorite: $e');
      return false;
    }
  }
}
