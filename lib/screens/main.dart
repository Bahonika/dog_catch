import 'package:dog_catch/data/entities/user.dart';
import 'package:dog_catch/screens/gallery.dart';
import 'package:dog_catch/screens/login.dart';
import 'package:dog_catch/utils/color_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: colorList[0], systemNavigationBarColor: colorList[0]),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ru', 'RU'),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ru'),
      ],
      title: 'Отлов животных',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(230, 230, 230, 1),
          textTheme: const TextTheme(
              displayMedium: TextStyle(fontSize: 16, color: Colors.white)),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: colorList[0])
              .copyWith(secondary: colorList[1])),
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
    return user != null ? Gallery(user: user) : const LoginPage();
  }
}
