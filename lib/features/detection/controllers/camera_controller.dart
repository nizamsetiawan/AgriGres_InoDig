import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/media/media_repository.dart';
import '../../../utils/logging/logger.dart';

class CameraController extends GetxController {
  final MediaRepository mediaRepository = Get.put(MediaRepository());
  final Rxn<XFile> capturedImage = Rxn<XFile>();

  Future<void> captureImage() async {
    try {
      TLoggerHelper.info("Attempting to capture image...");
      capturedImage.value = await mediaRepository.captureImageFromCamera();
      TLoggerHelper.info("Image captured successfully.");
    } catch (e) {
      TLoggerHelper.error("Failed to capture image", e);
      Get.snackbar("Error", "Could not capture image: ${e.toString()}");
    }
  }
}
