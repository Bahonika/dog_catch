import 'dart:io';

import 'package:dog_catch/data/repository/abstract/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../entities/user.dart';

abstract class BasicRepository<T> extends Api{

  Uri apiIdPath(int id) => Uri.https(Api.siteRoot, Api.apiRoot+apiEndpoint+"/$id");

  T fromJson(json);

  List<T> convertToList(dynamic json){
    List<T> list = [];
    for(final item in json){
      list.add(fromJson(item));
    }
    return list;
  }

  Future<List<T>> getAll({Map<String, String>? queryParams, AuthorizedUser? user}) async{
    var uri = Uri.https(Api.siteRoot, apiPath(), queryParams);
    var response = user == null ? await http.get(uri) :
                                  await http.get(uri,
                                      headers: {'Authorization': "Token ${user.token}"});
    var status = response.statusCode;
    if (status == 200){
      return convertToList(convert.jsonDecode(response.body));
    }
    throw HttpException("can't access $uri Status: $status");
  }

  Future<T> getById(int id, [AuthorizedUser? user]) async{
    var response = user == null ? await http.get(apiIdPath(id)) :
                                  await http.get(apiIdPath(id),
                                      headers: {'Authorization': "Token ${user.token}"});
    var status = response.statusCode;
    if (status == 200){
      return fromJson(convert.jsonDecode(response.body));
    }
    throw HttpException("can't access $apiPath()/$id Status: $status");
  }



}