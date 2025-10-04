import 'package:get/get.dart';
import 'package:agrigres/utils/helpers/network_manager.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserController());
  }
}