import 'package:dog_catch/utils/utf_8_convert.dart';

import 'statistics_info.dart';

class StatisticsFrame {

  final StatisticsInfo total;
  final Map<String, StatisticsInfo> byKind;
  final Map<String, StatisticsInfo>? byMunicipality;

  StatisticsFrame({
    required this.total,
    required this.byKind,
    this.byMunicipality
  });

  static toMap(Map<String, dynamic> json){
    return json.map((key, value) => MapEntry(utf8convert(key), StatisticsInfo.fromJson(value)));
  }

  factory StatisticsFrame.fromJson(Map<String, dynamic> json){
    return StatisticsFrame(
        total: StatisticsInfo.fromJson(json["total"]),
        byKind: toMap(json["by_kind"]),
        byMunicipality: json.containsKey("by_municipality") ?
                        toMap(json["by_municipality"]) : null,
    );
  }


}