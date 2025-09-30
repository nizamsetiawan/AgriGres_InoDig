import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrigres/utils/formatters/formatter.dart';

///model class representing user data
class FeedbackModel {
  //keep the values which you do not want to update final
  final String username;
  final String email;
  String subject;
  String message;


  ///constructor for userModel
  FeedbackModel({
    required this.username,
    required this.email,
    required this.subject,
    required this.message,
  });
  

  ///static function to create an empty feedback model
  static FeedbackModel empty() => FeedbackModel( username: '', email: '', subject: '', message: '');

  ///convert model to json structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      'Username': username,
      'Email': email,
      'Subject': subject,
      'Message': message,
    };
  }

  ///factory method to create a feedback model from a firebase document snapshot.
  factory FeedbackModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return FeedbackModel(
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        subject: data['Subject'] ?? 'Belum diatur',
        message: data['Message'] ?? '',
      );
    } else {
      return FeedbackModel.empty();
    }
  }
}
