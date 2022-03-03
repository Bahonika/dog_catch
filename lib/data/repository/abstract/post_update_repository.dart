import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dog_catch/data/entities/user.dart';
import 'package:dog_catch/data/repository/abstract/basic_repository.dart';
import 'package:http/http.dart' as http;


import '../../entities/abstract/postable.dart';
import 'api.dart';

abstract class PostUpdateRepository<T extends Postable> extends BasicRepository<T>{

  String get idAlias;

  Future<int> create(T entity, AuthorizedUser user) async{
    var uri = Uri.https(Api.siteRoot, apiPath());
    var dio = Dio();
    var response = await dio.post("https://" + Api.siteRoot+apiPath(),
        data: entity.toJson(),
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Token ' + user.token}
        ));
    var status = response.statusCode;
    if (status == 201){
      return response.data[idAlias];
    }
    throw HttpException("can't post to $uri Status: $status");
  }

  Future<void> update(T entity, int id, AuthorizedUser user) async{
    var response = await http.put(apiIdPath(id), headers: {'Authorization': "Token ${user.token}"},
                                                  body: entity.toJson());
    var status = response.statusCode;
    if(status != 201){
      throw HttpException("can't update Status: $status");
    }
  }


}