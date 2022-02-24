import 'package:dog_catch/data/entities/EventInfo.dart';
import 'package:dog_catch/data/repository/BasicRepository.dart';

class EventInfoRepository extends BasicRepository<EventInfo>{

  @override
  final String apiEndpoint = "event_info";

  @override
  EventInfo fromJson(json) {
    return EventInfo.fromJson(json);
  }

}