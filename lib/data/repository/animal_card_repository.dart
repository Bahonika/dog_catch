import 'package:dog_catch/data/entities/animal_card.dart';
import 'package:dog_catch/data/repository/abstract/basic_repository.dart';

class AnimalCardRepository extends BasicRepository<AnimalCard>{

  @override
  final String apiEndpoint = "animal_card";

  @override
  AnimalCard fromJson(json) {
    return AnimalCard.fromJson(json);
  }
}