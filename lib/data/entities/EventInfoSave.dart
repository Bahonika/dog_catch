import 'package:image_picker/image_picker.dart';

import 'Claim.dart';
import 'Raid.dart';
import 'abstract/Postable.dart';

class EventInfoSave implements Postable{

  final String adress;
  final num lat;
  final num long;
  final Claim claim;
  final Raid raid;
  final XFile video;

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
      'video': video.readAsBytes()
    };
  }

}