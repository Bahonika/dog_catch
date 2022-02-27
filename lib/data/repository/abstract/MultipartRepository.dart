import 'dart:io';

import 'package:dog_catch/data/entities/abstract/PostableMultipart.dart';
import 'package:dog_catch/data/repository/abstract/PostUpdateRepository.dart';

import '../../entities/User.dart';
import 'Api.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

abstract class MultipartRepository<T extends PostableMultipart> extends PostUpdateRepository<T>{

  Future<FormData> _prepareData(T entity) async{
    var fields = entity.toJson();
    var files = entity.getFiles();
    for(final key in files.keys){
      File file = files[key]!;
      fields[key] = await MultipartFile.fromFile(file.path, filename:
      basename(file.path));
    }
    return FormData.fromMap(fields);
  }

  @override
  Future<int> create(T entity, AuthorizedUser user) async{
    var uri = Uri.https(Api.siteRoot, apiPath());
    var dio = Dio();
    var formData = await _prepareData(entity);
    var response = await dio.post("https://" + Api.siteRoot+apiPath(),
                                  data: formData,
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

  @override
  Future<void> update(T entity, int id, AuthorizedUser user) async{
    var dio = Dio();
    var formData = await _prepareData(entity);
    var response = await dio.put(apiIdPath(id).toString(),
                                data: formData,
                                options: Options(
                                    headers: {'Authorization': "Token ${user.token}"}
                                ));
    var status = response.statusCode;
    if(status != 201){
      throw HttpException("can't update Status: $status");
    }
  }


}