import 'package:dog_catch/data/repository/AnimalCardRepository.dart';
import 'package:dog_catch/screens/animal_card_add.dart';
import 'package:dog_catch/screens/animal_card_view.dart';
import 'package:dog_catch/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:dog_catch/data/entities/AnimalCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/entities/User.dart';
import '../data/repository/Api.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  var animalCardList;
  User user = GuestUser();
  final Map<String, String> queryParams = {};
  var repository = AnimalCardRepository();

  Future<void> getData() async {
    var list = await repository.getAll(queryParams);
    print("1");
    var sharedPrefs = await SharedPreferences.getInstance();
    print("2");

    var userD = widget.user ?? await restoreFromSharedPrefs(sharedPrefs);
    print("3");

    setState(() {
      animalCardList = list;
      user = userD;
    });
  }

  void logout() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    user.clear(sharedPrefs);
    setState(() {
      user = GuestUser();
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void cardAdd() {
    showFilterSettings(context);
  }

  // TODO:
  Color getParamColor(String kindId) {
    if (queryParams.containsKey("kind_id") &&
        queryParams["kind_id"] == kindId) {
      return Theme.of(context).colorScheme.secondary;
    }
    return Theme.of(context).colorScheme.primary;
  }

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
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Кого показывать",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: getParamColor("1")),
                          onPressed: () => setState(() {
                                queryParams["kind_id"] = "1";
                              }),
                          child: const Text("Собаки")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: getParamColor("2")),
                          onPressed: () => setState(() {
                                queryParams["kind_id"] = "2";
                              }),
                          child: const Text("Кошки")),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary),
                            onPressed: () => setState(() {
                                  Navigator.pop(context);
                                  getData();
                                }),
                            child: const Text("Сортировать")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary),
                            onPressed: () => setState(() {
                                  if (queryParams.containsKey("kind_id")) {
                                    queryParams.remove("kind_id");
                                  }
                                  Navigator.pop(context);
                                  getData();
                                }),
                            child: const Text("Сбросить фильтр")),
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
                quarterTurns: 90, child: Icon(Icons.exit_to_app_rounded))),
        actions: [
          IconButton(
              onPressed: cardAdd, icon: const Icon(Icons.filter_alt_rounded)),
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
            : const Center(
                child: Text(
                  "Загрузка",
                  style: TextStyle(fontSize: 30),
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
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnimalCardAdd())),
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
