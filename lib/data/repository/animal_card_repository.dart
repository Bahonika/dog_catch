import 'package:dog_catch/data/entities/animal_card.dart';
import 'package:dog_catch/data/repository/abstract/basic_repository.dart';

import '../entities/user.dart';

class AnimalCardRepository extends BasicRepository<AnimalCard>{

  @override
  final String apiEndpoint = "animal_card";

  static const int pageSize = 24;
  int count = 0;
  bool hasNext = false;
  bool hasPrevious = false;

  @override
  AnimalCard fromJson(json) {
    return AnimalCard.fromJson(json);
  }

  @override
  Future<List<AnimalCard>> getAll({int page = 1,
                                  Map<String, String>? queryParams,
                                  AuthorizedUser? user}) async {
    queryParams ??= {};
    queryParams["page"] = page.toString();
    return super.getAll(queryParams: queryParams, user: user);
  }

  @override
  List<AnimalCard> convertToList(json) {
    count = json["count"] as int;
    hasNext = (json["next"] != null);
    hasPrevious = (json["previous"] != null);
    return super.convertToList(json["results"]);
  }
}