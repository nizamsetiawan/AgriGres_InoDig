import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/media/media_repository.dart';
import '../../../utils/logging/logger.dart';

class GalleryController extends GetxController {
  final MediaRepository mediaRepository = Get.put(MediaRepository());
  final Rxn<XFile> selectedImage = Rxn<XFile>();


  Future<void> selectImageFromGallery() async {
    try {
      TLoggerHelper.info("Attempting to select image from gallery...");
      selectedImage.value = await mediaRepository.pickImageFromGallery();
      TLoggerHelper.info("Image selected successfully.");
    } catch (e) {
      TLoggerHelper.error("Failed to select image from gallery", e);
      Get.snackbar("Error", "Could not pick image: ${e.toString()}");
    }
  }
}
