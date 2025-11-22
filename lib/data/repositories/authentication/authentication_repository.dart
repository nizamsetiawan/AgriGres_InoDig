import 'package:agrigres/features/authentication/screens/welcome/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:agrigres/data/repositories/user/user_repository.dart';
import 'package:agrigres/features/admin/controllers/admin_auth_controller.dart';
import 'package:agrigres/features/admin/screens/admin_dashboard.dart';
import 'package:agrigres/features/authentication/screens/onboarding/onboarding.dart';
import 'package:agrigres/features/authentication/screens/signup/verify_email.dart';
import 'package:agrigres/navigation_menu.dart';
import 'package:agrigres/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:agrigres/utils/exceptions/firebase_exceptions.dart';
import 'package:agrigres/utils/exceptions/format_exceptions.dart';
import 'package:agrigres/utils/exceptions/platform_exceptions.dart';
import 'package:agrigres/utils/logging/logger.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  ///variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  ///get authenticated user data
  User? get authUser => _auth.currentUser;

  ///called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  ///function to show relevant screen
  void screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Check if user is admin (admins don't need email verification)
      final isAdmin = await _isAdminUser(user.email ?? '');
      
      if (isAdmin) {
        // Admin users go directly to admin dashboard (no email verification needed)
        // Initialize admin auth controller if not already initialized
        AdminAuthController adminController;
        if (!Get.isRegistered<AdminAuthController>()) {
          adminController = Get.put(AdminAuthController());
        } else {
          adminController = Get.find<AdminAuthController>();
        }
        // Ensure admin data is loaded
        await adminController.checkAdminStatus();
        Get.offAll(() => const AdminDashboard());
      } else if (user.emailVerified) {
        // if the user's email is verified navigate to the main Navigation menu
        Get.offAll(() => const NavigationMenu());
      } else {
        // if the user's email is not verified navigate to the VerifyEmailScreen
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      //local storage
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const WelcomeScreen())
          : Get.offAll(const OnBoardingScreen());
    }
  }

  /// Check if user is admin
  Future<bool> _isAdminUser(String email) async {
    try {
      final adminDoc = await FirebaseFirestore.instance
          .collection('Admins')
          .where('Email', isEqualTo: email)
          .limit(1)
          .get();
      return adminDoc.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  ///[email authentication] login
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada yang tidak beres, Silakan coba lagi';
    }
  }

  ///[email authentication] register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada yang tidak beres, Silakan coba lagi';
    }
  }

  ///email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada yang tidak beres, Silakan coba lagi';
    }
  }

  ///[email authentication] - FORGOT PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada yang tidak beres, Silakan coba lagi';
    }
  }

  ///[re-authenticate] - RE AUTHENTICATE USER
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
     // create a credential
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      //RE AUTHENTICATE
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada yang tidak beres, Silakan coba lagi';
    }
  }

  ///[GoogleAuthentication] - Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      //trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      
      // Check if user cancelled the sign in
      if (userAccount == null) {
        throw 'Sign in dibatalkan';
      }

      //obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount.authentication;
      
      // Check if authentication details are available
      if (googleAuth == null || googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw 'Gagal mendapatkan token autentikasi dari Google';
      }

      //create a new credential
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      //once signed in, return the userCredential
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      TLoggerHelper.error('FirebaseAuthException during Google Sign-In', e);
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      TLoggerHelper.error('FirebaseException during Google Sign-In', e);
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      TLoggerHelper.error('FormatException during Google Sign-In', e);
      throw const TFormatException();
    } on PlatformException catch (e) {
      TLoggerHelper.error('PlatformException during Google Sign-In: ${e.code} - ${e.message}', e);
      // Log the actual error code for debugging
      if (e.code == 'sign_in_failed' || e.code == '10' || e.message?.contains('10') == true) {
        throw 'SHA-1 fingerprint tidak terdaftar. Pastikan production keystore SHA-1 sudah ditambahkan di Firebase Console.';
      }
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error('Unexpected error during Google Sign-In', e);
      throw 'Ada yang tidak beres, Silakan coba lagi: ${e.toString()}';
    }
  }

  ///logout user
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada yang tidak beres, Silakan coba lagi';
    }
  }

  /// delete user, remove user auth and firestore account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada yang tidak beres, Silakan coba lagi';
    }
  }
}
