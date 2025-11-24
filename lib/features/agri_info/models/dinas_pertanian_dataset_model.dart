class DinasPertanianDatasetModel {
  final String datasetId;
  final String title;
  final String identity;
  final List<DinasPertanianResourceModel> resources;

  const DinasPertanianDatasetModel({
    required this.datasetId,
    required this.title,
    required this.identity,
    required this.resources,
  });

  factory DinasPertanianDatasetModel.fromJson(Map<String, dynamic> json) {
    final resourcesJson = json['resource_dataset'] as List<dynamic>? ?? [];
    return DinasPertanianDatasetModel(
      datasetId: json['dataset_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      identity: json['identity']?.toString() ?? '',
      resources: resourcesJson
          .map((item) => DinasPertanianResourceModel.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList(),
    );
  }
}

class DinasPertanianResourceModel {
  final String resourceId;
  final String title;
  final List<DinasPertanianFieldPreview> fieldsPreview;

  const DinasPertanianResourceModel({
    required this.resourceId,
    required this.title,
    required this.fieldsPreview,
  });

  factory DinasPertanianResourceModel.fromJson(Map<String, dynamic> json) {
    final dataResources = json['data_resource'] as List<dynamic>? ?? [];
    return DinasPertanianResourceModel(
      resourceId: json['resource_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      fieldsPreview: dataResources
          .map((item) => DinasPertanianFieldPreview.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList(),
    );
  }
}

class DinasPertanianFieldPreview {
  final String column;
  final String alias;
  final String dataType;

  const DinasPertanianFieldPreview({
    required this.column,
    required this.alias,
    required this.dataType,
  });

  factory DinasPertanianFieldPreview.fromJson(Map<String, dynamic> json) {
    return DinasPertanianFieldPreview(
      column: json['kolom']?.toString() ?? '',
      alias: json['alias']?.toString() ?? '',
      dataType: json['tipe_data']?.toString() ?? '',
    );
  }
}

