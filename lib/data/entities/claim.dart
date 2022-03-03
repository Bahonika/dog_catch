import '../../utils/utf_8_convert.dart';
import 'date_formats.dart';
import 'status.dart';
import 'abstract/postable.dart';

class Claim implements Postable{

    final int claimN;
    final DateTime date;
    final String description;
    final Status status;

    Claim({
        required this.claimN,
        required this.date,
        required this.description,
        required this.status
    });

    static Status statusFromStr(String str) => str == "O" ? Status.catched : Status.released;
    String strFromStatus() => status == Status.catched ? "O" : "V";

    factory Claim.fromJson(Map<String, dynamic> json) {
        return Claim(claimN: json["claim_n"],
                     date: DateTime.parse(utf8convert(json["claim_date"] as String)),
                     description: utf8convert(json["description"]),
                     status: statusFromStr(utf8convert(json["claim_type"])));
    }

    Map<String, dynamic> toJson(){
        return {
            'claim_date': serverDateFormat.format(date),
            'description': description,
            'claim_type': strFromStatus()
        };
    }

    @override
    String toString() {
        return "№$claimN от "+serverDateFormat.format(date);
    }



}