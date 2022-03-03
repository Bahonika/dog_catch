import 'package:dog_catch/data/entities/animal_card_save.dart';
import 'package:dog_catch/data/repository/abstract/post_update_repository.dart';

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