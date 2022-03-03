import 'package:dog_catch/data/entities/user.dart';
import 'package:dog_catch/data/repository/auth_user.dart';
import 'package:dog_catch/screens/gallery.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController loginController;
  late TextEditingController passwordController;

  User? user;
  var authUser = AuthUser();
  bool isAuthFailed = false;

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

  void login() async {
    try {
      user = await authUser.auth(
          loginController.value.text, passwordController.value.text);
      var prefs = await SharedPreferences.getInstance();
      user!.save(prefs);
      setState(() {
        isAuthFailed = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WillPopScope(
                  onWillPop: () async => false, child: Gallery(user: user))));
    } on AuthorizationException catch (e) {
      setState(() {
        isAuthFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Вход"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isAuthFailed)
                  const Text(
                    "Неверные данные пользователя",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                TextField(
                  controller: loginController,
                  decoration: const InputDecoration(label: Text("Логин")),
                ),
                TextField(
                  decoration: const InputDecoration(
                    label: Text("Пароль"),
                  ),
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: login, child: const Text("Вход")),
                      ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WillPopScope(
                                      onWillPop: () async => false,
                                      child: Gallery(user: GuestUser())))),
                          child: const Text("Войти как гость")),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
