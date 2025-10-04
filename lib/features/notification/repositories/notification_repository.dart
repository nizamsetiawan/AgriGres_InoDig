import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrigres/features/notification/models/notification_model.dart';
import 'package:agrigres/utils/exceptions/firebase_exceptions.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Upload images to Cloudinary
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    try {
      List<String> downloadUrls = [];
      
      for (String imagePath in imagePaths) {
        String downloadUrl = await _uploadToCloudinary(imagePath);
        downloadUrls.add(downloadUrl);
      }
      
      return downloadUrls;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Terjadi kesalahan saat mengupload gambar: $e';
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

  // Save notification to Firestore
  Future<void> saveNotification(NotificationModel notification) async {
    try {
      await _db.collection('Notifications').doc(notification.id).set(notification.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Terjadi kesalahan saat menyimpan notifikasi: $e';
    }
  }

  // Get all notifications
  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final snapshot = await _db.collection('Notifications')
          .orderBy('created_at', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => 
        NotificationModel.fromJson(doc.data())
      ).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Terjadi kesalahan saat mengambil data notifikasi: $e';
    }
  }

  // Get notification by ID
  Future<NotificationModel?> getNotificationById(String id) async {
    try {
      final doc = await _db.collection('Notifications').doc(id).get();
      if (doc.exists) {
        return NotificationModel.fromJson(doc.data()!);
      }
      return null;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Terjadi kesalahan saat mengambil notifikasi: $e';
    }
  }

  // Update notification status
  Future<void> updateNotificationStatus(String id, String status) async {
    try {
      await _db.collection('Notifications').doc(id).update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Terjadi kesalahan saat mengupdate status notifikasi: $e';
    }
  }

  // Delete notification
  Future<void> deleteNotification(String id) async {
    try {
      await _db.collection('Notifications').doc(id).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Terjadi kesalahan saat menghapus notifikasi: $e';
    }
  }
}
