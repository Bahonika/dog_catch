import 'package:dog_catch/data/repository/AnimalCardRepository.dart';
import 'package:dog_catch/screens/animal_card_add.dart';
import 'package:dog_catch/screens/animal_card_view.dart';
import 'package:dog_catch/screens/login.dart';
import 'package:dog_catch/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:dog_catch/data/entities/AnimalCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/entities/Status.dart';
import '../data/entities/User.dart';
import '../data/repository/abstract/Api.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> with SingleTickerProviderStateMixin{

  late AnimationController animation;
  var animalCardList;

  User user = GuestUser();
  final Map<String, String> queryParams = {};
  var repository = AnimalCardRepository();

  Future<void> getData() async {
    var list = await repository.getAll(queryParams);
    var sharedPrefs = await SharedPreferences.getInstance();
    var userD = widget.user ?? await restoreFromSharedPrefs(sharedPrefs);

    setState(() {
      animalCardList = list;
      user = userD;
    });
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    user.clear(prefs);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  void initState() {
    animation = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    getData();
    super.initState();
  }

  void showFilter() {
    animation.dispose();
    showFilterSettings(context);
  }

  getParamColor(bool isActive) {
    if (isActive) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  // shows dialog with filter settings
  void showFilterSettings(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Material(
            type: MaterialType.transparency,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Кого показывать",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary),
                  ),

                  // kind filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  getParamColor(queryParams["kind_id"] == "1")),
                          onPressed: () => setState(() {
                                queryParams["kind_id"] == "1"
                                    ? queryParams.remove("kind_id")
                                    : queryParams["kind_id"] = "1";
                              }),
                          child: const Text("Собаки")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  getParamColor(queryParams["kind_id"] == "2")),
                          onPressed: () => setState(() {
                                queryParams["kind_id"] == "2"
                                    ? queryParams.remove("kind_id")
                                    : queryParams["kind_id"] = "2";
                              }),
                          child: const Text("Кошки")),
                    ],
                  ),

                  // sex filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  getParamColor(queryParams["sex"] == "M")),
                          onPressed: () => setState(() {
                                queryParams["sex"] == "M"
                                    ? queryParams.remove("sex")
                                    : queryParams["sex"] = "M";
                              }),
                          child: const Text("Мужской")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  getParamColor(queryParams["sex"] == "F")),
                          onPressed: () => setState(() {
                                queryParams["sex"] == "F"
                                    ? queryParams.remove("sex")
                                    : queryParams["sex"] = "F";
                              }),
                          child: const Text("Женский")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  getParamColor(queryParams["status"] == "V")),
                          onPressed: () => setState(() {
                                queryParams["status"] == "V"
                                    ? queryParams.remove("status")
                                    : queryParams["status"] = "V";
                              }),
                          child: const Text("Выпущены")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  getParamColor(queryParams["status"] == "O")),
                          onPressed: () => setState(() {
                                queryParams["status"] == "O"
                                    ? queryParams.remove("status")
                                    : queryParams["status"] = "O";
                              }),
                          child: const Text("Отловлены")),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.primary),
                              onPressed: () => setState(() {
                                    Navigator.pop(context);
                                    getData();
                                  }),
                              child: const Text("Сортировать")),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.primary),
                              onPressed: () => setState(() {
                                    if (queryParams.isNotEmpty) {
                                      queryParams.clear();
                                    }
                                    Navigator.pop(context);
                                    getData();
                                  }),
                              child: const Text("Сбросить фильтр")),
                        ]),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Color getColorForStatus(Status status) => status == Status.released
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.secondary;

  Decoration createStatusDecoration(AnimalCard animalCard) {
    return BoxDecoration(
      color: getColorForStatus(animalCard.status),
      border: Border(
        bottom: BorderSide(
          width: 10,
          color: getColorForStatus(animalCard.status),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Отлов животных"),
        leading: IconButton(
            onPressed: logout,
            icon: const RotatedBox(
                quarterTurns: 90,
                child: Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.redAccent,
                ))),
        actions: [
          IconButton(
              onPressed: showFilter,
              icon: const Icon(Icons.filter_alt_rounded)),
        ],
      ),
      body: Column(children: [
        Text("Вы вошли как $user"),
        animalCardList != null
            ? Expanded(
                child: GridView.count(
                crossAxisCount: 2,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                mainAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                children: List.generate(animalCardList?.length ?? 0, (index) {
                  return Hero(
                    tag: index,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnimalCardView(
                                  index: index, data: animalCardList[index]))),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                        ),
                        child: Container(
                          decoration:
                              createStatusDecoration(animalCardList[index]),
                          height: MediaQuery.of(context).size.width * 0.41,
                          width: MediaQuery.of(context).size.width * 0.41,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25),
                            ),
                            child: Image.network(
                              "https://" +
                                  Api.siteRoot +
                                  animalCardList[index].profileImagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ))
            : Expanded(
                child: Center(
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(animation),
                    child: Icon(Icons.stars),
                  ),
                ),
              )
      ]),
      floatingActionButton: user.role == User.comitee
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Statistics())),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.stacked_line_chart),
            )
          : user.role == User.catcher
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Statistics())),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(Icons.stacked_line_chart),
                      heroTag: "stat",
                    ),
                    const SizedBox(height: 13),
                    FloatingActionButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AnimalCardAdd())),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.add),
                      heroTag: "add",
                    ),
                  ],
                )
              : null,
    );
  }
}
