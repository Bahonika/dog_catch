import 'dart:io';
import 'package:dog_catch/data/entities/abstract/postable_multipart.dart';


class AnimalImage implements PostableMultipart{
  final File img;

  AnimalImage(this.img);

  @override
  Map<String, File> getFiles() {
    return {
      'img': img
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}