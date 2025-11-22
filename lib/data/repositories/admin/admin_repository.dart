import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/admin/models/admin_model.dart';
import 'package:agrigres/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:agrigres/utils/exceptions/firebase_exceptions.dart';
import 'package:agrigres/utils/exceptions/format_exceptions.dart';
import 'package:agrigres/utils/exceptions/platform_exceptions.dart';
import 'package:agrigres/utils/logging/logger.dart';

/// Repository class for admin-related operations
class AdminRepository extends GetxController {
  static AdminRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get authenticated admin data
  User? get authUser => _auth.currentUser;

  /// Login admin with email and password
  Future<AdminModel> loginAdmin(String email, String password) async {
    try {
      TLoggerHelper.info('Admin login attempt: $email');

      // Authenticate with Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user exists in Admins collection
      final adminDoc = await _db
          .collection('Admins')
          .where('Email', isEqualTo: email)
          .limit(1)
          .get();

      if (adminDoc.docs.isEmpty) {
        // If not in Admins collection, sign out
        await _auth.signOut();
        throw 'Email ini bukan akun admin';
      }

      final adminData = AdminModel.fromSnapshot(adminDoc.docs.first);

      // Check if admin is active
      if (!adminData.isActive) {
        await _auth.signOut();
        throw 'Akun admin telah dinonaktifkan';
      }

      // Update last login time
      await _db.collection('Admins').doc(adminData.id).update({
        'LastLoginAt': DateTime.now().toIso8601String(),
      });

      // Admin doesn't need email verification - mark email as verified
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        try {
          // Reload user to get latest status
          await userCredential.user!.reload();
          // Note: We can't programmatically verify email, but we skip verification check for admins
          TLoggerHelper.info('Admin email verification skipped (admin privilege)');
        } catch (e) {
          TLoggerHelper.warning('Could not reload user after admin login: $e');
        }
      }

      TLoggerHelper.info('Admin successfully logged in: ${adminData.name}');
      return adminData;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Admin login error', e);
      throw e.toString();
    }
  }

  /// Get current admin data
  Future<AdminModel?> getCurrentAdmin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final adminDoc = await _db
          .collection('Admins')
          .where('Email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (adminDoc.docs.isEmpty) return null;

      return AdminModel.fromSnapshot(adminDoc.docs.first);
    } catch (e) {
      TLoggerHelper.error('Error getting current admin', e);
      return null;
    }
  }

  /// Logout admin
  Future<void> logoutAdmin() async {
    try {
      await _auth.signOut();
      TLoggerHelper.info('Admin logged out');
    } catch (e) {
      TLoggerHelper.error('Error logging out admin', e);
      throw 'Gagal logout: ${e.toString()}';
    }
  }

  /// Create new admin (only super_admin can do this)
  Future<void> createAdmin(AdminModel admin, String password) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: admin.email,
        password: password,
      );

      // Save admin data to Firestore
      await _db.collection('Admins').doc(userCredential.user!.uid).set(admin.toJson());

      TLoggerHelper.info('Admin created: ${admin.email}');
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Error creating admin', e);
      throw 'Gagal membuat admin: ${e.toString()}';
    }
  }

  /// Check if email is admin
  Future<bool> isAdminEmail(String email) async {
    try {
      final adminDoc = await _db
          .collection('Admins')
          .where('Email', isEqualTo: email)
          .limit(1)
          .get();

      return adminDoc.docs.isNotEmpty;
    } catch (e) {
      TLoggerHelper.error('Error checking admin email', e);
      return false;
    }
  }
}

