abstract class Api {

  static const String siteRoot = "projects.masu.edu.ru";
  static const String apiRoot = "/lyamin/dug/api/";

  String get apiEndpoint;

  String apiPath() => apiRoot+apiEndpoint;

}