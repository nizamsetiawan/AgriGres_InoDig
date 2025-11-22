import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/personalization/models/user_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class UsersManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final users = <UserModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  /// Load all users
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading users...');

      final snapshot = await _db.collection('Users').get();
      users.assignAll(
        snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${users.length} users');
    } catch (e) {
      TLoggerHelper.error('Error loading users', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat data pengguna: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered users based on search query
  List<UserModel> get filteredUsers {
    if (searchQuery.value.isEmpty) {
      return users;
    }
    return users.where((user) {
      final query = searchQuery.value.toLowerCase();
      return user.email.toLowerCase().contains(query) ||
          user.fullName.toLowerCase().contains(query) ||
          user.username.toLowerCase().contains(query);
    }).toList();
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      TLoggerHelper.info('Deleting user: $userId');

      await _db.collection('Users').doc(userId).delete();

      users.removeWhere((user) => user.id == userId);

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengguna berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting user', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus pengguna: ${e.toString()}',
      );
    }
  }

  /// Update user
  Future<void> updateUser(UserModel user) async {
    try {
      TLoggerHelper.info('Updating user: ${user.id}');

      await _db.collection('Users').doc(user.id).update(user.toJson());

      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user;
      }

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Data pengguna berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating user', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui pengguna: ${e.toString()}',
      );
    }
  }
}

