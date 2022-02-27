import 'dart:io';

import 'package:dog_catch/data/entities/abstract/PostableMultipart.dart';
class EventInfoSave implements PostableMultipart{

  final String adress;
  final num lat;
  final num long;
  final int claimId;
  final int? raidId;
  final File video;

  EventInfoSave({
    required this.adress,
    required this.lat,
    required this.long,
    required this.claimId,
    this.raidId,
    required this.video
  });

  @override
  Map<String, dynamic> toJson() {
    var tempMap = {
      'adress': adress,
      'lat': lat,
      'long': long,
      'claim': claimId,
    };

    if (raidId != null) {
      tempMap["raid"] = raidId!;
    }
    return tempMap;

  }

  @override
  Map<String, File> getFiles() {
    return {
      'video': video
    };
  }

}