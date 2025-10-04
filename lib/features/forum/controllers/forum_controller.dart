import 'package:agrigres/data/repositories/forum/forum_repository.dart';
import 'package:agrigres/features/forum/models/forum_post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/loaders.dart';
import '../../../utils/logging/logger.dart';

class ForumController extends GetxController {
  static ForumController get instance => Get.find();

  final forumRepository = Get.put(ForumRepository());

  RxBool isLoading = false.obs;
  RxBool isCreatingPost = false.obs;
  RxBool isLiking = false.obs;
  RxBool isCommenting = false.obs;
  RxBool isUploadingImage = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  final RxList<ForumPostModel> forumPosts = <ForumPostModel>[].obs;
  final RxList<ForumPostModel> filteredPosts = <ForumPostModel>[].obs;
  final RxString errorMessage = ''.obs;

  // Search and filter
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'Semua'.obs;
  final searchController = TextEditingController();

  // Text controllers
  final postContentController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadForumPosts();
  }

  // Load all forum posts
  Future<void> loadForumPosts() async {
    try {
      TLoggerHelper.info('Loading forum posts...');
      isLoading.value = true;
      errorMessage.value = '';

      final posts = await forumRepository.getAllForumPosts();
      forumPosts.assignAll(posts);
      filteredPosts.assignAll(posts);

      TLoggerHelper.info('Loaded ${posts.length} forum posts');
    } catch (e) {
      TLoggerHelper.error('Error loading forum posts', e);
      errorMessage.value = e.toString();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Upload image to Cloudinary
  Future<String?> uploadImage(String imagePath) async {
    try {
      TLoggerHelper.info('Uploading image to Cloudinary...');
      isUploadingImage.value = true;
      uploadProgress.value = 0.0;

      // Upload to Cloudinary
      final uploadedUrls = await forumRepository.uploadImages([imagePath]);
      
      // Simulate progress
      for (int i = 0; i <= 100; i += 10) {
        uploadProgress.value = i / 100;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      isUploadingImage.value = false;
      TLoggerHelper.info('Successfully uploaded image');
      return uploadedUrls.first;
    } catch (e) {
      TLoggerHelper.error('Error uploading image', e);
      isUploadingImage.value = false;
      uploadProgress.value = 0.0;
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to upload image: $e');
      return null;
    }
  }

  // Upload multiple images to Cloudinary
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    try {
      TLoggerHelper.info('Uploading ${imagePaths.length} images to Cloudinary...');
      isUploadingImage.value = true;
      uploadProgress.value = 0.0;

      // Upload to Cloudinary
      final uploadedUrls = await forumRepository.uploadImages(imagePaths);
      
      // Simulate progress
      for (int i = 0; i <= 100; i += 10) {
        uploadProgress.value = i / 100;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      isUploadingImage.value = false;
      TLoggerHelper.info('Successfully uploaded ${uploadedUrls.length} images');
      return uploadedUrls;
    } catch (e) {
      TLoggerHelper.error('Error uploading images', e);
      isUploadingImage.value = false;
      uploadProgress.value = 0.0;
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to upload images: $e');
      return [];
    }
  }

  // Create new forum post
  Future<void> createForumPost({
    String? imageUrl, 
    List<String>? imageUrls, 
    String? location,
    bool isAnonymous = false,
    bool disableComments = false,
  }) async {
    try {
      if (postContentController.text.trim().isEmpty) {
        TLoaders.warningSnackBar(title: 'Warning', message: 'Please enter some content');
        return;
      }

      TLoggerHelper.info('Creating forum post...');
      isCreatingPost.value = true;
      errorMessage.value = '';

      await forumRepository.createForumPost(
        content: postContentController.text.trim(),
        imageUrl: imageUrl,
        imageUrls: imageUrls,
        location: location,
        isAnonymous: isAnonymous,
        disableComments: disableComments,
      );

      // Clear form
      postContentController.clear();

      // Reload posts
      await loadForumPosts();

      // Navigate back to previous screen
      Get.back();

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Post created successfully',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating forum post', e);
      errorMessage.value = e.toString();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isCreatingPost.value = false;
    }
  }

  // Toggle like on forum post
  Future<void> toggleLike(String postId) async {
    try {
      TLoggerHelper.info('Toggling like for post: $postId');
      isLiking.value = true;

      await forumRepository.toggleLike(postId);

      // Update local state
      final postIndex = forumPosts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = forumPosts[postIndex];
        final userId = forumRepository.userController.user.value.id;
        
        if (post.likes.contains(userId)) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }
        
        forumPosts[postIndex] = post;
      }

      TLoggerHelper.info('Successfully toggled like for post: $postId');
    } catch (e) {
      TLoggerHelper.error('Error toggling like', e);
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLiking.value = false;
    }
  }

  // Add comment to forum post
  Future<void> addComment(String postId) async {
    try {
      if (commentController.text.trim().isEmpty) {
        TLoaders.warningSnackBar(title: 'Warning', message: 'Please enter a comment');
        return;
      }

      TLoggerHelper.info('Adding comment to post: $postId');
      isCommenting.value = true;

      await forumRepository.addComment(postId, commentController.text.trim());

      // Clear comment form
      commentController.clear();

      // Reload posts to get updated comments
      await loadForumPosts();

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Comment added successfully',
      );
    } catch (e) {
      TLoggerHelper.error('Error adding comment', e);
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isCommenting.value = false;
    }
  }

  // Delete forum post
  Future<void> deleteForumPost(String postId) async {
    try {
      TLoggerHelper.info('Deleting forum post: $postId');

      await forumRepository.deleteForumPost(postId);

      // Remove from local state
      forumPosts.removeWhere((post) => post.id == postId);

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Post deleted successfully',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting forum post', e);
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Check if user liked a post
  bool isLiked(String postId) {
    final post = forumPosts.firstWhereOrNull((post) => post.id == postId);
    if (post == null) return false;
    return forumRepository.isLiked(postId, post.likes);
  }

  // Get like count
  int getLikeCount(String postId) {
    final post = forumPosts.firstWhereOrNull((post) => post.id == postId);
    return post?.likes.length ?? 0;
  }

  // Get comment count
  int getCommentCount(String postId) {
    final post = forumPosts.firstWhereOrNull((post) => post.id == postId);
    return post?.comments.length ?? 0;
  }

  // Check if user owns the post
  bool isOwner(String postId) {
    final post = forumPosts.firstWhereOrNull((post) => post.id == postId);
    if (post == null) return false;
    return post.userId == forumRepository.userController.user.value.id;
  }

  // Search posts
  void searchPosts(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  // Filter by category
  void filterByCategory(String category) {
    selectedFilter.value = category;
    applyFilters();
  }

  // Apply both search and filter
  void applyFilters() {
    List<ForumPostModel> filtered = List.from(forumPosts);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((post) {
        return post.content.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               post.userName.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    // Apply category filter (for now, just return all posts)
    // You can add category field to ForumPostModel later if needed
    if (selectedFilter.value != 'Semua') {
      // For now, just return all posts since we don't have category field
      // You can implement category filtering here when you add category to the model
    }

    filteredPosts.assignAll(filtered);
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    applyFilters();
  }

  // Clear all filters
  void clearAllFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedFilter.value = 'Semua';
    applyFilters();
  }

  @override
  void onClose() {
    postContentController.dispose();
    commentController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
