import 'package:dog_catch/utils/utf_8_convert.dart';

class Municipality {

  final int id;
  final String name;

  Municipality({required this.id, required this.name});

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(id: json["id"], name: utf8convert(json["m_name"]));
  }

}