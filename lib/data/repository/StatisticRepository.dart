import 'package:dog_catch/data/entities/DateFormats.dart';
import 'package:dog_catch/data/entities/StatisticsFrame.dart';
import 'package:dog_catch/data/entities/User.dart';
import 'package:dog_catch/data/repository/abstract/Api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import "dart:io";

import '../entities/StatisticsInfo.dart';

class StatisticsRepository extends Api{

  @override
  String apiEndpoint = "statistics";

  Future<StatisticsFrame> getAll(DateTime start, DateTime end, AuthorizedUser user) async{
    var queryParams = {
      'start_date': serverDateFormat.format(start),
      'end_date': serverDateFormat.format(end),
    };
    var uri = Uri.https(Api.siteRoot, apiPath(), queryParams);
    var response = await http.get(uri, headers: {'Authorization': "Token ${user.token}"});
    var status = response.statusCode;
    if(response.statusCode == 200){
      return StatisticsFrame.fromJson(convert.jsonDecode(response.body));
    }
    throw HttpException("can't access $uri Status: $status");
  }

  Future<Map<String, StatisticsInfo>> getDetailed(DateTime start,
                                                  DateTime end,
                                                  int municipality,
                                                  AuthorizedUser user) async{
    var queryParams = {
      'start_date': serverDateFormat.format(start),
      'end_date': serverDateFormat.format(end),
      'municipality_id': municipality.toString()
    };
    var uri = Uri.https(Api.siteRoot, apiPath(), queryParams);
    var response = await http.get(uri, headers: {'Authorization': "Token ${user.token}"});
    var status = response.statusCode;
    if(response.statusCode == 200){
      return StatisticsFrame.toMap(convert.jsonDecode(response.body));
    }
    throw HttpException("can't access $uri Status: $status");
  }

}