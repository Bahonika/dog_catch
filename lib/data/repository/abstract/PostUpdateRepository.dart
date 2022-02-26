import 'dart:_http';

import 'package:dog_catch/data/entities/User.dart';
import 'package:dog_catch/data/repository/abstract/BasicRepository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


import '../../entities/abstract/Postable.dart';
import 'Api.dart';

abstract class PostUpdateRepository<T extends Postable> extends BasicRepository<T>{

  String get idAlias;

  Future<int> create(T entity, AuthorizedUser user) async{
    var uri = Uri.https(Api.siteRoot, apiPath());
    var response = await http.post(uri, headers: {'Authorization': user.getToken()},
                                        body: entity.toJson());
    var status = response.statusCode;
    if (status == 200){
      var json = convert.jsonDecode(response.body);
      return json[idAlias] as int;
    }
    throw HttpException("can't post to $uri Status: $status");
  }

  Future<void> update(T entity, int id, AuthorizedUser user) async{
    var response = await http.put(apiIdPath(id), headers: {'Authorization': user.getToken()},
                                                  body: entity.toJson());
    var status = response.statusCode;
    if(status != 200){
      throw HttpException("can't update Status: $status");
    }
  }


}