import 'package:dog_catch/data/entities/abstract/Postable.dart';

import 'AnimalCard.dart';

class AnimalCardSave implements Postable{

  final int pickedProfilePicId;
  final List<int> images;
  final int kindId;
  final Sex sex;
  final String? chipN;
  final String? badgeN;
  final String info;
  final int municipalityId;
  final int catchInfoId;
  final int? releaseInfoId;

  String _sexToStrAPI() => sex == Sex.male ? "M" : "F";

  AnimalCardSave({
        required this.pickedProfilePicId,
        required this.images,
        required this.kindId,
        required this.sex,
        this.chipN,
        this.badgeN,
        required this.info,
        required this.municipalityId,
        required this.catchInfoId,
        this.releaseInfoId
  });

  @override
  Map<String, dynamic> toJson() {
    var fields = {
      'kind': kindId,
      'sex': _sexToStrAPI(),
      'profile_pic': pickedProfilePicId,
      'images': images,
      'municipality': municipalityId,
      'catch_info': catchInfoId
    };
    if(releaseInfoId != null){
      fields['release_info'] = releaseInfoId!;
    }
    if(chipN != null){
      fields['chip_n'] = chipN!;
    }
    if(badgeN != null){
      fields['badge_n'] = badgeN!;
    }
    return fields;
  }

}