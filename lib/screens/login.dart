import 'dart:convert';

import 'package:dog_catch/data/entities/User.dart';
import 'package:dog_catch/data/repository/AuthUser.dart';
import 'package:dog_catch/screens/gallery.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
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
              .copyWith(secondary: const Color.fromRGBO(241, 143, 1, 1))
              .copyWith(primary: const Color.fromRGBO(77, 113, 21, 1))
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController loginController;
  late TextEditingController passwordController;

  User user = GuestUser();
  var authUser = AuthUser();

  @override
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async{
    try{
      user = await authUser.auth(loginController.value.text,
                            passwordController.value.text);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => Gallery(user: user)));

    }
    on AuthorizationException catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Вход"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: loginController,
                decoration: const InputDecoration(label: Text("Email")),
              ),
              TextField(
                decoration: const InputDecoration(label: Text("Password")),
                controller: passwordController,
              ),
              ElevatedButton(
                  onPressed: login,
                  child: const Text("Вход")),
              ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Gallery(user: GuestUser()))),
                  child: const Text("Без логина")),
              ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Gallery(user: User(role: User.catcher)))),
                  child: const Text(User.catcher)),
              ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Gallery(user: User(role: User.comitee)))),
                  child: const Text(User.comitee)),
            ],
          ),
        ),
      ),
    );
  }
}
