import '../../utils/Utf8Convert.dart';
import 'package:dog_catch/data/entities/DateFormats.dart';
import 'abstract/Postable.dart';

class Raid implements Postable{

  final int raidN;
  final DateTime date;

  Raid({
    required this.raidN,
    required this.date,
  });
  

  factory Raid.fromJson(Map<String, dynamic> json) {
    return Raid(raidN: json["raid_n"],
        date: DateTime.parse(utf8convert(json["raid_date"] as String)));
  }

  Map<String, dynamic> toJson(){
    return {
      'raid_date': serverDateFormat.format(date)
    };
  }

  @override
  String toString() {
    return "№$raidN от "+serverDateFormat.format(date);
  }

}