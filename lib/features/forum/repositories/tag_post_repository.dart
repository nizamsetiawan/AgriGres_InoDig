import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrigres/features/forum/models/tag_post_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class TagPostRepository {
  static TagPostRepository get instance => TagPostRepository();
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create or update tag
  Future<void> createOrUpdateTag(String tagName) async {
    try {
      final tagId = tagName.toLowerCase().replaceAll(' ', '_');
      final tagRef = _db.collection('TagPost').doc(tagId);
      
      final tagDoc = await tagRef.get();
      
      if (tagDoc.exists) {
        // Update existing tag
        await tagRef.update({
          'usageCount': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        TLoggerHelper.info('Updated tag: $tagName');
      } else {
        // Create new tag
        final newTag = TagPostModel(
          id: tagId,
          name: tagName,
          usageCount: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await tagRef.set(newTag.toMap());
        TLoggerHelper.info('Created new tag: $tagName');
      }
    } catch (e) {
      TLoggerHelper.error('Error creating/updating tag: $e');
      rethrow;
    }
  }

  // Get all tags
  Future<List<TagPostModel>> getAllTags() async {
    try {
      final querySnapshot = await _db
          .collection('TagPost')
          .orderBy('usageCount', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TagPostModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error getting tags: $e');
      rethrow;
    }
  }

  // Get popular tags (top 10)
  Future<List<TagPostModel>> getPopularTags() async {
    try {
      final querySnapshot = await _db
          .collection('TagPost')
          .orderBy('usageCount', descending: true)
          .limit(10)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TagPostModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error getting popular tags: $e');
      rethrow;
    }
  }

  // Search tags
  Future<List<TagPostModel>> searchTags(String query) async {
    try {
      final querySnapshot = await _db
          .collection('TagPost')
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name', isLessThan: query.toLowerCase() + '\uf8ff')
          .orderBy('name')
          .limit(10)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TagPostModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error searching tags: $e');
      rethrow;
    }
  }

  // Decrease tag usage count when post is deleted
  Future<void> decreaseTagUsage(String tagName) async {
    try {
      final tagId = tagName.toLowerCase().replaceAll(' ', '_');
      final tagRef = _db.collection('TagPost').doc(tagId);
      
      await tagRef.update({
        'usageCount': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      TLoggerHelper.info('Decreased usage for tag: $tagName');
    } catch (e) {
      TLoggerHelper.error('Error decreasing tag usage: $e');
      rethrow;
    }
  }
}
