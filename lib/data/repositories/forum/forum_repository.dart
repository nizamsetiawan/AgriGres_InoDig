import 'package:agrigres/features/forum/models/forum_post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/logging/logger.dart';

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
    String cloudName = dotenv.env["CLOUDINARY_CLOUD_NAME"] ?? '';
    String apiKey = dotenv.env["CLOUDINARY_API_KEY"] ?? '';
    String apiSecret = dotenv.env["CLOUDINARY_API_SECRET"] ?? '';
    
    // List of presets to try in order
    List<String> presets = ['profile_agroai', 'kenongotask_img'];
    
    for (String preset in presets) {
      try {
        var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
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

  // Get all forum posts
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

  // Create new forum post
  Future<String> createForumPost({
    required String content,
    String? imageUrl,
    List<String>? imageUrls,
    String? location,
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
        isAnonymous: isAnonymous,
        disableComments: disableComments,
        likes: [],
        comments: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _db.collection('ForumPosts').doc(postId).set(forumPost.toJson());
      
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
}
