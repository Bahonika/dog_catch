import 'package:dog_catch/data/entities/DateFormats.dart';
import 'package:dog_catch/data/entities/User.dart';
import 'package:dog_catch/data/repository/abstract/Api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import "dart:io";

class StatisticsRepository extends Api{

  @override
  String apiEndpoint = "statistics";

  Future<dynamic> getAll(DateTime start, DateTime end, AuthorizedUser user) async{
    var queryParams = {
      'start_date': serverDateFormat.format(start),
      'end_date': serverDateFormat.format(end),
      'total': 'true',
      'by_kind': 'true',
      'by_municipality': 'true'
    };
    if(user.role == User.comitee){
      queryParams['by_org'] = 'true';
    }
    var uri = Uri.https(Api.siteRoot, apiPath(), queryParams);
    var response = await http.get(uri, headers: {'Authorization': "Token ${user.token}"});
    var status = response.statusCode;
    if(response.statusCode == 200){
      return convert.jsonDecode(response.body);
    }
    throw HttpException("can't access $uri Status: $status");
  }

}