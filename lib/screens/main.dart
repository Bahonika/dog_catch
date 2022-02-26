import 'package:dog_catch/data/entities/User.dart';
import 'package:dog_catch/screens/gallery.dart';
import 'package:dog_catch/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(88, 60, 93, 1),
        systemNavigationBarColor: Color.fromRGBO(88, 60, 93, 1)),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Отлов животных',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(230, 230, 230, 1),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: const Color.fromRGBO(88, 60, 93, 1))
              .copyWith(secondary: const Color.fromRGBO(209, 185, 29, 1))),
      home: const Redirection(),
      // home: LoginPage(),
    );
  }
}

// The statefulWidget class required for redirecting to the gallery page if the user was logged in earlier.
class Redirection extends StatefulWidget {
  const Redirection({Key? key}) : super(key: key);

  @override
  _RedirectionState createState() => _RedirectionState();
}

class _RedirectionState extends State<Redirection> {
  User? user;
  bool showSplashScreen = true;

  restoreUser() async {
    var prefs = await SharedPreferences.getInstance();
    user = await restoreFromSharedPrefs(prefs);
    setState(() {});
  }

  @override
  void initState() {
    restoreUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // showSplashScreen ?
        user != null ? Gallery(user: user) : const LoginPage();
  }
}
