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

class _GalleryState extends State<Gallery> with SingleTickerProviderStateMixin {
  late AnimationController animation;
  // ignore: prefer_typing_uninitialized_variables
  var animalCardList;

  late TextEditingController chipController;
  late TextEditingController badgeController;

  late User user;
  final Map<String, String> queryParams = {};
  var repository = AnimalCardRepository();

  Future<void> getData() async {
    var list = await repository.getAll(queryParams: queryParams);
    var sharedPrefs = await SharedPreferences.getInstance();
    user = widget.user ?? await restoreFromSharedPrefs(sharedPrefs);

    setState(() {
      animalCardList = list;
    });
  }

  Widget spinKit() {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(animation),
      child: Container(
        height: 50,
        width: 50,
        color: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        child: Container(
          height: 15,
          width: 15,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
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
    user = widget.user!;
    //animation start
    animation.repeat();
    chipController = TextEditingController();
    badgeController = TextEditingController();
    getData();
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    chipController.dispose();
    badgeController.dispose();
    super.dispose();
  }

  void showFilter() {
    showFilterSettings(context);
  }

  void showSearch() {
    showSearchSettings(context);
  }

  getParamColor(bool isActive) {
    if (isActive) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  // Не работает обновление состояния виджета в ветке дерева виджетов
  // как исправить пока хз
  // Widget filterButton(String text, String param, String value, Color color) {
  //   return Container(
  //     margin: const EdgeInsets.only(left: 4),
  //     child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(primary: color),
  //         onPressed: () => setState(() {
  //           color = getParamColor(queryParams[param] == value);
  //               queryParams[param] == value
  //                   ? queryParams.remove(param)
  //                   : queryParams[param] = value;
  //             }),
  //         child: Text(text)),
  //   );
  // }

  // shows dialog with search settings

  void showSearchSettings(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Material(
                type: MaterialType.transparency,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 280),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    children: [
                      Text(
                        "Поиск",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      TextFormField(
                        controller: chipController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => {
                                setState(() {
                                  if (chipController.text != "") {
                                    queryParams["chip"] = chipController.text;
                                    getData();
                                    Navigator.pop(context);
                                  }
                                })
                              },
                              icon: const Icon(Icons.search_rounded),
                            ),
                            label: const Text(AnimalCard.chipAlias)),
                      ),
                      TextFormField(
                          controller: badgeController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () => {
                                  setState(() {
                                    if (badgeController.text != "") {
                                      queryParams["chip"] =
                                          badgeController.text;
                                      getData();
                                      Navigator.pop(context);
                                    }
                                  })
                                },
                                icon: const Icon(Icons.search_rounded),
                              ),
                              label: const Text(AnimalCard.badgeAlias))),
                    ],
                  ),
                ));
          });
        });
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
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Фильтр",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2.5),
                      2: FlexColumnWidth(2.5),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          const Text(AnimalCard.kindAlias),
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: getParamColor(
                                        queryParams["kind_id"] == "1")),
                                onPressed: () => setState(() {
                                      queryParams["kind_id"] == "1"
                                          ? queryParams.remove("kind_id")
                                          : queryParams["kind_id"] = "1";
                                    }),
                                child: const Text("Собаки")),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: getParamColor(
                                        queryParams["kind_id"] == "2")),
                                onPressed: () => setState(() {
                                      queryParams["kind_id"] == "2"
                                          ? queryParams.remove("kind_id")
                                          : queryParams["kind_id"] = "2";
                                    }),
                                child: const Text("Кошки")),
                          ),
                        ],
                      ),
                      TableRow(children: [
                        const Text(AnimalCard.sexAlias),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      getParamColor(queryParams["sex"] == "M")),
                              onPressed: () => setState(() {
                                    queryParams["sex"] == "M"
                                        ? queryParams.remove("sex")
                                        : queryParams["sex"] = "M";
                                  }),
                              child: const Text("Мужской")),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      getParamColor(queryParams["sex"] == "F")),
                              onPressed: () => setState(() {
                                    queryParams["sex"] == "F"
                                        ? queryParams.remove("sex")
                                        : queryParams["sex"] = "F";
                                  }),
                              child: const Text("Женский")),
                        ),
                      ]),
                      TableRow(children: [
                        const Text(AnimalCard.statusAlias),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: getParamColor(
                                      queryParams["status"] == "V")),
                              onPressed: () => setState(() {
                                    queryParams["status"] == "V"
                                        ? queryParams.remove("status")
                                        : queryParams["status"] = "V";
                                  }),
                              child: const Text("Выпущены")),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: getParamColor(
                                      queryParams["status"] == "O")),
                              onPressed: () => setState(() {
                                    queryParams["status"] == "O"
                                        ? queryParams.remove("status")
                                        : queryParams["status"] = "O";
                                  }),
                              child: const Text("Отловлены")),
                        ),
                      ])
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 2),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.primary),
                              onPressed: () => setState(() {
                                    Navigator.pop(context);
                                    getData();
                                  }),
                              child: const Text("Фильтровать")),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 2),
                          child: ElevatedButton(
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
                        ),
                      ]),
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
          IconButton(
              onPressed: showSearch, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: Column(children: [
        Text("Вы вошли как $user"),
        animalCardList != null
            ? animalCardList.length != 0
                ? Expanded(
                    child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                    mainAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                    children:
                        List.generate(animalCardList?.length ?? 0, (index) {
                      animation.stop();
                      return Hero(
                        tag: index,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnimalCardView(
                                      index: index,
                                      data: animalCardList[index]))),
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Center(
                        child: Text(
                          "Список животных пуст, попробуйте убрать некоторые фильтры",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
            : Expanded(
                child: Center(child: spinKit()),
              )
      ]),
      floatingActionButton: user.role == User.comitee
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Statistics(user: user as AuthorizedUser))),
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
                              builder: (context) => Statistics(user: user as AuthorizedUser))),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(Icons.stacked_line_chart),
                      heroTag: "stat",
                    ),
                    const SizedBox(height: 13),
                    FloatingActionButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnimalCardAdd(user: user as AuthorizedUser))),
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
