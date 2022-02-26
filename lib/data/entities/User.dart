import 'package:dog_catch/utils/Utf8Convert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String role;

  User({
    required this.role,
  });

  static const catcher = "Специалист по отлову";
  static const comitee = "Сотрудник комитета";
  static const guest = "Гость";

  @override
  String toString() {
    return role;
  }

  bool isAuthorized(){
    return role != User.guest;
  }

  void save(SharedPreferences prefs) async{
    await prefs.setString('role', role);
  }

  void clear(SharedPreferences prefs) async{
    await prefs.remove('role');
  }

}

class GuestUser extends User{
   GuestUser() : super(role: User.guest);
}

class AuthorizedUser extends User{

  final int id;
  final String email;
  final String name;
  final String surname;
  final String token;

  AuthorizedUser({required String role,
                  required this.id,
                  required this.email,
                  required this.name,
                  required this.surname,
                  required this.token}) :
        super(role: role);

  factory AuthorizedUser.fromJson(Map<String, dynamic> json){
      return AuthorizedUser(
          role: utf8convert(json["group"]),
          id: json["user_id"],
          email: utf8convert(json["email"]),
          name: utf8convert(json["first_name"]),
          surname: utf8convert(json["last_name"]),
          token: utf8convert(json["token"]));
  }

  @override
  void clear(SharedPreferences prefs) async{
    super.clear(prefs);
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('surname');
    await prefs.remove('email');
    await prefs.remove('id');
  }

  @override
  void save(SharedPreferences prefs) async{
    super.save(prefs);
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('surname', surname);
    await prefs.setString('email', email);
    await prefs.setInt('id', id);
  }

}

Future<User> restoreFromSharedPrefs(SharedPreferences prefs) async{
  var role = prefs.get('role') as String?;

  if(role == null || role == User.guest){
    return GuestUser();
  }

  var token = prefs.get('token') as String?;
  var name = prefs.get('name') as String?;
  var surname = prefs.get('surname') as String?;
  var email = prefs.get('email') as String?;
  var id = prefs.get('id') as int?;

  return AuthorizedUser(role: role,
                        id: id!,
                        email: email!,
                        name: name!,
                        surname: surname!,
                        token: token!);


}