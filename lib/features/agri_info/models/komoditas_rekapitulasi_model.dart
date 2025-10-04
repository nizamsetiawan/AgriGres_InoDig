class KomoditasRekapitulasiModel {
  final String status;
  final String message;
  final int rataRataProvinsi;
  final List<KomoditasRekapitulasiData> data;

  KomoditasRekapitulasiModel({
    required this.status,
    required this.message,
    required this.rataRataProvinsi,
    required this.data,
  });

  factory KomoditasRekapitulasiModel.fromJson(Map<String, dynamic> json) {
    return KomoditasRekapitulasiModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      rataRataProvinsi: json['rata_rata_provinsi'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => KomoditasRekapitulasiData.fromJson(item))
          .toList() ?? [],
    );
  }
}

class KomoditasRekapitulasiData {
  final String name;
  final List<KomoditasByDate> byDate;

  KomoditasRekapitulasiData({
    required this.name,
    required this.byDate,
  });

  factory KomoditasRekapitulasiData.fromJson(Map<String, dynamic> json) {
    return KomoditasRekapitulasiData(
      name: json['name'] ?? '',
      byDate: (json['by_date'] as List<dynamic>?)
          ?.map((item) => KomoditasByDate.fromJson(item))
          .toList() ?? [],
    );
  }
}

class KomoditasByDate {
  final String date;
  final int rataRata;

  KomoditasByDate({
    required this.date,
    required this.rataRata,
  });

  factory KomoditasByDate.fromJson(Map<String, dynamic> json) {
    return KomoditasByDate(
      date: json['date'] ?? '',
      rataRata: json['rata_rata'] ?? 0,
    );
  }
}
