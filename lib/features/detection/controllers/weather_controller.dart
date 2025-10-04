import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:agrigres/data/services/weather_service.dart';
import 'package:agrigres/features/detection/controllers/location_controller.dart';

class WeatherController extends GetxController {
  static WeatherController get instance => Get.find();

  // Weather data observables
  final RxBool isLoading = false.obs;
  final RxString currentLocation = 'Jakarta'.obs;
  final RxString currentDate = ''.obs;
  final RxString currentTime = ''.obs;
  
  // Weather data
  final RxDouble temperature = 0.0.obs;
  final RxDouble feelsLike = 0.0.obs;
  final RxString weatherCondition = 'Berawan'.obs;
  final RxString weatherDescription = 'Berawan'.obs;
  final RxInt humidity = 0.obs;
  final RxDouble windSpeed = 0.0.obs;
  final RxString weatherIcon = 'wb_cloudy'.obs;

  // Timer for updating time
  late DateTime _currentDateTime;
  
  // Weather service
  final WeatherService _weatherService = WeatherService();
  
  // Location controller for GPS
  GeoTaggingController? _locationController;
  
  // GPS coordinates
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxBool _useGPSLocation = true.obs;
  
  // Popular Indonesian cities for weather
  final List<String> popularCities = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Semarang',
    'Makassar',
    'Palembang',
    'Tangerang',
    'Depok',
    'Bekasi',
    'Gresik',
    'Solo',
    'Malang',
    'Yogyakarta',
    'Bogor',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeDateTime();
    _startTimeUpdate();
    _initializeLocationController();
    
    // Delay initial weather fetch to allow GPS to initialize
    Future.delayed(const Duration(seconds: 2), () {
      fetchWeatherData();
    });
  }

  // Initialize location controller and get GPS coordinates
  void _initializeLocationController() {
    // Try to find GeoTaggingController, if not available, try again later
    _tryFindLocationController();
  }

  // Try to find GeoTaggingController with retry mechanism
  void _tryFindLocationController() {
    try {
      _locationController = Get.find<GeoTaggingController>();
      print('✅ GeoTaggingController found');
      _listenToLocationChanges();
    } catch (e) {
      print('⏳ GeoTaggingController not found yet, retrying in 1 second...');
      // Retry after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        _tryFindLocationController();
      });
    }
  }

  // Listen to location changes from GeoTaggingController
  void _listenToLocationChanges() {
    if (_locationController != null) {
      // Listen to location changes and update weather
      ever(_locationController!.strLocation, (String location) {
        if (location != 'Mencari lokasi...' && location != 'Error fetching address' && location.isNotEmpty) {
          // Update current location display
          currentLocation.value = location;
          _updateLocationFromGPS();
        }
      });
    }
  }

  // Update location from GPS coordinates
  Future<void> _updateLocationFromGPS() async {
    try {
      print('=== GPS UPDATE DEBUG ===');
      print('Location controller: ${_locationController != null}');
      print('GPS mode: ${_useGPSLocation.value}');
      
      if (_locationController != null && _useGPSLocation.value) {
        print('Getting GPS position...');
        // Get current position
        final position = await _locationController!.geoTaggingRepository.getGeoLocationPosition();
        _latitude.value = position.latitude;
        _longitude.value = position.longitude;
        
        print('✅ GPS Location set: ${_latitude.value}, ${_longitude.value}');
        
        // Update weather with GPS coordinates
        await _fetchWeatherByCoordinates();
      } else {
        print('❌ Cannot get GPS: controller=${_locationController != null}, GPS=${_useGPSLocation.value}');
      }
    } catch (e) {
      print('❌ GPS location error: $e');
      // Fallback to city name
      _useGPSLocation.value = false;
    }
  }


  void _initializeDateTime() {
    _currentDateTime = DateTime.now();
    _updateDateTime();
  }

  void _startTimeUpdate() {
    // Update time every minute
    Future.doWhile(() async {
      await Future.delayed(const Duration(minutes: 1));
      _updateDateTime();
      return true;
    });
  }

  void _updateDateTime() {
    _currentDateTime = DateTime.now();
    try {
      // Try Indonesian locale first
      currentDate.value = DateFormat('dd MMMM yyyy', 'id_ID').format(_currentDateTime);
      currentTime.value = DateFormat('HH:mm', 'id_ID').format(_currentDateTime);
    } catch (e) {
      // Fallback to English format if Indonesian locale is not available
      currentDate.value = DateFormat('dd MMMM yyyy').format(_currentDateTime);
      currentTime.value = DateFormat('HH:mm').format(_currentDateTime);
    }
  }

  // Fetch weather data from OpenWeatherMap API or fallback to mock data
  Future<void> fetchWeatherData() async {
    try {
      isLoading.value = true;
      
      // Try to fetch real weather data first
      if (_weatherService.isApiKeyConfigured) {
        await _fetchRealWeatherData();
      } else {
        // Fallback to mock data if API key not configured
        await _fetchMockWeatherData();
      }
      
    } catch (e) {
      // Fallback to mock data if API fails
      await _fetchMockWeatherData();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch real weather data from OpenWeatherMap API
  Future<void> _fetchRealWeatherData() async {
    try {
      print('=== WEATHER DEBUG ===');
      print('Current location: ${currentLocation.value}');
      print('GPS mode enabled: ${_useGPSLocation.value}');
      print('Latitude: ${_latitude.value}');
      print('Longitude: ${_longitude.value}');
      print('Location controller available: ${_locationController != null}');
      
      Map<String, dynamic>? weatherData;
      
      // Try GPS coordinates first if available
      if (_useGPSLocation.value && _latitude.value != 0.0 && _longitude.value != 0.0) {
        print('✅ Using GPS coordinates: ${_latitude.value}, ${_longitude.value}');
        weatherData = await _weatherService.getCurrentWeatherByCoordinates(
          _latitude.value, 
          _longitude.value
        );
      } else {
        // Fallback to city name
        print('❌ Using city name: ${currentLocation.value}');
        print('Reason: GPS=${_useGPSLocation.value}, Lat=${_latitude.value}, Lng=${_longitude.value}');
        weatherData = await _weatherService.getCurrentWeatherByCity(currentLocation.value);
      }
      
      if (weatherData != null) {
        print('Weather data received: $weatherData'); // Debug log
        final parsedData = _weatherService.parseWeatherData(weatherData);
        
        temperature.value = parsedData['temperature'] ?? 0.0;
        weatherCondition.value = parsedData['condition'] ?? 'Unknown';
        weatherDescription.value = parsedData['description'] ?? 'Unknown';
        humidity.value = parsedData['humidity'] ?? 0;
        windSpeed.value = parsedData['wind_speed'] ?? 0.0;
        
        // Set weather icon and color
        final iconCode = parsedData['icon'] ?? '01d';
        weatherIcon.value = _weatherService.getWeatherIconCode(iconCode);
        
        print('Weather updated: ${weatherCondition.value}, ${temperature.value}°C'); // Debug log
      }
    } catch (e) {
      print('Weather API failed: $e'); // Debug log
      // If API fails, fallback to mock data
      await _fetchMockWeatherData();
    }
  }

  // Fetch weather by GPS coordinates
  Future<void> _fetchWeatherByCoordinates() async {
    try {
      if (_latitude.value != 0.0 && _longitude.value != 0.0) {
        print('Fetching weather by coordinates: ${_latitude.value}, ${_longitude.value}'); // Debug log
        
        final weatherData = await _weatherService.getCurrentWeatherByCoordinates(
          _latitude.value, 
          _longitude.value
        );
        
        if (weatherData != null) {
          print('Weather data received by coordinates: $weatherData'); // Debug log
          final parsedData = _weatherService.parseWeatherData(weatherData);
          
          temperature.value = parsedData['temperature'] ?? 0.0;
          feelsLike.value = parsedData['feels_like'] ?? 0.0;
          weatherCondition.value = parsedData['condition'] ?? 'Unknown';
          weatherDescription.value = parsedData['description'] ?? 'Unknown';
          humidity.value = parsedData['humidity'] ?? 0;
          windSpeed.value = parsedData['wind_speed'] ?? 0.0;
          
          // Update location name from API response
          final apiLocationName = parsedData['city_name'] ?? 'Unknown';
          if (apiLocationName != 'Unknown') {
            currentLocation.value = apiLocationName;
            print('📍 Location updated to: $apiLocationName');
          }
          
          // Set weather icon and color
          final iconCode = parsedData['icon'] ?? '01d';
          weatherIcon.value = _weatherService.getWeatherIconCode(iconCode);
          
          print('Weather updated by GPS: ${weatherCondition.value}, ${temperature.value}°C at $apiLocationName'); // Debug log
        }
      }
    } catch (e) {
      print('Weather API by coordinates failed: $e'); // Debug log
      // Fallback to city name
      _useGPSLocation.value = false;
      await _fetchRealWeatherData();
    }
  }

  // Mock weather data for demonstration
  Future<void> _fetchMockWeatherData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock weather data based on time of day
    final hour = _currentDateTime.hour;
    
    if (hour >= 6 && hour < 12) {
      // Morning
      temperature.value = 28.0;
      weatherCondition.value = 'Cerah';
      weatherDescription.value = 'Cerah Berawan';
      weatherIcon.value = 'wb_sunny';
    } else if (hour >= 12 && hour < 18) {
      // Afternoon
      temperature.value = 32.0;
      weatherCondition.value = 'Panas';
      weatherDescription.value = 'Cerah';
      weatherIcon.value = 'wb_sunny';
    } else if (hour >= 18 && hour < 20) {
      // Evening
      temperature.value = 26.0;
      weatherCondition.value = 'Berawan';
      weatherDescription.value = 'Berawan';
      weatherIcon.value = 'wb_cloudy';
    } else {
      // Night
      temperature.value = 24.0;
      weatherCondition.value = 'Berawan';
      weatherDescription.value = 'Berawan';
      weatherIcon.value = 'wb_cloudy';
    }
    
    humidity.value = 75;
    windSpeed.value = 12.0;
  }


  // Get weather icon based on condition
  IconData getWeatherIcon() {
    switch (weatherIcon.value) {
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'wb_cloudy':
        return Icons.wb_cloudy;
      case 'cloud_queue':
        return Icons.cloud_queue;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'rainy':
        return Icons.grain;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Get weather color based on condition
  Color getWeatherColor() {
    switch (weatherIcon.value) {
      case 'wb_sunny':
        return Colors.orange;
      case 'wb_cloudy':
        return Colors.blue;
      case 'wb_cloudy_queue':
        return Colors.grey;
      case 'thunderstorm':
        return Colors.purple;
      case 'rainy':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  // Update location (can be called from location controller)
  void updateLocation(String location) {
    print('Updating location to: $location'); // Debug log
    currentLocation.value = location;
    _useGPSLocation.value = false; // Disable GPS when manually selecting location
    fetchWeatherData(); // Fetch weather for new location
  }

  // Toggle between GPS and manual location
  void toggleLocationMode() {
    _useGPSLocation.value = !_useGPSLocation.value;
    print('Location mode: ${_useGPSLocation.value ? "GPS" : "Manual"}'); // Debug log
    
    if (_useGPSLocation.value) {
      _updateLocationFromGPS();
    } else {
      fetchWeatherData();
    }
  }

  // Get current location mode
  bool get isUsingGPS => _useGPSLocation.value;

  // Set location controller (for external initialization)
  void setLocationController(GeoTaggingController controller) {
    _locationController = controller;
    _listenToLocationChanges();
    print('✅ Location controller set externally');
  }

  // Set location from popular cities
  void setLocationFromPopularCities(int index) {
    if (index >= 0 && index < popularCities.length) {
      updateLocation(popularCities[index]);
    }
  }

  // Get current location index in popular cities
  int get currentLocationIndex {
    return popularCities.indexOf(currentLocation.value);
  }

  // Force refresh weather data
  void refreshWeather() {
    print('Refreshing weather data...'); // Debug log
    
    // If GPS mode is enabled, try to get fresh GPS coordinates
    if (_useGPSLocation.value && _locationController != null) {
      _updateLocationFromGPS();
    } else {
      fetchWeatherData();
    }
  }

  // Force update GPS coordinates
  Future<void> forceUpdateGPS() async {
    print('=== FORCE GPS UPDATE ===');
    _useGPSLocation.value = true;
    
    // Try to find controller if not available
    if (_locationController == null) {
      print('⏳ GeoTaggingController not available, trying to find...');
      _tryFindLocationController();
      
      // Wait a bit for controller to be found
      await Future.delayed(const Duration(seconds: 1));
    }
    
    await _updateLocationFromGPS();
  }

  // Format temperature
  String getFormattedTemperature() {
    return '${temperature.value.toInt()}°C';
  }

  // Format feels like temperature
  String getFormattedFeelsLike() {
    return '${feelsLike.value.toInt()}°C';
  }

  // Format wind speed
  String getFormattedWindSpeed() {
    return '${windSpeed.value.toInt()} km/h';
  }

  // Format humidity
  String getFormattedHumidity() {
    return '${humidity.value}%';
  }
}
