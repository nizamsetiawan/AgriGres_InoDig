import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:agrigres/data/repositories/authentication/authentication_repository.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/utils/constraints/image_strings.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/helpers/network_manager.dart';
import 'package:agrigres/utils/popups/full_screen_loader.dart';

import '../../../../utils/logging/logger.dart';

class LoginController extends GetxController {

  ///variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());


  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  ///email and password sign in
  Future<void> emailAndPasswordSignIn() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog('Sedang masuk...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if(!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //save data if remember me is selected
      if(rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      //login user with email & password authentication
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      TLoggerHelper.debug('User successfully signed in with email: ${userCredentials}');

      //remove loader
      TFullScreenLoader.stopLoading();

      //Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh tidak...', message: e.toString());
    }
  }

  /// Google signIn authentication
  Future<void> googleSignIn() async {
    try{
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Sedang masuk...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Google Authentication
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      TLoggerHelper.debug('User successfully signed in with google: ${userCredentials}');

      // Save User Record
      await userController.saveUserRecord(userCredentials);



      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();

    } catch(e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      TLoaders.errorSnackBar(title: 'Oh tidak...', message: e.toString());
    }
  }
}