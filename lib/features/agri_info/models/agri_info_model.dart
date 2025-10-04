enum AgriInfoIconType {
  foodPrice,
  landUse,
}

class AgriInfoModel {
  final String id;
  final String title;
  final String source;
  final AgriInfoIconType iconType;

  AgriInfoModel({
    required this.id,
    required this.title,
    required this.source,
    required this.iconType,
  });

  static AgriInfoModel empty() => AgriInfoModel(
    id: '',
    title: '',
    source: '',
    iconType: AgriInfoIconType.foodPrice,
  );
}
