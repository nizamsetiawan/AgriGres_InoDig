import 'package:agrigres/features/article/models/article_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/logging/logger.dart';

class ArticlesRepository extends GetxController {
  static ArticlesRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<ArticleModel>> getAllArticles() async {
    try {
      TLoggerHelper.info('Starting to fetch articles from Firebase...');
      
      final snapshot = await _db.collection('Articles').get();
      
      TLoggerHelper.info('Firebase snapshot received with ${snapshot.docs.length} documents');
      
      if (snapshot.docs.isEmpty) {
        TLoggerHelper.warning('No documents found in Articles collection');
        return [];
      }
      
      final result = snapshot.docs.map((e) {
        TLoggerHelper.info('Processing document: ${e.id}');
        TLoggerHelper.info('Document data: ${e.data()}');
        return ArticleModel.fromSnapshot(e);
      }).toList();
      
      TLoggerHelper.info('Successfully parsed ${result.length} articles');
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
      TLoggerHelper.error('Unknown error while fetching articles: $e');
      throw 'Something went wrong while fetching articles';
    }
  }

  Future<List<ArticleModel>> getArticlesByCategory(String category) async {
    try {
      final snapshot = await _db
          .collection('Articles')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((e) => ArticleModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again';
    }
  }

}
