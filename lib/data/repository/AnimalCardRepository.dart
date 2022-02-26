import 'package:dog_catch/data/entities/AnimalCard.dart';
import 'package:dog_catch/data/repository/abstract/BasicRepository.dart';

class AnimalCardRepository extends BasicRepository<AnimalCard>{

  @override
  final String apiEndpoint = "animal_card";

  @override
  AnimalCard fromJson(json) {
    return AnimalCard.fromJson(json);
  }
}