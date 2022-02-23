import 'dart:convert';

import 'package:dog_catch/screens/animal_card.dart';
import 'package:dog_catch/screens/login.dart';
import 'package:dog_catch/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Gallery extends StatefulWidget {
  const Gallery({Key? key, required this.role}) : super(key: key);

  final String role;
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  void cardAdd() {
    showFilterSettings(context);
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
                              primary: showOnlyDog
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary),
                          onPressed: () => setState(() {
                                showOnlyDog = !showOnlyDog;
                              }),
                          child: Text("Собаки")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: showOnlyCats
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary),
                          onPressed: () => setState(() {
                                showOnlyCats = !showOnlyCats;
                              }),
                          child: Text("Кошки")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: showOnlyOther
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary),
                          onPressed: () => setState(() {
                                showOnlyOther = !showOnlyOther;
                              }),
                          child: Text("Другие")),
                    ],
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary),
                      onPressed: () => setState(() {
                            Navigator.pop(context);
                            getData();
                          }),
                      child: Text("Сортировать")),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static bool showOnlyDog = false, showOnlyCats = false, showOnlyOther = false;
  bool isSortVisible = false;

  var jsonData;

  String urlCreate() {
    String url = "https://projects.masu.edu.ru/lyamin/dug/api/animal_card";
    print(url.length);
    if (showOnlyDog) {
      url += "?kind_id=1";
    }
    if (showOnlyCats) {
      url.length == 55 ? url += "?kind_id=2" : url += "/kind_id=2";
    }
    if (showOnlyOther) {
      url.length == 55 ? url += "?kind_id=2" : url += "&?kind_id=2";
    }
    print(url);
    return url;
  }

  Future<void> getData() async {
    Uri uri = Uri.parse(urlCreate());
    var response = await http.get(uri);
    setState(() {
      jsonData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Список животных"),
        actions: [
          IconButton(onPressed: cardAdd, icon: Icon(Icons.filter_alt_rounded))
        ],
      ),
      body: jsonData != null
          ? Stack(children: [
              GridView.count(
                  crossAxisCount: 2,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                  mainAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                  children: List.generate(jsonData?.length ?? 0, (index) {
                    return Hero(
                      tag: index,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnimalCard(
                                    index: index, data: jsonData[index]))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: utf8convert(jsonData[index]['status']) ==
                                      "Выпущено"
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              border: Border(
                                bottom: BorderSide(
                                    width: 10,
                                    color: utf8convert(
                                                jsonData[index]['status']) ==
                                            "Выпущено"
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ),
                            height: MediaQuery.of(context).size.width * 0.41,
                            width: MediaQuery.of(context).size.width * 0.41,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(25),
                              ),
                              child: Image.network(
                                "https://projects.masu.edu.ru/" +
                                    jsonData[index]["profile_pic"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
              // Visibility(
              //     visible: isSortVisible,
              //     maintainAnimation: false,
              //     maintainState: false,
              //     child: Container(
              //       height: 300,
              //       margin:
              //           const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20),
              //         color: Colors.white,
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey.withOpacity(0.5),
              //             spreadRadius: 5,
              //             blurRadius: 7,
              //             offset:
              //                 const Offset(0, 3), // changes position of shadow
              //           ),
              //         ],
              //       ),
              //       child: Column(
              //         children: [
              //           Row(
              //             children: [],
              //           )
              //         ],
              //       ),
              //     ))
            ])
          : const Center(
              child: Text(
                "Загрузка",
                style: TextStyle(fontSize: 30),
              ),
            ),
      floatingActionButton: widget.role == "org"
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Statistics())),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.stacked_line_chart),
            )
          : widget.role == "catcher"
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
                      onPressed: cardAdd,
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
