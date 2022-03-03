import 'package:dog_catch/data/entities/event_info.dart';
import 'package:dog_catch/data/repository/abstract/basic_repository.dart';

class EventInfoRepository extends BasicRepository<EventInfo>{

  @override
  final String apiEndpoint = "event_info";

  @override
  EventInfo fromJson(json) {
    return EventInfo.fromJson(json);
  }

}