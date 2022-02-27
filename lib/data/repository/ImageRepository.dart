import 'package:dog_catch/data/entities/AnimalImage.dart';
import 'package:dog_catch/data/repository/abstract/MultipartRepository.dart';

class ImageRepository extends MultipartRepository<AnimalImage>{

  @override
  final String apiEndpoint = "animal_image";

  @override
  String idAlias = "id";

  @override
  AnimalImage fromJson(json) {
    throw UnimplementedError();
  }


}