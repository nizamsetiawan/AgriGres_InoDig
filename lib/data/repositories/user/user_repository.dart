import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agrigres/data/repositories/authentication/authentication_repository.dart';
import 'package:agrigres/features/personalization/models/user_model.dart';
import 'package:agrigres/utils/exceptions/firebase_exceptions.dart';
import 'package:agrigres/utils/exceptions/format_exceptions.dart';
import 'package:agrigres/utils/exceptions/platform_exceptions.dart';
import "package:http/http.dart" as http;

import '../../../features/personalization/models/feedback_model.dart';


///repository class for user-related operations
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ///function to save user data to firebase
  Future<void> saveUserRecord(UserModel user) async {
    try{
      await _db.collection('Users').doc(user.id).set(user.toJson());

    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again';
    }
  }

  Future<void> saveFeedbackRecord(FeedbackModel feedbackModel) async {
    try{
      await _db.collection('Feedback').doc(feedbackModel.email).set(feedbackModel.toJson());

    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again';
    }
  }

  ///Function to fetch user details based on user ID
  Future<UserModel> fetchUserDetails() async {
    try{
      final documentSnapshot = await _db.collection('Users').doc(AuthenticationRepository.instance.authUser?.uid).get();
      if(documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      }else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again';
    }
  }

  /// function to update user data in firestore
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try{
      await _db.collection('Users').doc(updatedUser.id).update(updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again';
    }
  }

  ///update specific user field in specific user collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try{
      await _db.collection('Users').doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again';
    }
  }

  ///function to remove user data from firestore
  Future<void> removeUserRecord(String userId) async {
    try{
      await _db.collection('Users').doc(userId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again';
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    String cloudName = dotenv.env["CLOUDINARY_CLOUD_NAME"] ?? '';
    String apiKey = dotenv.env["CLOUDINARY_API_KEY"] ?? '';
    try {
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      var request = http.MultipartRequest("POST", uri);

      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      request.fields['upload_preset'] = 'profile_agrigres';
      request.fields['resource_type'] = "image";
      request.fields['api_key'] = apiKey;

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      var jsonResponse = json.decode(responseString);
      return jsonResponse['secure_url'];
    } catch (e) {
      throw e.toString();
    }
  }

}