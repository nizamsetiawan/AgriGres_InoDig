class TableFoodPriceModel {
  final int komoditasId;
  final String komoditas;
  final List<TableResult> result;

  TableFoodPriceModel({
    required this.komoditasId,
    required this.komoditas,
    required this.result,
  });

  factory TableFoodPriceModel.fromJson(Map<String, dynamic> json) {
    return TableFoodPriceModel(
      komoditasId: json['komoditas_id'] ?? 0,
      komoditas: json['komoditas'] ?? '',
      result: (json['result'] as List<dynamic>?)
          ?.map((item) => TableResult.fromJson(item))
          .toList() ?? [],
    );
  }
}

class TableResult {
  final String? namaZona;
  final int? typeZonasi;
  final String? typeZonasiDescription;
  final int today;
  final String? hppHap;
  final double? hppHapPercentage;
  final String? hppHapPercentageGapChange;
  final String? hppHapColorGap;
  final double yesterdayPercentage;
  final String yesterdayPercentageGapChange;
  final String yesterdayColorGap;
  final int yesterday;
  final double lastWeekPercentage;
  final String lastWeekPercentageGapChange;
  final String lastWeekColorGap;
  final int lastWeek;
  final double lastMonthPercentage;
  final String lastMonthPercentageGapChange;
  final String lastMonthColorGap;
  final int lastMonth;
  final double lastYearPercentage;
  final String lastYearPercentageGapChange;
  final String lastYearColorGap;
  final int lastYear;
  final TodayProvincePriceTable todayProvincePrice;

  TableResult({
    this.namaZona,
    this.typeZonasi,
    this.typeZonasiDescription,
    required this.today,
    this.hppHap,
    this.hppHapPercentage,
    this.hppHapPercentageGapChange,
    this.hppHapColorGap,
    required this.yesterdayPercentage,
    required this.yesterdayPercentageGapChange,
    required this.yesterdayColorGap,
    required this.yesterday,
    required this.lastWeekPercentage,
    required this.lastWeekPercentageGapChange,
    required this.lastWeekColorGap,
    required this.lastWeek,
    required this.lastMonthPercentage,
    required this.lastMonthPercentageGapChange,
    required this.lastMonthColorGap,
    required this.lastMonth,
    required this.lastYearPercentage,
    required this.lastYearPercentageGapChange,
    required this.lastYearColorGap,
    required this.lastYear,
    required this.todayProvincePrice,
  });

  factory TableResult.fromJson(Map<String, dynamic> json) {
    return TableResult(
      namaZona: json['nama_zona']?.toString(),
      typeZonasi: json['type_zonasi'],
      typeZonasiDescription: json['type_zonasi_description']?.toString(),
      today: json['today'] ?? 0,
      hppHap: json['hpp_hap']?.toString(),
      hppHapPercentage: json['hpp_hap_percentage']?.toDouble(),
      hppHapPercentageGapChange: json['hpp_hap_percentage_gap_change']?.toString(),
      hppHapColorGap: json['hpp_hap_color_gap']?.toString(),
      yesterdayPercentage: (json['yesterday_percentage'] ?? 0).toDouble(),
      yesterdayPercentageGapChange: json['yesterday_percentage_gap_change'] ?? '-',
      yesterdayColorGap: json['yesterday_color_gap'] ?? 'white',
      yesterday: json['yesterday'] ?? 0,
      lastWeekPercentage: (json['last_week_percentage'] ?? 0).toDouble(),
      lastWeekPercentageGapChange: json['last_week_percentage_gap_change'] ?? '-',
      lastWeekColorGap: json['last_week_color_gap'] ?? 'white',
      lastWeek: json['last_week'] ?? 0,
      lastMonthPercentage: (json['last_month_percentage'] ?? 0).toDouble(),
      lastMonthPercentageGapChange: json['last_month_percentage_gap_change'] ?? '-',
      lastMonthColorGap: json['last_month_color_gap'] ?? 'white',
      lastMonth: json['last_month'] ?? 0,
      lastYearPercentage: (json['last_year_percentage'] ?? 0).toDouble(),
      lastYearPercentageGapChange: json['last_year_percentage_gap_change'] ?? '-',
      lastYearColorGap: json['last_year_color_gap'] ?? 'white',
      lastYear: json['last_year'] ?? 0,
      todayProvincePrice: TodayProvincePriceTable.fromJson(json['today_province_price'] ?? {}),
    );
  }
}

class TodayProvincePriceTable {
  final String satuan;
  final int hargatertinggi;
  final String provinsitertinggi;
  final String provinsiterendah;
  final int hargaterendah;

  TodayProvincePriceTable({
    required this.satuan,
    required this.hargatertinggi,
    required this.provinsitertinggi,
    required this.provinsiterendah,
    required this.hargaterendah,
  });

  factory TodayProvincePriceTable.fromJson(Map<String, dynamic> json) {
    return TodayProvincePriceTable(
      satuan: json['satuan'] ?? '',
      hargatertinggi: json['hargatertinggi'] ?? 0,
      provinsitertinggi: json['provinsitertinggi'] ?? '',
      provinsiterendah: json['provinsiterendah'] ?? '',
      hargaterendah: json['hargaterendah'] ?? 0,
    );
  }
}

class TableFoodPriceResponse {
  final String status;
  final String message;
  final RequestDataTable requestData;
  final List<TableFoodPriceModel> data;
  final DetailKeterangan detailKeterangan;

  TableFoodPriceResponse({
    required this.status,
    required this.message,
    required this.requestData,
    required this.data,
    required this.detailKeterangan,
  });

  factory TableFoodPriceResponse.fromJson(Map<String, dynamic> json) {
    return TableFoodPriceResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      requestData: RequestDataTable.fromJson(json['request_data'] ?? {}),
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => TableFoodPriceModel.fromJson(item))
          .toList() ?? [],
      detailKeterangan: DetailKeterangan.fromJson(json['detail_keterangan'] ?? {}),
    );
  }
}

class RequestDataTable {
  final String periodDate;
  final String levelHargaId;
  final String provinceId;
  final String cityId;
  final String startDate;
  final String endDate;
  final String levelHargaDesc;

  RequestDataTable({
    required this.periodDate,
    required this.levelHargaId,
    required this.provinceId,
    required this.cityId,
    required this.startDate,
    required this.endDate,
    required this.levelHargaDesc,
  });

  factory RequestDataTable.fromJson(Map<String, dynamic> json) {
    return RequestDataTable(
      periodDate: json['period_date'] ?? '',
      levelHargaId: json['level_harga_id'] ?? '',
      provinceId: json['province_id'] ?? '',
      cityId: json['city_id'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      levelHargaDesc: json['level_harga_desc'] ?? '',
    );
  }
}

class DetailKeterangan {
  final List<dynamic> waspada;
  final List<dynamic> intervensi;
  final List<String> keterangan;

  DetailKeterangan({
    required this.waspada,
    required this.intervensi,
    required this.keterangan,
  });

  factory DetailKeterangan.fromJson(Map<String, dynamic> json) {
    return DetailKeterangan(
      waspada: json['waspada'] ?? [],
      intervensi: json['intervensi'] ?? [],
      keterangan: (json['keterangan'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
    );
  }
}

