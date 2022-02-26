import 'package:dog_catch/data/entities/AnimalKind.dart';
import 'package:dog_catch/data/entities/EventInfo.dart';
import 'package:dog_catch/data/entities/Municipality.dart';
import 'package:dog_catch/data/entities/abstract/Postable.dart';

import 'AnimalCard.dart';

class AnimalCardSave implements Postable{

  final int pickedProfilePicId;
  final List<int> images;
  final AnimalKind kind;
  final Sex sex;
  final String? chipN;
  final String? badgeN;
  final String info;
  final Municipality municipality;
  final EventInfo catchInfo;
  final EventInfo? releaseInfo;

  String _sexToStrAPI() => sex == Sex.male ? "M" : "F";

  AnimalCardSave({
        required this.pickedProfilePicId,
        required this.images,
        required this.kind,
        required this.sex,
        this.chipN,
        this.badgeN,
        required this.info,
        required this.municipality,
        required this.catchInfo,
        this.releaseInfo
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'kind': kind.id,
      'sex': _sexToStrAPI(),
      'profile_pic': pickedProfilePicId,
      'images': images,
      'municipality': municipality.id,
      'catch_info': catchInfo.id
    };
  }

}