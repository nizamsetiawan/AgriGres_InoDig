import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:agrigres/data/repositories/authentication/authentication_repository.dart';
import 'package:agrigres/data/repositories/user/user_repository.dart';
import 'package:agrigres/features/authentication/screens/signup/verify_email.dart';
import 'package:agrigres/features/personalization/models/user_model.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/helpers/network_manager.dart';
import 'package:agrigres/utils/popups/full_screen_loader.dart';

import '../../../../utils/logging/logger.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///variables
  final hidePassword = true.obs; //observable for hiding/showing password
  final privacyPolicy = true.obs; //observable for privacy policy acceptance
  final email = TextEditingController(); //controller for email input
  final lastName = TextEditingController(); //controller for lastname input
  final username = TextEditingController(); //controller for username input
  final password = TextEditingController(); //controller for password input
  final firstName = TextEditingController(); //controller for firstname input
  final phoneNumber =
      TextEditingController(); //c
  //add field
  final age = TextEditingController();
  final gender = TextEditingController();
  final major = TextEditingController();
  final jobTitle = TextEditingController();
  final durationOfHypertension = TextEditingController();
  // ontroller for phone number input
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); //form key for form validation

  ///Sign up
  void signup() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialog(
          'Kami sedang memproses informasi Anda...', TImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!signupFormKey.currentState!.validate()) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //privacy policy check
      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: 'Terima kebijakan privasi',
          message:
              'Untuk membuat akun, Anda harus menerima kebijakan privasi & syarat penggunaan.',
        );
        return;
      }

      // register user in the firebase authentication and save user details in firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      TLoggerHelper.debug('User successfully signed up with email: ${userCredential}');

      // save authenticated new data in firebase firestore
      final newUser = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          username: username.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      //remove loader
      TFullScreenLoader.stopLoading();


      // show success snack bar
      TLoaders.successSnackBar(title: 'Selamat!', message: 'Akun Anda telah berhasil dibuat. Verifikasi email untuk melanjutkan.');

      // move to verify email screen
      Get.to(() =>  VerifyEmailScreen(email: email.text.trim()));

    } catch (e) {
      //remove loader
      TFullScreenLoader.stopLoading();

      //show some generic error to the user
      TLoaders.errorSnackBar(title: 'Oh tidak...', message: e.toString());
    }
  }

}
