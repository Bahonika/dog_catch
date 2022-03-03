import '../entities/raid.dart';
import 'abstract/post_update_repository.dart';

class RaidRepository extends PostUpdateRepository<Raid>{

  @override
  String apiEndpoint = "raid";

  @override
  Raid fromJson(json) => Raid.fromJson(json);

  @override
  final String idAlias = "raid_n";

}