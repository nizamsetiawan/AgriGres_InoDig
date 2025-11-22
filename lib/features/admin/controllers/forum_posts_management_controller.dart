import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/forum/models/forum_post_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class ForumPostsManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final posts = <ForumPostModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  /// Load all forum posts
  Future<void> loadPosts() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading forum posts...');

      final snapshot = await _db
          .collection('ForumPosts')
          .orderBy('created_at', descending: true)
          .get();

      posts.assignAll(
        snapshot.docs.map((doc) => ForumPostModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${posts.length} forum posts');
    } catch (e) {
      TLoggerHelper.error('Error loading forum posts', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat postingan forum: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered posts based on search query
  List<ForumPostModel> get filteredPosts {
    if (searchQuery.value.isEmpty) {
      return posts;
    }
    return posts.where((post) {
      final query = searchQuery.value.toLowerCase();
      return post.content.toLowerCase().contains(query) ||
          post.userName.toLowerCase().contains(query) ||
          post.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  /// Delete post
  Future<void> deletePost(String postId) async {
    try {
      TLoggerHelper.info('Deleting post: $postId');

      await _db.collection('ForumPosts').doc(postId).delete();

      posts.removeWhere((post) => post.id == postId);

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Postingan berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting post', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus postingan: ${e.toString()}',
      );
    }
  }

  /// Update post
  Future<void> updatePost(ForumPostModel post) async {
    try {
      TLoggerHelper.info('Updating post: ${post.id}');

      await _db.collection('ForumPosts').doc(post.id).update(post.toJson());

      final index = posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        posts[index] = post;
      }

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Postingan berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating post', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui postingan: ${e.toString()}',
      );
    }
  }
}

