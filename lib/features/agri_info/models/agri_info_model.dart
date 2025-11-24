enum AgriInfoIconType {
  foodPrice,
  landUse,
  plantation,
}

class AgriInfoModel {
  final String id;
  final String title;
  final String source;
  final AgriInfoIconType iconType;
  final int resourceCount;
  final String identity;

  AgriInfoModel({
    required this.id,
    required this.title,
    required this.source,
    required this.iconType,
    this.resourceCount = 0,
    this.identity = '',
  });

  static AgriInfoModel empty() => AgriInfoModel(
        id: '',
        title: '',
        source: '',
        iconType: AgriInfoIconType.foodPrice,
      );
}
