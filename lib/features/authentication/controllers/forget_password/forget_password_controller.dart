import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/data/repositories/authentication/authentication_repository.dart';
import 'package:agrigres/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/helpers/network_manager.dart';
import 'package:agrigres/utils/popups/full_screen_loader.dart';

import '../../../../utils/logging/logger.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  ///variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  ///send reset password email
  sendPasswordResetEmail() async {
    try{

      //start loading
      TFullScreenLoader.openLoadingDialog('Memproses permintaan Anda...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      TLoggerHelper.info('Sending password reset email to: ${email.text.trim()}');

      //form validation
      if(!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      //remove loader
      TFullScreenLoader.stopLoading();

      //show success screen
      TLoaders.successSnackBar(title: 'Email Terkirim', message: 'Tautan untuk mereset kata sandi telah dikirimkan ke email Anda'.tr);

      //redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      //remove loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh tidak...', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try{

      //start loading
      TFullScreenLoader.openLoadingDialog('Memproses permintaan Anda...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }
      TLoggerHelper.info('Resending password reset email to: $email');



      //send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //remove loader
      TFullScreenLoader.stopLoading();

      //show success screen
      TLoaders.successSnackBar(title: 'Email Terkirim', message: 'Tautan untuk mereset kata sandi telah dikirimkan ke email Anda'.tr);



    } catch (e) {
      //remove loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh tidak', message: e.toString());
    }
  }
}