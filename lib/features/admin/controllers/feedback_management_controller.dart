import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/personalization/models/feedback_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class FeedbackManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final feedbacks = <FeedbackModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeedbacks();
  }

  /// Load all feedbacks
  Future<void> loadFeedbacks() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading feedbacks...');

      final snapshot = await _db.collection('Feedback').get();

      feedbacks.assignAll(
        snapshot.docs.map((doc) => FeedbackModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${feedbacks.length} feedbacks');
    } catch (e) {
      TLoggerHelper.error('Error loading feedbacks', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat feedback: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered feedbacks based on search query
  List<FeedbackModel> get filteredFeedbacks {
    if (searchQuery.value.isEmpty) {
      return feedbacks;
    }
    return feedbacks.where((feedback) {
      final query = searchQuery.value.toLowerCase();
      return feedback.email.toLowerCase().contains(query) ||
          feedback.username.toLowerCase().contains(query) ||
          feedback.subject.toLowerCase().contains(query) ||
          feedback.message.toLowerCase().contains(query);
    }).toList();
  }

  /// Delete feedback
  Future<void> deleteFeedback(String email) async {
    try {
      TLoggerHelper.info('Deleting feedback: $email');

      await _db.collection('Feedback').doc(email).delete();

      feedbacks.removeWhere((feedback) => feedback.email == email);

      await loadFeedbacks();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Feedback berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting feedback', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus feedback: ${e.toString()}',
      );
    }
  }
}

