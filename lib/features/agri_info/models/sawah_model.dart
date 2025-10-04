class SawahModel {
  final int kode;
  final bool success;
  final SawahResult result;

  SawahModel({
    required this.kode,
    required this.success,
    required this.result,
  });

  factory SawahModel.fromJson(Map<String, dynamic> json) {
    return SawahModel(
      kode: json['kode'] ?? 0,
      success: json['success'] ?? false,
      result: SawahResult.fromJson(json['result'] ?? {}),
    );
  }
}

class SawahResult {
  final String resourceId;
  final bool includeTotal;
  final List<SawahField> fields;
  final String recordsFormat;
  final List<SawahRecord> records;
  final int limit;
  final SawahLinks links;
  final int total;

  SawahResult({
    required this.resourceId,
    required this.includeTotal,
    required this.fields,
    required this.recordsFormat,
    required this.records,
    required this.limit,
    required this.links,
    required this.total,
  });

  factory SawahResult.fromJson(Map<String, dynamic> json) {
    return SawahResult(
      resourceId: json['resource_id'] ?? '',
      includeTotal: json['include_total'] ?? false,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((item) => SawahField.fromJson(item))
          .toList() ?? [],
      recordsFormat: json['records_format'] ?? '',
      records: (json['records'] as List<dynamic>?)
          ?.map((item) => SawahRecord.fromJson(item))
          .toList() ?? [],
      limit: json['limit'] ?? 0,
      links: SawahLinks.fromJson(json['_links'] ?? {}),
      total: json['total'] ?? 0,
    );
  }
}

class SawahField {
  final SawahFieldInfo info;
  final String type;
  final String id;

  SawahField({
    required this.info,
    required this.type,
    required this.id,
  });

  factory SawahField.fromJson(Map<String, dynamic> json) {
    return SawahField(
      info: SawahFieldInfo.fromJson(json['info'] ?? {}),
      type: json['type'] ?? '',
      id: json['id'] ?? '',
    );
  }
}

class SawahFieldInfo {
  final String notes;
  final String typeOverride;
  final String label;

  SawahFieldInfo({
    required this.notes,
    required this.typeOverride,
    required this.label,
  });

  factory SawahFieldInfo.fromJson(Map<String, dynamic> json) {
    return SawahFieldInfo(
      notes: json['notes'] ?? '',
      typeOverride: json['type_override'] ?? '',
      label: json['label'] ?? '',
    );
  }
}

class SawahRecord {
  final String kodeWilayah;
  final String kecamatan;
  final String desaKelurahan;
  final String sawahTadahHujan;
  final String sawahIrigasi;
  final String sawahRawaPasangSurutTidal;
  final String sawahRawaLebak;

  SawahRecord({
    required this.kodeWilayah,
    required this.kecamatan,
    required this.desaKelurahan,
    required this.sawahTadahHujan,
    required this.sawahIrigasi,
    required this.sawahRawaPasangSurutTidal,
    required this.sawahRawaLebak,
  });

  factory SawahRecord.fromJson(Map<String, dynamic> json) {
    return SawahRecord(
      kodeWilayah: json['kode_wilayah'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      desaKelurahan: json['desakelurahan'] ?? '',
      sawahTadahHujan: json['sawah_tadah_hujan'] ?? '0,00',
      sawahIrigasi: json['sawah_irigasi'] ?? '0,00',
      sawahRawaPasangSurutTidal: json['sawah_rawa_pasang_surut_tidal'] ?? '0,00',
      sawahRawaLebak: json['sawah_rawa_lebak'] ?? '0,00',
    );
  }

  // Helper method to get total area
  double get totalArea {
    return _parseDouble(sawahTadahHujan) +
        _parseDouble(sawahIrigasi) +
        _parseDouble(sawahRawaPasangSurutTidal) +
        _parseDouble(sawahRawaLebak);
  }

  double _parseDouble(String value) {
    try {
      return double.parse(value.replaceAll(',', '.'));
    } catch (e) {
      return 0.0;
    }
  }
}

class SawahLinks {
  final String start;

  SawahLinks({
    required this.start,
  });

  factory SawahLinks.fromJson(Map<String, dynamic> json) {
    return SawahLinks(
      start: json['start'] ?? '',
    );
  }
}
