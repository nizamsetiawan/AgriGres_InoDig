class FoodPriceModel {
  final int id;
  final String name;
  final String satuan;
  final int today;
  final int yesterday;
  final String yesterdayDate;
  final int gap;
  final double gapPercentage;
  final String gapChange;
  final String gapColor;
  final String background;

  FoodPriceModel({
    required this.id,
    required this.name,
    required this.satuan,
    required this.today,
    required this.yesterday,
    required this.yesterdayDate,
    required this.gap,
    required this.gapPercentage,
    required this.gapChange,
    required this.gapColor,
    required this.background,
  });

  factory FoodPriceModel.fromJson(Map<String, dynamic> json) {
    return FoodPriceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      satuan: json['satuan'] ?? '',
      today: json['today'] ?? 0,
      yesterday: json['yesterday'] ?? 0,
      yesterdayDate: json['yesterday_date'] ?? '',
      gap: json['gap'] ?? 0,
      gapPercentage: (json['gap_percentage'] ?? 0.0).toDouble(),
      gapChange: json['gap_change'] ?? '',
      gapColor: json['gap_color'] ?? '',
      background: json['background'] ?? '',
    );
  }
}

class FoodPriceResponse {
  final String status;
  final String message;
  final List<FoodPriceModel> data;
  final List<Map<String, dynamic>> requestData;

  FoodPriceResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.requestData,
  });

  factory FoodPriceResponse.fromJson(Map<String, dynamic> json) {
    return FoodPriceResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => FoodPriceModel.fromJson(item))
          .toList() ?? [],
      requestData: (json['request_data'] as List<dynamic>?)
          ?.map((item) => Map<String, dynamic>.from(item))
          .toList() ?? [],
    );
  }
}
