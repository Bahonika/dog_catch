import 'package:dog_catch/data/entities/abstract/Displayable.dart';
import 'package:dog_catch/utils/Utf8Convert.dart';

class EventInfo implements Displayable{

  final int id;
  final String adress;
  final num lat;
  final num long;
  // final int claim;
  final String claimSummary;
  final String raidSummary;
  final String staffWorker;

  // TODO: правильный формат
  String coordToStr() => "$lat $long";

  EventInfo({
    required this.id,
    required this.adress,
    required this.lat,
    required this.long,
    required this.claimSummary,
    required this.raidSummary,
    required this.staffWorker,
  });

  static const adressAlias = "Адрес";
  static const coordsAlias = "Координаты";
  static const claimSummaryAlias = "Заявка";
  static const raidSummaryAlias = "Рейд";
  static const staffWorkerAlias = "Исполнитель";


  factory EventInfo.fromJson(Map<String, dynamic> json){
    return EventInfo(id: json["id"] as int,
        adress: utf8convert(json["adress"] as String),
        lat: json["lat"] as num,
        long: json["long"] as num,
        claimSummary: utf8convert(json["claim_summary"] as String),
        raidSummary: json["raid_summary"] != null ? utf8convert(json["raid_summary"]) : "-",
        staffWorker: utf8convert(json["staff_worker"] as String)
    );
  }

  @override
  Map<String, String> getFields() {
    return {
      EventInfo.adressAlias: adress,
      EventInfo.coordsAlias: coordToStr(),
      EventInfo.claimSummaryAlias: claimSummary,
      EventInfo.raidSummaryAlias: raidSummary,
      EventInfo.staffWorkerAlias: staffWorker
    };
  }

}