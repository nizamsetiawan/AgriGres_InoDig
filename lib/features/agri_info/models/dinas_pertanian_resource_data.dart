class DinasPertanianResourceData {
  final List<String> columns;
  final List<Map<String, dynamic>> records;
  final int total;

  const DinasPertanianResourceData({
    required this.columns,
    required this.records,
    required this.total,
  });

  factory DinasPertanianResourceData.empty() => const DinasPertanianResourceData(
        columns: [],
        records: [],
        total: 0,
      );
}

