import 'dart:io';

import 'package:dog_catch/data/entities/abstract/PostableMultipart.dart';

import 'Claim.dart';
import 'Raid.dart';

class EventInfoSave implements PostableMultipart{

  final String adress;
  final num lat;
  final num long;
  final Claim claim;
  final Raid raid;
  final File video;

  EventInfoSave({
    required this.adress,
    required this.lat,
    required this.long,
    required this.claim,
    required this.raid,
    required this.video
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'adress': adress,
      'lat': lat,
      'long': long,
      'claim': claim.claimN,
      'raid': raid.raidN,
    };
  }

  @override
  Map<String, File> getFiles() {
    return {
      'video': video
    };
  }

}