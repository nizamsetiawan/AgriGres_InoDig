class MonthlyFoodPriceModel {
  final int komoditasId;
  final String komoditas;
  final String background;
  final int tahun;
  final TodayProvincePrice todayProvincePrice;
  final Map<String, int?> monthlyPrices;

  MonthlyFoodPriceModel({
    required this.komoditasId,
    required this.komoditas,
    required this.background,
    required this.tahun,
    required this.todayProvincePrice,
    required this.monthlyPrices,
  });

  factory MonthlyFoodPriceModel.fromJson(Map<String, dynamic> json) {
    return MonthlyFoodPriceModel(
      komoditasId: json['Komoditas_id'] ?? 0,
      komoditas: json['Komoditas'] ?? '',
      background: json['background'] ?? '',
      tahun: json['Tahun'] ?? 0,
      todayProvincePrice: TodayProvincePrice.fromJson(json['today_province_price'] ?? {}),
      monthlyPrices: _extractMonthlyPrices(json),
    );
  }

  static Map<String, int?> _extractMonthlyPrices(Map<String, dynamic> json) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final Map<String, int?> monthlyPrices = {};
    
    for (String month in months) {
      monthlyPrices[month] = json[month];
    }
    
    return monthlyPrices;
  }
}

class TodayProvincePrice {
  final String satuan;
  final int? hargatertinggi;
  final String? provinsitertinggi;
  final String? provinsiterendah;
  final int? hargaterendah;
  final int? hargaratarata;
  final List<dynamic> zona;
  final List<SettingHarga> settingHarga;

  TodayProvincePrice({
    required this.satuan,
    this.hargatertinggi,
    this.provinsitertinggi,
    this.provinsiterendah,
    this.hargaterendah,
    this.hargaratarata,
    required this.zona,
    required this.settingHarga,
  });

  factory TodayProvincePrice.fromJson(Map<String, dynamic> json) {
    return TodayProvincePrice(
      satuan: json['satuan'] ?? '',
      hargatertinggi: json['hargatertinggi'],
      provinsitertinggi: json['provinsitertinggi'],
      provinsiterendah: json['provinsiterendah'],
      hargaterendah: json['hargaterendah'],
      hargaratarata: json['hargaratarata'],
      zona: json['zona'] ?? [],
      settingHarga: (json['setting_harga'] as List<dynamic>?)
          ?.map((item) => SettingHarga.fromJson(item))
          .toList() ?? [],
    );
  }
}

class SettingHarga {
  final int id;
  final int komoditasId;
  final int type;
  final String? provinceId;
  final String hargaProvinsi;
  final String? cityId;
  final String? hargaKota;
  final String createdAt;
  final String updatedAt;
  final String namaZona;
  final String hargaProvinsiMin;
  final String? hargaKotaMin;
  final String? startDate;
  final String? endDate;
  final String? file;
  final String? zonasiId;
  final int typeZonasi;
  final int levelHargaId;
  final String? hargaAwalAman;
  final String? hargaAkhirAman;
  final String? hargaAwalWaspada;
  final String? hargaAkhirWaspada;
  final String? hargaAwalIntervensi;
  final String? hargaAkhirIntervensi;
  final String typeDescription;
  final String hargaRangeProvinsi;
  final String? hargaRangeKota;
  final String typeZonasiDescription;

  SettingHarga({
    required this.id,
    required this.komoditasId,
    required this.type,
    this.provinceId,
    required this.hargaProvinsi,
    this.cityId,
    this.hargaKota,
    required this.createdAt,
    required this.updatedAt,
    required this.namaZona,
    required this.hargaProvinsiMin,
    this.hargaKotaMin,
    this.startDate,
    this.endDate,
    this.file,
    this.zonasiId,
    required this.typeZonasi,
    required this.levelHargaId,
    this.hargaAwalAman,
    this.hargaAkhirAman,
    this.hargaAwalWaspada,
    this.hargaAkhirWaspada,
    this.hargaAwalIntervensi,
    this.hargaAkhirIntervensi,
    required this.typeDescription,
    required this.hargaRangeProvinsi,
    this.hargaRangeKota,
    required this.typeZonasiDescription,
  });

  factory SettingHarga.fromJson(Map<String, dynamic> json) {
    return SettingHarga(
      id: json['id'] ?? 0,
      komoditasId: json['komoditas_id'] ?? 0,
      type: json['type'] ?? 0,
      provinceId: json['province_id']?.toString(),
      hargaProvinsi: json['harga_provinsi'] ?? '',
      cityId: json['city_id']?.toString(),
      hargaKota: json['harga_kota']?.toString(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      namaZona: json['nama_zona'] ?? '',
      hargaProvinsiMin: json['harga_provinsi_min'] ?? '',
      hargaKotaMin: json['harga_kota_min']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      file: json['file']?.toString(),
      zonasiId: json['zonasi_id']?.toString(),
      typeZonasi: json['type_zonasi'] ?? 0,
      levelHargaId: json['level_harga_id'] ?? 0,
      hargaAwalAman: json['harga_awal_aman']?.toString(),
      hargaAkhirAman: json['harga_akhir_aman']?.toString(),
      hargaAwalWaspada: json['harga_awal_waspada']?.toString(),
      hargaAkhirWaspada: json['harga_akhir_waspada']?.toString(),
      hargaAwalIntervensi: json['harga_awal_intervensi']?.toString(),
      hargaAkhirIntervensi: json['harga_akhir_intervensi']?.toString(),
      typeDescription: json['type_description'] ?? '',
      hargaRangeProvinsi: json['harga_range_provinsi'] ?? '',
      hargaRangeKota: json['harga_range_kota']?.toString(),
      typeZonasiDescription: json['type_zonasi_description'] ?? '',
    );
  }
}

class MonthlyFoodPriceResponse {
  final String status;
  final String message;
  final RequestData requestData;
  final Map<String, List<MonthlyFoodPriceModel>> data;

  MonthlyFoodPriceResponse({
    required this.status,
    required this.message,
    required this.requestData,
    required this.data,
  });

  factory MonthlyFoodPriceResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, List<MonthlyFoodPriceModel>> dataMap = {};
    
    if (json['data'] != null) {
      (json['data'] as Map<String, dynamic>).forEach((year, yearData) {
        dataMap[year] = (yearData as List<dynamic>)
            .map((item) => MonthlyFoodPriceModel.fromJson(item))
            .toList();
      });
    }
    
    return MonthlyFoodPriceResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      requestData: RequestData.fromJson(json['request_data'] ?? {}),
      data: dataMap,
    );
  }
}

class RequestData {
  final String startYear;
  final String endYear;
  final String periodDate;
  final String provinceId;
  final String levelHargaId;
  final String cityId;
  final String startDate;
  final String endDate;
  final String provinceDesc;
  final String cityDesc;
  final String levelHargaDesc;

  RequestData({
    required this.startYear,
    required this.endYear,
    required this.periodDate,
    required this.provinceId,
    required this.levelHargaId,
    required this.cityId,
    required this.startDate,
    required this.endDate,
    required this.provinceDesc,
    required this.cityDesc,
    required this.levelHargaDesc,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
      startYear: json['start_year'] ?? '',
      endYear: json['end_year'] ?? '',
      periodDate: json['period_date'] ?? '',
      provinceId: json['province_id'] ?? '',
      levelHargaId: json['level_harga_id'] ?? '',
      cityId: json['city_id'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      provinceDesc: json['province_desc'] ?? '',
      cityDesc: json['city_desc'] ?? '',
      levelHargaDesc: json['level_harga_desc'] ?? '',
    );
  }
}
