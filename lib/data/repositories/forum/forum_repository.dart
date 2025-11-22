import 'package:agrigres/features/forum/models/forum_post_model.dart';
import 'package:agrigres/features/forum/repositories/tag_post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/logging/logger.dart';
import '../../../utils/constraints/api_constants.dart';

class ForumRepository extends GetxController {
  static ForumRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _userController = Get.find<UserController>();

  UserController get userController => _userController;

  // Upload images to Cloudinary
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    try {
      TLoggerHelper.info('Uploading images to Cloudinary...');
      List<String> downloadUrls = [];
      
      for (String imagePath in imagePaths) {
        String downloadUrl = await _uploadToCloudinary(imagePath);
        downloadUrls.add(downloadUrl);
      }
      
      TLoggerHelper.info('Successfully uploaded ${downloadUrls.length} images');
      return downloadUrls;
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error while uploading images: $e');
      throw 'Something went wrong while uploading images';
    }
  }

  Future<String> _uploadToCloudinary(String imagePath) async {
    String cloudName = APIConstants.cloudinaryCloudName;
    String apiKey = APIConstants.cloudinaryApiKey;
    String apiSecret = APIConstants.cloudinaryApiSecret;
    
    // List of presets to try in order (from .env)
    List<String> presets = APIConstants.cloudinaryUploadPresets;
    
    for (String preset in presets) {
      try {
        var uri = Uri.parse("${APIConstants.cloudinaryBaseUrl}/$cloudName/image/upload");
        var request = http.MultipartRequest("POST", uri);

        request.files.add(await http.MultipartFile.fromPath('file', imagePath));
        request.fields['upload_preset'] = preset;
        request.fields['resource_type'] = "image";
        
        // Add API key and secret for signed uploads if available
        if (apiKey.isNotEmpty) {
          request.fields['api_key'] = apiKey;
        }
        if (apiSecret.isNotEmpty && preset != 'unsigned') {
          request.fields['api_secret'] = apiSecret;
        }

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        var jsonResponse = json.decode(responseString);
        
        // Check if response is successful and contains secure_url
        if (response.statusCode == 200 && jsonResponse['secure_url'] != null) {
          return jsonResponse['secure_url'] as String;
        } else if (response.statusCode == 400 && jsonResponse['error'] != null) {
          // If this preset fails, try the next one
          continue;
        } else {
          throw 'Failed to upload image: ${jsonResponse['error']?.toString() ?? 'Unknown error'}';
        }
      } catch (e) {
        // If this preset fails, try the next one
        if (preset == presets.last) {
          rethrow;
        }
        continue;
      }
    }
    
    throw 'All Cloudinary upload presets failed';
  }

  // Get all forum posts (one-time fetch)
  Future<List<ForumPostModel>> getAllForumPosts() async {
    try {
      TLoggerHelper.info('Fetching forum posts from Firebase...');
      
      final snapshot = await _db
          .collection('ForumPosts')
          .orderBy('created_at', descending: true)
          .get();
      
      TLoggerHelper.info('Firebase snapshot received with ${snapshot.docs.length} forum posts');
      
      if (snapshot.docs.isEmpty) {
        TLoggerHelper.warning('No forum posts found');
        return [];
      }
      
      final result = snapshot.docs.map((e) {
        return ForumPostModel.fromSnapshot(e);
      }).toList();
      
      TLoggerHelper.info('Successfully parsed ${result.length} forum posts');
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
      TLoggerHelper.error('Unknown error while fetching forum posts: $e');
      throw 'Something went wrong while fetching forum posts';
    }
  }

  // Stream all forum posts (realtime updates)
  Stream<List<ForumPostModel>> getAllForumPostsStream() {
    try {
      TLoggerHelper.info('Setting up realtime stream for forum posts...');
      
      return _db
          .collection('ForumPosts')
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((snapshot) {
        TLoggerHelper.debug('Realtime update: ${snapshot.docs.length} forum posts');
        
        if (snapshot.docs.isEmpty) {
          return [];
        }
        
        final result = snapshot.docs.map((e) {
          return ForumPostModel.fromSnapshot(e);
        }).toList();
        
        return result;
      });
    } catch (e) {
      TLoggerHelper.error('Error setting up forum posts stream: $e');
      return Stream.value([]);
    }
  }

  // Create new forum post
  Future<String> createForumPost({
    required String content,
    String? imageUrl,
    List<String>? imageUrls,
    String? location,
    List<String> tags = const [],
    bool isAnonymous = false,
    bool disableComments = false,
  }) async {
    try {
      TLoggerHelper.info('Creating new forum post...');
      
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        throw 'User not logged in';
      }

      final user = _userController.user.value;
      final postId = DateTime.now().millisecondsSinceEpoch.toString();

      TLoggerHelper.info('Creating post with location: $location');
      
      final forumPost = ForumPostModel(
        id: postId,
        userId: userId,
        userName: isAnonymous ? 'Pengguna Anonim' : user.fullName,
        userImageUrl: isAnonymous ? '' : user.profilePicture,
        content: content,
        imageUrl: imageUrl,
        imageUrls: imageUrls,
        location: location,
        tags: tags,
        isAnonymous: isAnonymous,
        disableComments: disableComments,
        likes: [],
        comments: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _db.collection('ForumPosts').doc(postId).set(forumPost.toJson());
      
      // Update tag usage counts
      if (tags.isNotEmpty) {
        for (String tag in tags) {
          await TagPostRepository.instance.createOrUpdateTag(tag);
        }
      }
      
      TLoggerHelper.info('Successfully created forum post with ID: $postId');
      return postId;
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      TLoggerHelper.error('Platform error: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error while creating forum post: $e');
      throw 'Something went wrong while creating forum post';
    }
  }

  // Like/Unlike forum post
  Future<void> toggleLike(String postId) async {
    try {
      TLoggerHelper.info('Toggling like for post: $postId');
      
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        throw 'User not logged in';
      }

      final postRef = _db.collection('ForumPosts').doc(postId);
      final postDoc = await postRef.get();
      
      if (!postDoc.exists) {
        throw 'Post not found';
      }

      final postData = postDoc.data()!;
      final likes = List<String>.from(postData['likes'] ?? []);
      
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      await postRef.update({
        'likes': likes,
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      TLoggerHelper.info('Successfully toggled like for post: $postId');
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      TLoggerHelper.error('Platform error: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error while toggling like: $e');
      throw 'Something went wrong while toggling like';
    }
  }

  // Add comment to forum post
  Future<void> addComment(String postId, String content) async {
    try {
      TLoggerHelper.info('Adding comment to post: $postId');
      
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        throw 'User not logged in';
      }

      final user = _userController.user.value;
      final commentId = DateTime.now().millisecondsSinceEpoch.toString();

      final comment = ForumCommentModel(
        id: commentId,
        userId: userId,
        userName: user.fullName,
        userImageUrl: user.profilePicture,
        content: content,
        createdAt: DateTime.now(),
      );

      final postRef = _db.collection('ForumPosts').doc(postId);
      final postDoc = await postRef.get();
      
      if (!postDoc.exists) {
        throw 'Post not found';
      }

      final postData = postDoc.data()!;
      final comments = List<Map<String, dynamic>>.from(postData['comments'] ?? []);
      comments.add(comment.toJson());

      await postRef.update({
        'comments': comments,
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      TLoggerHelper.info('Successfully added comment to post: $postId');
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      TLoggerHelper.error('Platform error: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error while adding comment: $e');
      throw 'Something went wrong while adding comment';
    }
  }

  // Delete forum post
  Future<void> deleteForumPost(String postId) async {
    try {
      TLoggerHelper.info('Deleting forum post: $postId');
      
      final userId = _userController.user.value.id;
      if (userId.isEmpty) {
        throw 'User not logged in';
      }

      final postRef = _db.collection('ForumPosts').doc(postId);
      final postDoc = await postRef.get();
      
      if (!postDoc.exists) {
        throw 'Post not found';
      }

      final postData = postDoc.data()!;
      if (postData['user_id'] != userId) {
        throw 'You can only delete your own posts';
      }

      await postRef.delete();
      
      TLoggerHelper.info('Successfully deleted forum post: $postId');
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      TLoggerHelper.error('Platform error: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error while deleting forum post: $e');
      throw 'Something went wrong while deleting forum post';
    }
  }

  // Check if user liked a post
  bool isLiked(String postId, List<String> likes) {
    final userId = _userController.user.value.id;
    return likes.contains(userId);
  }

  // Update user profile in all forum posts and comments
  Future<void> updateUserProfileInForumPosts({
    required String userId,
    String? userName,
    String? userImageUrl,
  }) async {
    try {
      TLoggerHelper.info('Updating user profile in forum posts for user: $userId');
      
      final batch = _db.batch();
      final postsSnapshot = await _db
          .collection('ForumPosts')
          .where('user_id', isEqualTo: userId)
          .get();

      int updateCount = 0;

      for (var postDoc in postsSnapshot.docs) {
        final postData = postDoc.data();
        final updateData = <String, dynamic>{};
        
        // Check if post is anonymous - don't update anonymous posts
        final isAnonymous = postData['is_anonymous'] ?? false;
        
        // Only update post user info if post is NOT anonymous
        if (!isAnonymous) {
          if (userName != null) {
            updateData['user_name'] = userName;
          }
          if (userImageUrl != null) {
            updateData['user_image_url'] = userImageUrl;
          }
        }

        // Update user info in comments (comments are never anonymous, so always update)
        if (postData['comments'] != null) {
          final comments = List<Map<String, dynamic>>.from(postData['comments']);
          bool commentsUpdated = false;

          for (var i = 0; i < comments.length; i++) {
            if (comments[i]['user_id'] == userId) {
              if (userName != null) {
                comments[i]['user_name'] = userName;
              }
              if (userImageUrl != null) {
                comments[i]['user_image_url'] = userImageUrl;
              }
              commentsUpdated = true;
            }
          }

          if (commentsUpdated) {
            updateData['comments'] = comments;
          }
        }

        if (updateData.isNotEmpty) {
          updateData['updated_at'] = DateTime.now().toIso8601String();
          batch.update(postDoc.reference, updateData);
          updateCount++;
        }
      }

      // Also update comments in other users' posts
      final allPostsSnapshot = await _db
          .collection('ForumPosts')
          .get();

      for (var postDoc in allPostsSnapshot.docs) {
        final postData = postDoc.data();
        if (postData['comments'] != null) {
          final comments = List<Map<String, dynamic>>.from(postData['comments']);
          bool commentsUpdated = false;

          for (var i = 0; i < comments.length; i++) {
            if (comments[i]['user_id'] == userId) {
              if (userName != null) {
                comments[i]['user_name'] = userName;
              }
              if (userImageUrl != null) {
                comments[i]['user_image_url'] = userImageUrl;
              }
              commentsUpdated = true;
            }
          }

          if (commentsUpdated) {
            batch.update(postDoc.reference, {
              'comments': comments,
              'updated_at': DateTime.now().toIso8601String(),
            });
            updateCount++;
          }
        }
      }

      if (updateCount > 0) {
        await batch.commit();
        TLoggerHelper.info('Successfully updated user profile in $updateCount forum posts');
      } else {
        TLoggerHelper.info('No forum posts found to update for user: $userId');
      }
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error updating user profile: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unknown error updating user profile in forum posts: $e');
      throw 'Something went wrong while updating user profile in forum posts';
    }
  }
}
