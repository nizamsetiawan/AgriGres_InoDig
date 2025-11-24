import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:agrigres/features/agri_info/models/dinas_pertanian_dataset_model.dart';
import 'package:agrigres/features/agri_info/models/dinas_pertanian_resource_data.dart';
import 'package:agrigres/utils/constraints/api_constants.dart';
import 'package:agrigres/utils/logging/logger.dart';

class DinasPertanianRepository extends GetxController {
  final http.Client _client = http.Client();

  Future<List<DinasPertanianDatasetModel>> fetchDatasets() async {
    final uri = Uri.parse(
      '${APIConstants.satuDataBaseUrl}/organisasi_datastore'
      '?organisasi_id=${APIConstants.satuDataDinasPertanianOrgId}',
    );

    final response = await _client.get(uri, headers: _buildHeaders());
    if (response.statusCode != 200) {
      TLoggerHelper.error(
        'Failed to fetch Dinas Pertanian datasets',
        'Status: ${response.statusCode}',
      );
      throw Exception('Gagal memuat data dari Satu Data Gresik');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (body['success'] != true) {
      TLoggerHelper.error(
        'Dinas Pertanian datasets response invalid',
        body.toString(),
      );
      throw Exception('Respons data tidak valid');
    }

    final result = body['result'] as Map<String, dynamic>? ?? {};
    final datasetsJson = result['dataset'] as List<dynamic>? ?? [];

    return datasetsJson
        .map(
          (item) => DinasPertanianDatasetModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .where((dataset) => dataset.resources.isNotEmpty)
        .toList();
  }

  Future<DinasPertanianResourceData> fetchResourceData(
    String resourceId, {
    int limit = 100,
    int offset = 0,
  }) async {
    final uri = Uri.parse(
      '${APIConstants.satuDataBaseUrl}/datastore_search'
      '?resource_id=$resourceId&limit=$limit&offset=$offset',
    );

    final response = await _client.get(uri, headers: _buildHeaders());
    if (response.statusCode != 200) {
      TLoggerHelper.error(
        'Failed to fetch resource data',
        'Status: ${response.statusCode}',
      );
      throw Exception('Gagal memuat data resource');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (body['success'] != true) {
      TLoggerHelper.error('Resource data response invalid', body.toString());
      throw Exception('Respons data resource tidak valid');
    }

    final result = body['result'] as Map<String, dynamic>? ?? {};
    final fields = result['fields'] as List<dynamic>? ?? [];
    final records = result['records'] as List<dynamic>? ?? [];

    final columns = fields
        .map((field) => field['id']?.toString() ?? '')
        .where((col) => col.isNotEmpty)
        .toList();

    final dataRecords = records
        .map((record) => Map<String, dynamic>.from(record as Map))
        .toList();

    return DinasPertanianResourceData(
      columns: columns,
      records: dataRecords,
      total: result['total'] is int ? result['total'] as int : dataRecords.length,
    );
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    // Optional cookie for specific datasets if provided
    if (APIConstants.satuDataCookieSawah.isNotEmpty) {
      headers['Cookie'] = APIConstants.satuDataCookieSawah;
    }
    return headers;
  }
}

