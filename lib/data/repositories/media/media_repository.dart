import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/logging/logger.dart';

class MediaRepository extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    try {
      TLoggerHelper.info("Picking image from gallery...");
      return await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      TLoggerHelper.error("Error picking image from gallery", e);
      rethrow;
    }
  }

  Future<XFile?> captureImageFromCamera() async {
    try {
      TLoggerHelper.info("Capturing image from camera...");
      return await _picker.pickImage(source: ImageSource.camera);
    } catch (e) {
      TLoggerHelper.error("Error capturing image from camera", e);
      rethrow;
    }
  }
}
