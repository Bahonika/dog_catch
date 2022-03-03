import '../entities/claim.dart';
import 'abstract/post_update_repository.dart';

class ClaimRepository extends PostUpdateRepository<Claim>{

  @override
  String apiEndpoint = "claim";

  @override
  Claim fromJson(json) => Claim.fromJson(json);

  @override
  final String idAlias = "claim_n";

}