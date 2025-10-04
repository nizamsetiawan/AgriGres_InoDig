class ProvinceFoodPriceModel {
  final int id;
  final String province;
  final List<ProvinceCommodity> komoditas;

  ProvinceFoodPriceModel({
    required this.id,
    required this.province,
    required this.komoditas,
  });

  factory ProvinceFoodPriceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceFoodPriceModel(
      id: json['id'] as int,
      province: json['province'] as String,
      komoditas: (json['komoditas'] as List<dynamic>)
          .map((e) => ProvinceCommodity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProvinceCommodity {
  final int id;
  final String name;
  final int rataRata;
  final String? hppHapColorGap;
  final TodayProvincePriceProvince todayProvincePrice;
  final List<SettingHargaProvince> settingHarga;

  ProvinceCommodity({
    required this.id,
    required this.name,
    required this.rataRata,
    this.hppHapColorGap,
    required this.todayProvincePrice,
    required this.settingHarga,
  });

  factory ProvinceCommodity.fromJson(Map<String, dynamic> json) {
    return ProvinceCommodity(
      id: json['id'] as int,
      name: json['name'] as String,
      rataRata: json['rata_rata'] as int,
      hppHapColorGap: json['hpp_hap_color_gap'] as String?,
      todayProvincePrice: TodayProvincePriceProvince.fromJson(
          json['today_province_price'] as Map<String, dynamic>),
      settingHarga: (json['setting_harga'] as List<dynamic>)
          .map((e) => SettingHargaProvince.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TodayProvincePriceProvince {
  final String satuan;
  final int hargatertinggi;
  final String provinsitertinggi;
  final String provinsiterendah;
  final int hargaterendah;

  TodayProvincePriceProvince({
    required this.satuan,
    required this.hargatertinggi,
    required this.provinsitertinggi,
    required this.provinsiterendah,
    required this.hargaterendah,
  });

  factory TodayProvincePriceProvince.fromJson(Map<String, dynamic> json) {
    return TodayProvincePriceProvince(
      satuan: json['satuan'] as String,
      hargatertinggi: json['hargatertinggi'] as int,
      provinsitertinggi: json['provinsitertinggi'] as String,
      provinsiterendah: json['provinsiterendah'] as String,
      hargaterendah: json['hargaterendah'] as int,
    );
  }
}

class SettingHargaProvince {
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

  SettingHargaProvince({
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

  factory SettingHargaProvince.fromJson(Map<String, dynamic> json) {
    return SettingHargaProvince(
      id: json['id'] as int,
      komoditasId: json['komoditas_id'] as int,
      type: json['type'] as int,
      provinceId: json['province_id'] as String?,
      hargaProvinsi: json['harga_provinsi'] as String,
      cityId: json['city_id'] as String?,
      hargaKota: json['harga_kota'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      namaZona: json['nama_zona'] as String,
      hargaProvinsiMin: json['harga_provinsi_min'] as String,
      hargaKotaMin: json['harga_kota_min'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      file: json['file'] as String?,
      zonasiId: json['zonasi_id'] as String?,
      typeZonasi: json['type_zonasi'] as int,
      levelHargaId: json['level_harga_id'] as int,
      hargaAwalAman: json['harga_awal_aman'] as String?,
      hargaAkhirAman: json['harga_akhir_aman'] as String?,
      hargaAwalWaspada: json['harga_awal_waspada'] as String?,
      hargaAkhirWaspada: json['harga_akhir_waspada'] as String?,
      hargaAwalIntervensi: json['harga_awal_intervensi'] as String?,
      hargaAkhirIntervensi: json['harga_akhir_intervensi'] as String?,
      typeDescription: json['type_description'] as String,
      hargaRangeProvinsi: json['harga_range_provinsi'] as String,
      hargaRangeKota: json['harga_range_kota'] as String?,
      typeZonasiDescription: json['type_zonasi_description'] as String,
    );
  }
}

class GrandTotalModel {
  final int id;
  final String komoditas;
  final int rataRata;

  GrandTotalModel({
    required this.id,
    required this.komoditas,
    required this.rataRata,
  });

  factory GrandTotalModel.fromJson(Map<String, dynamic> json) {
    return GrandTotalModel(
      id: json['id'] as int,
      komoditas: json['komoditas'] as String,
      rataRata: json['rata_rata'] as int,
    );
  }
}
