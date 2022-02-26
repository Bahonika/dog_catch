import 'package:dog_catch/data/entities/EventInfoSave.dart';
import 'package:dog_catch/data/repository/abstract/MultipartRepository.dart';

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