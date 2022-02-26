import '../entities/Raid.dart';
import 'abstract/PostUpdateRepository.dart';

class RaidRepository extends PostUpdateRepository<Raid>{

  @override
  String apiEndpoint = "raid";

  @override
  Raid fromJson(json) => Raid.fromJson(json);

  @override
  final String idAlias = "raid_n";

}