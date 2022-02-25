import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

abstract class BasicRepository<T>{

  static const String siteRoot = "projects.masu.edu.ru";
  static const String apiRoot = "/lyamin/dug/api/";

  String get apiEndpoint;

  String apiPath() => apiRoot+apiEndpoint;
  Uri apiIdPath(int id) => Uri.https(siteRoot, apiRoot+apiEndpoint + "/$id");

  T fromJson(json);

  Future<List<T>> getAll([Map<String, String>? queryParams]) async{
    var uri = Uri.https(siteRoot, apiPath(), queryParams);
    var response = await http.get(uri);
    var status = response.statusCode;
    if (status == 200){
      List<T> list = [];
      var json = convert.jsonDecode(response.body);
      for(final item in json){
        list.add(fromJson(item));
      }
      return list;
    }
    throw HttpException("can't access $uri Status: $status");
  }

  Future<T> getById(int id) async{
    var response = await http.get(apiIdPath(id));
    var status = response.statusCode;
    if (status == 200){
      return fromJson(convert.jsonDecode(response.body));
    }
    throw HttpException("can't access $apiPath()/$id Status: $status");
  }



}