import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/controllers/weather_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class THomeWeatherCard extends StatelessWidget {
  const THomeWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final weatherController = Get.put(WeatherController());
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[50]!,
            Colors.blue[100]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Time
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      weatherController.currentDate.value,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      weatherController.currentTime.value,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Location and Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location Info (Left Side)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            weatherController.isUsingGPS ? Icons.my_location : Icons.location_on,
                            size: 16,
                            color: TColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _showLocationPicker(context, weatherController),
                              child: Obx(() => Row(
                                children: [
                                  if (weatherController.isUsingGPS && weatherController.currentLocation.value.isEmpty)
                                    SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: TColors.primary,
                                      ),
                                    ),
                                  if (weatherController.isUsingGPS && weatherController.currentLocation.value.isEmpty)
                                    const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      weatherController.isUsingGPS 
                                          ? (weatherController.currentLocation.value.isNotEmpty 
                                              ? weatherController.currentLocation.value
                                              : 'Mencari lokasi...')
                                          : weatherController.currentLocation.value,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: TColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Action Buttons (Right Side - Pojok Kanan)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // GPS Toggle Button
                        Tooltip(
                          message: weatherController.isUsingGPS 
                              ? 'GPS Mode - Klik untuk Manual' 
                              : 'Manual Mode - Klik untuk GPS',
                          child: GestureDetector(
                            onTap: () => weatherController.toggleLocationMode(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: weatherController.isUsingGPS 
                                    ? TColors.primary.withOpacity(0.15)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: weatherController.isUsingGPS 
                                      ? TColors.primary.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    weatherController.isUsingGPS ? Icons.my_location : Icons.location_city,
                                    size: 12,
                                    color: weatherController.isUsingGPS ? TColors.primary : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    weatherController.isUsingGPS ? 'GPS' : 'Manual',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: weatherController.isUsingGPS ? TColors.primary : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        
                        // Refresh Button
                        Tooltip(
                          message: 'Refresh Data Cuaca',
                          child: GestureDetector(
                            onTap: () => weatherController.refreshWeather(),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: TColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: TColors.primary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.refresh,
                                size: 14,
                                color: TColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        
                        // Detail Button
                        Tooltip(
                          message: 'Lihat Detail Cuaca',
                          child: GestureDetector(
                            onTap: () => _showWeatherDetail(context, weatherController),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                size: 14,
                                color: Colors.blue[600],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Weather Condition
                Text(
                  weatherController.weatherDescription.value.isNotEmpty 
                      ? weatherController.weatherDescription.value
                      : weatherController.weatherCondition.value,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Temperature
                Row(
                  children: [
                    Text(
                      weatherController.getFormattedTemperature(),
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        weatherController.weatherCondition.value,
                        style: textTheme.bodySmall?.copyWith(
                          color: TColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Feels like temperature
                Text(
                  weatherController.getFormattedFeelsLike(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Additional weather info
                Row(
                  children: [
                    _buildWeatherInfo(
                      Icons.water_drop,
                      '${weatherController.humidity.value}%',
                      'Kelembaban',
                    ),
                    const SizedBox(width: 16),
                    _buildWeatherInfo(
                      Icons.air,
                      weatherController.getFormattedWindSpeed(),
                      'Angin',
                    ),
                    const SizedBox(width: 16),
                    _buildWeatherInfo(
                      Icons.thermostat,
                      '${weatherController.temperature.value.toInt()}°C',
                      'Suhu',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Weather Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              weatherController.getWeatherIcon(),
              color: weatherController.getWeatherColor(),
              size: 48,
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildWeatherInfo(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLocationPicker(BuildContext context, WeatherController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Lokasi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // GPS Toggle
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controller.isUsingGPS 
                    ? TColors.primary.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: controller.isUsingGPS 
                      ? TColors.primary
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    controller.isUsingGPS ? Icons.gps_fixed : Icons.gps_off,
                    color: controller.isUsingGPS ? TColors.primary : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isUsingGPS ? 'Lokasi GPS Aktif' : 'Gunakan GPS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: controller.isUsingGPS ? TColors.primary : Colors.grey[700],
                          ),
                        ),
                        Text(
                          controller.isUsingGPS 
                              ? 'Menggunakan lokasi GPS real-time'
                              : 'Aktifkan untuk menggunakan lokasi GPS',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: controller.isUsingGPS,
                    onChanged: (value) {
                      controller.toggleLocationMode();
                    },
                    activeColor: TColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            if (!controller.isUsingGPS) ...[
              Text(
                'Kota Populer di Indonesia',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.popularCities.length,
                itemBuilder: (context, index) {
                  final city = controller.popularCities[index];
                  final isSelected = controller.currentLocation.value == city;
                  
                  return ListTile(
                    leading: Icon(
                      isSelected ? Icons.location_on : Icons.location_city,
                      color: isSelected ? TColors.primary : Colors.grey[600],
                    ),
                    title: Text(
                      city,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? TColors.primary : Colors.black87,
                      ),
                    ),
                    trailing: isSelected 
                        ? Icon(Icons.check, color: TColors.primary)
                        : null,
                    onTap: () {
                      controller.setLocationFromPopularCities(index);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[700],
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeatherDetail(BuildContext context, WeatherController controller) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.blue[50]!,
                Colors.blue[100]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      controller.getWeatherIcon(),
                      color: controller.getWeatherColor(),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.currentLocation.value,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.weatherDescription.value.isNotEmpty 
                              ? controller.weatherDescription.value
                              : controller.weatherCondition.value,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Temperature Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDetailItem(
                          'Suhu',
                          controller.getFormattedTemperature(),
                          Icons.thermostat,
                          TColors.primary,
                        ),
                        _buildDetailItem(
                          'Terasa',
                          controller.getFormattedFeelsLike(),
                          Icons.whatshot,
                          Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDetailItem(
                          'Kelembaban',
                          '${controller.humidity.value}%',
                          Icons.water_drop,
                          Colors.blue,
                        ),
                        _buildDetailItem(
                          'Angin',
                          controller.getFormattedWindSpeed(),
                          Icons.air,
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Additional Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildInfoChip(
                      Icons.location_on,
                      'GPS Aktif',
                      controller.isUsingGPS ? Colors.green : Colors.grey,
                    ),
                    _buildInfoChip(
                      Icons.access_time,
                      controller.currentTime.value,
                      Colors.blue,
                    ),
                    _buildInfoChip(
                      Icons.calendar_today,
                      controller.currentDate.value,
                      Colors.purple,
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 20),
              //
              // // Close Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () => Navigator.pop(context),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.white,
              //       foregroundColor: TColors.primary,
              //       side: BorderSide(color: TColors.primary),
              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     child: const Text(
              //       'Tutup',
              //       style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
} 