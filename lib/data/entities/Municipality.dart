import 'package:dog_catch/utils/Utf8Convert.dart';

class Municipality {

  final int id;
  final String name;

  Municipality({required this.id, required this.name});

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(id: json["id"], name: utf8convert(json["m_name"]));
  }

}