import 'package:dog_catch/screens/animal_card_add.dart';
import 'package:dog_catch/screens/login.dart';
import 'package:dog_catch/screens/statistics.dart';
import 'package:dog_catch/utils/animal_card_grid.dart';
import 'package:dog_catch/utils/spin_kit.dart';
import 'package:flutter/material.dart';
import 'package:dog_catch/data/entities/animal_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/entities/status.dart';
import '../data/entities/user.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> with SingleTickerProviderStateMixin {
  // ignore: prefer_typing_uninitialized_variables
  var animalCardList = {};

  late TextEditingController chipController;
  late TextEditingController badgeController;

  late User user;

  final Map<String, String> queryParams = {};

  final Map<String, String> queryParamsForFilter = {};
  final Map<String, String> queryParamsForSearch = {};

  Future<void> getData(Map<String, String> queryParams) async {
    // var list = await repository.getAll(queryParams: queryParams);
    setState(() {});
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
    user = widget.user!;
    chipController = TextEditingController();
    badgeController = TextEditingController();
    getData(queryParamsForFilter);
    super.initState();
  }

  @override
  void dispose() {
    chipController.dispose();
    badgeController.dispose();
    super.dispose();
  }

  getParamColor(bool isActive) {
    if (isActive) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

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
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 250),
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
                                    queryParamsForSearch["chip"] =
                                        chipController.text;
                                    getData(queryParamsForSearch);
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
                                      queryParamsForSearch["chip"] =
                                          badgeController.text;
                                      getData(queryParamsForSearch);
                                      Navigator.pop(context);
                                    }
                                  })
                                },
                                icon: const Icon(Icons.search_rounded),
                              ),
                              label: const Text(AnimalCard.badgeAlias))),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary),
                            onPressed: () => setState(() {
                                  if (queryParamsForSearch.isNotEmpty) {
                                    queryParamsForSearch.clear();
                                  }
                                  chipController.clear();
                                  badgeController.clear();
                                  getData(queryParamsForSearch);
                                }),
                            child: const Text("Сбросить поиск")),
                      ),
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
                                        queryParamsForFilter["kind_id"] ==
                                            "1")),
                                onPressed: () => setState(() {
                                      queryParamsForFilter["kind_id"] == "1"
                                          ? queryParamsForFilter
                                              .remove("kind_id")
                                          : queryParamsForFilter["kind_id"] =
                                              "1";
                                    }),
                                child: const Text("Собаки")),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: getParamColor(
                                        queryParamsForFilter["kind_id"] ==
                                            "2")),
                                onPressed: () => setState(() {
                                      queryParamsForFilter["kind_id"] == "2"
                                          ? queryParamsForFilter
                                              .remove("kind_id")
                                          : queryParamsForFilter["kind_id"] =
                                              "2";
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
                                  primary: getParamColor(
                                      queryParamsForFilter["sex"] == "M")),
                              onPressed: () => setState(() {
                                    queryParamsForFilter["sex"] == "M"
                                        ? queryParamsForFilter.remove("sex")
                                        : queryParamsForFilter["sex"] = "M";
                                  }),
                              child: const Text("Мужской")),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: getParamColor(
                                      queryParamsForFilter["sex"] == "F")),
                              onPressed: () => setState(() {
                                    queryParamsForFilter["sex"] == "F"
                                        ? queryParamsForFilter.remove("sex")
                                        : queryParamsForFilter["sex"] = "F";
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
                                      queryParamsForFilter["status"] == "V")),
                              onPressed: () => setState(() {
                                    queryParamsForFilter["status"] == "V"
                                        ? queryParamsForFilter.remove("status")
                                        : queryParamsForFilter["status"] = "V";
                                  }),
                              child: const Text("Выпущены")),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: getParamColor(
                                      queryParamsForFilter["status"] == "O")),
                              onPressed: () => setState(() {
                                    queryParamsForFilter["status"] == "O"
                                        ? queryParamsForFilter.remove("status")
                                        : queryParamsForFilter["status"] = "O";
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
                                    getData(queryParamsForFilter);
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
                                    if (queryParamsForFilter.isNotEmpty) {
                                      queryParamsForFilter.clear();
                                    }
                                    Navigator.pop(context);
                                    getData(queryParamsForFilter);
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
        elevation: 0,
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
              onPressed: () => showFilterSettings(context),
              icon: const Icon(Icons.filter_alt_rounded)),
          IconButton(
              onPressed: () => showSearchSettings(context),
              icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: animalCardList != null
          ?  Stack(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: AnimalCardGrid(
                        queryParams: queryParamsForFilter,
                      )
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          "Вы вошли как $user",
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ])
              // : Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 8),
              //     child: const Center(
              //       child: Text(
              //         "Список животных пуст, попробуйте убрать некоторые фильтры",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(fontSize: 20),
              //       ),
              //     ),
              //   )
          : const Center(child: SpinKit()),
      floatingActionButton: user.role == User.comitee
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Statistics(user: user as AuthorizedUser))),
              backgroundColor: Theme.of(context).colorScheme.secondary,
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
                              builder: (context) =>
                                  Statistics(user: user as AuthorizedUser))),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(Icons.stacked_line_chart),
                      heroTag: "stat",
                    ),
                    const SizedBox(height: 13),
                    FloatingActionButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AnimalCardAdd(user: user as AuthorizedUser))),
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
