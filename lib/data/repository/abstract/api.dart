abstract class Api {

  static const String siteRoot = "localhost:8000";
  //static const String siteRoot = "projects.masu.edu.ru";
  static const String apiRoot = "/api/";
  //static const String apiRoot = "/lyamin/dug/api/";

  //static const String mediaPath = "https://" + siteRoot;
  static const String mediaPath = "http://" + siteRoot + "/api";

  String get apiEndpoint;

  String apiPath() => apiRoot+apiEndpoint;

}