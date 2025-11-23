import 'package:get/get.dart';
import 'package:agrigres/utils/helpers/network_manager.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/data/repositories/favorite_articles/favorite_articles_repository.dart';
import 'package:agrigres/data/repositories/forum/forum_repository.dart';
import 'package:agrigres/data/repositories/admin/admin_repository.dart';
import 'package:agrigres/data/repositories/announcement/announcement_repository.dart';
import 'package:agrigres/data/repositories/planting_calendar/planting_calendar_repository.dart';
import 'package:agrigres/data/repositories/farm_management/farm_repository.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserController());
    Get.put(FavoriteArticlesRepository());
    Get.put(ForumRepository());
    Get.put(AdminRepository());
    Get.put(AnnouncementRepository());
    Get.put(PlantingCalendarRepository());
    Get.put(FarmRepository());
  }
}