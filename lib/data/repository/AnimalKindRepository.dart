import 'package:dog_catch/data/entities/AnimalKind.dart';
import 'package:dog_catch/data/repository/abstract/BasicRepository.dart';

class AnimalKindRepository extends BasicRepository<AnimalKind>{

  @override
  final String apiEndpoint = "animal_kind";

  @override
  AnimalKind fromJson(json) {
    return AnimalKind.fromJson(json);
  }

  Future<List<AnimalKind>> getByKind(String kind){
    return super.getAll({'kind': kind});
  }

}