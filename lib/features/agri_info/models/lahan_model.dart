class LahanModel {
  final int kode;
  final bool success;
  final LahanResult result;

  LahanModel({
    required this.kode,
    required this.success,
    required this.result,
  });

  factory LahanModel.fromJson(Map<String, dynamic> json) {
    return LahanModel(
      kode: json['kode'] ?? 0,
      success: json['success'] ?? false,
      result: LahanResult.fromJson(json['result'] ?? {}),
    );
  }
}

class LahanResult {
  final String resourceId;
  final bool includeTotal;
  final List<LahanField> fields;
  final String recordsFormat;
  final List<LahanRecord> records;
  final int limit;
  final LahanLinks links;
  final int total;

  LahanResult({
    required this.resourceId,
    required this.includeTotal,
    required this.fields,
    required this.recordsFormat,
    required this.records,
    required this.limit,
    required this.links,
    required this.total,
  });

  factory LahanResult.fromJson(Map<String, dynamic> json) {
    return LahanResult(
      resourceId: json['resource_id'] ?? '',
      includeTotal: json['include_total'] ?? false,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((item) => LahanField.fromJson(item))
          .toList() ?? [],
      recordsFormat: json['records_format'] ?? '',
      records: (json['records'] as List<dynamic>?)
          ?.map((item) => LahanRecord.fromJson(item))
          .toList() ?? [],
      limit: json['limit'] ?? 0,
      links: LahanLinks.fromJson(json['_links'] ?? {}),
      total: json['total'] ?? 0,
    );
  }
}

class LahanField {
  final LahanFieldInfo info;
  final String type;
  final String id;

  LahanField({
    required this.info,
    required this.type,
    required this.id,
  });

  factory LahanField.fromJson(Map<String, dynamic> json) {
    return LahanField(
      info: LahanFieldInfo.fromJson(json['info'] ?? {}),
      type: json['type'] ?? '',
      id: json['id'] ?? '',
    );
  }
}

class LahanFieldInfo {
  final String notes;
  final String typeOverride;
  final String label;

  LahanFieldInfo({
    required this.notes,
    required this.typeOverride,
    required this.label,
  });

  factory LahanFieldInfo.fromJson(Map<String, dynamic> json) {
    return LahanFieldInfo(
      notes: json['notes'] ?? '',
      typeOverride: json['type_override'] ?? '',
      label: json['label'] ?? '',
    );
  }
}

class LahanRecord {
  final String kodeWilayah;
  final String kecamatan;
  final String desaKelurahan;
  final String tegalKebun;
  final String ladangHuma;
  final String perkebunan;
  final String ditanamiPohonHutanRakyat;
  final String padangRumputPenggembalaan;
  final String hutanNegara;
  final String sementaraTidakDiusahakan;
  final String lainnya;

  LahanRecord({
    required this.kodeWilayah,
    required this.kecamatan,
    required this.desaKelurahan,
    required this.tegalKebun,
    required this.ladangHuma,
    required this.perkebunan,
    required this.ditanamiPohonHutanRakyat,
    required this.padangRumputPenggembalaan,
    required this.hutanNegara,
    required this.sementaraTidakDiusahakan,
    required this.lainnya,
  });

  factory LahanRecord.fromJson(Map<String, dynamic> json) {
    return LahanRecord(
      kodeWilayah: json['kode_wilayah'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      desaKelurahan: json['desakelurahan'] ?? '',
      tegalKebun: json['tegalkebun'] ?? '0,00',
      ladangHuma: json['ladanghuma'] ?? '0,00',
      perkebunan: json['perkebunan'] ?? '0,00',
      ditanamiPohonHutanRakyat: json['ditanami_pohonhutan_rakyat'] ?? '0,00',
      padangRumputPenggembalaan: json['padang_rumputpenggembalaan'] ?? '0,00',
      hutanNegara: json['hutan_negara'] ?? '0,00',
      sementaraTidakDiusahakan: json['sementara_tidak_diusahakan'] ?? '0,00',
      lainnya: json['lainnya'] ?? '0,00',
    );
  }

  // Helper method to get total area
  double get totalArea {
    return _parseDouble(tegalKebun) +
        _parseDouble(ladangHuma) +
        _parseDouble(perkebunan) +
        _parseDouble(ditanamiPohonHutanRakyat) +
        _parseDouble(padangRumputPenggembalaan) +
        _parseDouble(hutanNegara) +
        _parseDouble(sementaraTidakDiusahakan) +
        _parseDouble(lainnya);
  }

  double _parseDouble(String value) {
    try {
      return double.parse(value.replaceAll(',', '.'));
    } catch (e) {
      return 0.0;
    }
  }
}

class LahanLinks {
  final String start;

  LahanLinks({
    required this.start,
  });

  factory LahanLinks.fromJson(Map<String, dynamic> json) {
    return LahanLinks(
      start: json['start'] ?? '',
    );
  }
}

