import 'package:image_picker/image_picker.dart';

class AnimalImage{
  final XFile img;

  AnimalImage(this.img);

  Map<String, dynamic> toJson(){
    return {
      'img': img.readAsBytes()
    };
  }
}