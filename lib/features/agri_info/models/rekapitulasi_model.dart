class RekapitulasiModel {
  final String status;
  final String message;
  final List<RekapitulasiData> data;

  RekapitulasiModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RekapitulasiModel.fromJson(Map<String, dynamic> json) {
    return RekapitulasiModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => RekapitulasiData.fromJson(item))
          .toList() ?? [],
    );
  }
}

class RekapitulasiData {
  final String name;
  final List<ByDate> byDate;

  RekapitulasiData({
    required this.name,
    required this.byDate,
  });

  factory RekapitulasiData.fromJson(Map<String, dynamic> json) {
    return RekapitulasiData(
      name: json['name'] ?? '',
      byDate: (json['by_date'] as List<dynamic>?)
          ?.map((item) => ByDate.fromJson(item))
          .toList() ?? [],
    );
  }
}

class ByDate {
  final String date;
  final int rataRata;

  ByDate({
    required this.date,
    required this.rataRata,
  });

  factory ByDate.fromJson(Map<String, dynamic> json) {
    return ByDate(
      date: json['date'] ?? '',
      rataRata: json['rata_rata'] ?? 0,
    );
  }
}
