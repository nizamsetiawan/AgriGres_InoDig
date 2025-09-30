import 'package:agrigres/utils/logging/logger.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/repositories/location/location_repository.dart';

class GeoTaggingController extends GetxController {
  static GeoTaggingController get instance => Get.find();

  RxString strLocation = 'Mencari lokasi...'.obs;
  RxBool loading = false.obs;

  final geoTaggingRepository = GeoTaggingRepository();

  @override
  void onInit() {
    super.onInit();
    fetchGeoLocation(); 
  }

  void fetchGeoLocation() async {
    try {
      loading.value = true;
      Position position = await geoTaggingRepository.getGeoLocationPosition();

      List<Placemark> locations = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (locations.isNotEmpty) {
        Placemark location = locations.first;
        String address = [
          location.subLocality,
          location.locality,  
          location.subAdministrativeArea,
          location.administrativeArea, 


        ].where((element) => element != null).join(", ");

        strLocation.value = address;
        TLoggerHelper.debug("Alamat: $address");
      } else {
        strLocation.value = 'Alamat tidak ditemukan';
      }
    } catch (e) {
      strLocation.value = 'Error fetching address';
      TLoggerHelper.error("Error: $e");
    } finally {
      loading.value = false;
    }
  }
}
