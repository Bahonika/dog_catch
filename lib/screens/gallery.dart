import 'dart:convert';

import 'package:dog_catch/screens/animal_card.dart';
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

  Future getData() async{
    var response = await http.get(Uri.http(' ',' '),
        headers: {"Content-Type": 'application/json; charset=utf-8'});
    jsonData = jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Список животных"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
        mainAxisSpacing: MediaQuery.of(context).size.width * 0.05,
        children: List.generate(100, (index) {
          return Hero(
            tag: index,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnimalCard(index: index))),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(159, 72, 72, 1),
                  border: Border(
                      bottom: BorderSide(
                          width: 13,
                          color: index % 3 == 1
                              ? const Color.fromRGBO(53, 188, 164, 1)
                              : const Color.fromRGBO(228, 160, 79, 1))),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromRGBO(159, 72, 72, 1),
                      index % 3 == 1
                          ? const Color.fromRGBO(53, 188, 164, 1)
                          : const Color.fromRGBO(228, 160, 79, 1)
                    ],
                    stops: const [0.9, 0.9],
                  ),
                ),
                height: MediaQuery.of(context).size.width * 0.41,
                width: MediaQuery.of(context).size.width * 0.41,
                child: Center(
                  child: Text(
                    'Item $index',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: widget.role == "org"
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Statistics())),
              backgroundColor: const Color.fromRGBO(228, 160, 79, 1),
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
                      backgroundColor: const Color.fromRGBO(228, 160, 79, 1),
                      child: const Icon(Icons.stacked_line_chart),
                      heroTag: "stat",
                    ),
                    const SizedBox(height: 13),
                    FloatingActionButton(
                      onPressed: cardAdd,
                      backgroundColor: const Color.fromRGBO(53, 188, 164, 1),
                      child: const Icon(Icons.add),
                      heroTag: "add",
                    ),
                  ],
                )
              : null,
    );
  }
}
