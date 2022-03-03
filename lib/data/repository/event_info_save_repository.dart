import 'package:dog_catch/data/entities/event_info_save.dart';
import 'package:dog_catch/data/repository/abstract/multipart_repository.dart';

class EventInfoSaveRepository extends MultipartRepository<EventInfoSave>{

  @override
  final String apiEndpoint = "event_info";

  @override
  EventInfoSave fromJson(json) {
    throw UnimplementedError();
  }

  @override
  final String idAlias = "id";

}