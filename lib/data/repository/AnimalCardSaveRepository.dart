import 'package:dog_catch/data/entities/AnimalCardSave.dart';
import 'package:dog_catch/data/repository/abstract/PostUpdateRepository.dart';

class AnimalCardSaveRepository extends PostUpdateRepository<AnimalCardSave>{

  @override
  final String apiEndpoint = "animal_card";

  @override
  final String idAlias = "id";

  @override
  AnimalCardSave fromJson(json) {
    throw UnimplementedError();
  }

}