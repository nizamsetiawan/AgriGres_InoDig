import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // Get API key from environment or use hardcoded key
  String get apiKey {
    final envApiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (envApiKey?.isNotEmpty == true) {
      return envApiKey!;
    }
    // Fallback to hardcoded key if env not set
    return 'b8d0c21b738d80868ff12799740ec161';
  }

  // Check if API key is configured
  bool get isApiKeyConfigured {
    return apiKey.isNotEmpty;
  }

  // Get current weather by city name
  Future<Map<String, dynamic>?> getCurrentWeatherByCity(String cityName) async {
    if (!isApiKeyConfigured) {
      throw Exception('OpenWeatherMap API key not configured');
    }

    try {
      final url = '$_baseUrl/weather?q=$cityName&appid=$apiKey&units=metric&lang=id';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Get current weather by coordinates
  Future<Map<String, dynamic>?> getCurrentWeatherByCoordinates(
    double latitude, 
    double longitude
  ) async {
    if (!isApiKeyConfigured) {
      throw Exception('OpenWeatherMap API key not configured');
    }

    try {
      final url = '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=id';
      print('Weather API URL: $url'); // Debug log
      final response = await http.get(Uri.parse(url));

      print('Weather API Response Status: ${response.statusCode}'); // Debug log
      print('Weather API Response Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Weather API Error: $e'); // Debug log
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Get weather forecast (5 days)
  Future<Map<String, dynamic>?> getWeatherForecast(String cityName) async {
    if (!isApiKeyConfigured) {
      throw Exception('OpenWeatherMap API key not configured');
    }

    try {
      final url = '$_baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric&lang=id';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }

  // Parse weather data to our format
  Map<String, dynamic> parseWeatherData(Map<String, dynamic> data) {
    final main = data['main'] as Map<String, dynamic>;
    final weather = (data['weather'] as List).first as Map<String, dynamic>;
    final wind = data['wind'] as Map<String, dynamic>;
    final sys = data['sys'] as Map<String, dynamic>;

    return {
      'temperature': main['temp']?.toDouble() ?? 0.0,
      'feels_like': main['feels_like']?.toDouble() ?? 0.0,
      'humidity': main['humidity']?.toInt() ?? 0,
      'pressure': main['pressure']?.toInt() ?? 0,
      'condition': weather['main'] ?? 'Unknown',
      'description': weather['description'] ?? 'Unknown',
      'icon': weather['icon'] ?? '01d',
      'wind_speed': wind['speed']?.toDouble() ?? 0.0,
      'wind_direction': wind['deg']?.toInt() ?? 0,
      'city_name': data['name'] ?? 'Unkown',
      'country': sys['country'] ?? 'Unknown',
      'sunrise': sys['sunrise']?.toInt() ?? 0,
      'sunset': sys['sunset']?.toInt() ?? 0,
    };
  }

  // Get weather icon from OpenWeatherMap icon code
  String getWeatherIconCode(String iconCode) {
    switch (iconCode) {
      case '01d':
      case '01n':
        return 'wb_sunny';
      case '02d':
      case '02n':
      case '03d':
      case '03n':
        return 'wb_cloudy';
      case '04d':
      case '04n':
        return 'cloud_queue';
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return 'rainy';
      case '11d':
      case '11n':
        return 'thunderstorm';
      case '13d':
      case '13n':
        return 'ac_unit';
      case '50d':
      case '50n':
        return 'foggy';
      default:
        return 'wb_cloudy';
    }
  }

  // Get weather color based on condition
  String getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'orange';
      case 'clouds':
        return 'blue';
      case 'rain':
        return 'blue';
      case 'thunderstorm':
        return 'purple';
      case 'snow':
        return 'white';
      case 'mist':
      case 'fog':
        return 'grey';
      default:
        return 'orange';
    }
  }
}
