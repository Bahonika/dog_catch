import 'package:dog_catch/data/entities/Displayable.dart';
import 'package:intl/intl.dart';
import 'package:dog_catch/utils/Utf8Convert.dart';

enum Sex { male, female }

enum Status { catched, released }

class AnimalCard extends Displayable {
  final String profileImagePath;
  final List<String> imagePaths;
  final String kind;
  final Sex sex;
  final String? chipN;
  final String? badgeN;
  final String info;
  final String org;
  final String municipality;
  final Status status;
  final DateTime catchDate;
  final DateTime? releaseDate;
  final int catchInfo;
  final int releaseInfo;

  static Sex _sexFromStr(String str) => str == "M" ? Sex.male : Sex.female;
  String _sexToStrAPI() => sex == Sex.male ? "M" : "F";
  String sexToStr() => sex == Sex.male ? "м" : "ж";

  static Status _statusFromStr(String str) =>
      str == "Отловлено" ? Status.catched : Status.released;
  String statusToStr() => status == Status.catched ? "Отловлено" : "Отпущено";

  String badgeToStr() => badgeN ?? "-";
  String chipToStr() => chipN ?? "-";

  // aliases
  static const String kindAlias = "Вид";
  static const String sexAlias = "Пол";
  static const String badgeAlias = "Номер бирки";
  static const String chipAlias = "Номер чипа";
  static const String infoAlias = "Приметы";
  static const String orgAlias = "Организация";
  static const String municipalityAlias = "Муниципалитет";
  static const String statusAlias = "Статус";
  static const String catchDateAlias = "Дата отлова";
  static const String releaseDateAlias = "Дата выпуска";

  AnimalCard(
      {required this.profileImagePath,
      required this.imagePaths,
      required this.kind,
      required this.sex,
      this.chipN,
      this.badgeN,
      required this.info,
      required this.org,
      required this.municipality,
      required this.status,
      required this.catchDate,
      this.releaseDate,
      required this.catchInfo,
      required this.releaseInfo});

  factory AnimalCard.fromJson(Map<String, dynamic> json) {
    return AnimalCard(
        profileImagePath: utf8convert(json["profile_pic"] as String),
        imagePaths: (json["pictures"] as List<dynamic>).cast<String>(),
        kind: utf8convert(json["kind"] as String),
        sex: _sexFromStr(utf8convert(json["sex"])),
        chipN: json["chipN"] != null ? utf8convert(json["chipN"]) : null,
        badgeN: json["badgeN"] != null ? utf8convert(json["badgeN"]) : null,
        info: utf8convert(json["info"] as String),
        org: utf8convert(json["org"] as String),
        municipality: utf8convert(json["municipality"] as String),
        status: _statusFromStr(utf8convert(json["status"])),
        catchDate: DateTime.parse(json["catch_date"]),
        releaseDate: json["release_date"] != null
            ? DateTime.parse(json["catch_date"])
            : null,
        catchInfo: json["catch_info"] as int,
        releaseInfo: json["release_info"] ?? -1);
  }

  Map<String, String> toJSON() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFields() {
    return {
      AnimalCard.kindAlias: kind,
      AnimalCard.sexAlias: sexToStr(),
      AnimalCard.badgeAlias: badgeToStr(),
      AnimalCard.chipAlias: chipToStr(),
      AnimalCard.infoAlias: info,
      AnimalCard.orgAlias: org,
      AnimalCard.municipalityAlias: municipality,
      AnimalCard.statusAlias: statusToStr(),
      AnimalCard.catchDateAlias: DateFormat("dd.MM.yyyy").format(catchDate),
      AnimalCard.releaseDateAlias:
          releaseDate != null ? DateFormat("dd.MM.yyyy").format(catchDate) : "-"
    };
  }
}
