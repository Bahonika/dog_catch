
import 'package:dog_catch/utils/Utf8Convert.dart';

class AnimalKind {

  final int id;
  final String kind;

  AnimalKind({required this.id, required this.kind});

  factory AnimalKind.fromJson(Map<String, dynamic> json) {
    return AnimalKind(id: json["id"], kind: utf8convert(json["kind"]));
  }

}