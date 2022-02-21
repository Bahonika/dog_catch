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
  void cardAdd() {}
  var jsonData;

  Future<void> getData() async {
    Uri url = Uri.https("projects.masu.edu.ru", "/lyamin/dug/api/animal_card");
    var response = await http.get(url);
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
      ),
      body: jsonData != null
          ? GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            utf8convert(jsonData[index]['status']) == "Выпущено"
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                        border: Border(
                            bottom: BorderSide(
                                width: 10,
                                color: utf8convert(jsonData[index]['status']) ==
                                        "Выпущено"
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary)),
                      ),
                      height: MediaQuery.of(context).size.width * 0.41,
                      width: MediaQuery.of(context).size.width * 0.41,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(25)),
                        child: Image.network(
                          "https://projects.masu.edu.ru/" +
                              jsonData[index]["profile_pic"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }))
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
