import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../utils/constraints/api_constants.dart';

class GeoTaggingRepository extends GetxController {
  static GeoTaggingRepository get instance => Get.find();

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied forever');
    }

    // Get location accuracy from environment variables
    LocationAccuracy accuracy = _getLocationAccuracy(APIConstants.locationAccuracy);

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: accuracy,
    );
  }

  /// Convert location accuracy string to LocationAccuracy enum
  LocationAccuracy _getLocationAccuracy(String accuracy) {
    switch (accuracy.toLowerCase()) {
      case 'high':
        return LocationAccuracy.high;
      case 'medium':
        return LocationAccuracy.medium;
      case 'low':
        return LocationAccuracy.low;
      default:
        return LocationAccuracy.high;
    }
  }

}
