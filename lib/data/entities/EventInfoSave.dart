import 'dart:io';

import 'package:dog_catch/data/entities/abstract/PostableMultipart.dart';
class EventInfoSave implements PostableMultipart{

  final String adress;
  final num lat;
  final num long;
  final int claimId;
  final int raidId;
  final File video;

  EventInfoSave({
    required this.adress,
    required this.lat,
    required this.long,
    required this.claimId,
    required this.raidId,
    required this.video
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'adress': adress,
      'lat': lat,
      'long': long,
      'claim': claimId,
      'raid': raidId,
    };
  }

  @override
  Map<String, File> getFiles() {
    return {
      'video': video
    };
  }

}