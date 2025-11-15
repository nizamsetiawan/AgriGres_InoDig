import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'data/services/firebase_config_service.dart';
import 'firebase_options.dart';

void main()  async{
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  await initializeDateFormatting('id_ID', null);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
        (FirebaseApp value) {
          Get.put(AuthenticationRepository());
          // Initialize Firebase Config Service (akan fallback ke .env jika gagal)
          Get.put(FirebaseConfigService());
          FirebaseConfigService.instance.initialize();
        },
  );

  runApp(const App());
}

