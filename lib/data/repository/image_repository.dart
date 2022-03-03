import 'package:dog_catch/data/entities/animal_image.dart';
import 'package:dog_catch/data/repository/abstract/multipart_repository.dart';

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