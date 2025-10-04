import 'package:get/get.dart';
import 'package:agrigres/utils/helpers/network_manager.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/data/repositories/favorite_articles/favorite_articles_repository.dart';
import 'package:agrigres/data/repositories/forum/forum_repository.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserController());
    Get.put(FavoriteArticlesRepository());
    Get.put(ForumRepository());
  }
}