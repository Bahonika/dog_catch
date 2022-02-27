import 'package:dog_catch/data/entities/Municipality.dart';
import 'package:dog_catch/data/repository/abstract/BasicRepository.dart';

class MunicipalityRepository extends BasicRepository<Municipality>{

  @override
  String apiEndpoint = "municipality";

  @override
  Municipality fromJson(json) {
    return Municipality.fromJson(json);
  }

  Future<List<Municipality>> getByName(String name){
    return super.getAll(queryParams: {'name': name});
  }

}