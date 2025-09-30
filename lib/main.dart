import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';

void main()  async{
  ///widgets binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  ///load env
  await dotenv.load(fileName: ".env");

  ///Get local storage
  await GetStorage.init();


  /// await splash until other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// initialize firebase and authentication repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
        (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  //load all material design/localization/themes/bindings
  runApp(const App());
}

