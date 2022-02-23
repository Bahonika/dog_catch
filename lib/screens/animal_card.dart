// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class AnimalCard extends StatefulWidget {
  const AnimalCard({Key? key, required this.index, required this.data})
      : super(key: key);

  final int index;
  final data;

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  int _currentIndex = 0;
  int _currentImage = 0;

  late PageController pageController;
  late PageController imageController;

  var data, catchData, releaseData;

  String kind = "",
      sex = "",
      chinN = "",
      badgeN = "",
      info = "",
      org = "",
      municipality = "",
      status = "",
      catchDate = "",
      releaseDate = "";
  int catchInfo = -1, releaseInfo = -1;

  Future getEventData(int id, String varName) async {
    Uri url = Uri.https(
        "projects.masu.edu.ru", "/lyamin/dug/api/event_info/" + id.toString());
    var response = await http.get(url);
    if (varName == "catchData") {
      catchData = json.decode(response.body);
    } else if (varName == "releaseData") {
      releaseData = json.decode(response.body);
    }

    // return json.decode(response.body);
  }

  Widget dataTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
      child: DataTable(
          // border: TableBorder.symmetric(
          //   inside: BorderSide(
          //       width: 2, color: Theme.of(context).colorScheme.primary),
          // ),
          columns: [
            DataColumn(
                label: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 3,
              ),
              child: const Text(
                "Тип данных",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )),
            DataColumn(
                label: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 3,
              ),
              child: const Text(
                "Данные",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )),
          ],
          rows: [
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Тип')),
                DataCell(Text(kind)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Пол')),
                DataCell(Text(sex)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Номер чипа')),
                DataCell(Text(chinN)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Номер бирки')),
                DataCell(Text(badgeN)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Информация')),
                DataCell(Text(info)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Организация')),
                DataCell(Text(org)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Муниципалитет')),
                DataCell(Text(municipality)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Статус')),
                DataCell(Text(status)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Дата отлова')),
                DataCell(Text(catchDate)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                const DataCell(Text('Дата выпуска')),
                DataCell(Text(releaseDate)),
              ],
            ),
          ],
      ),
    );
  }

  Widget catchTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
      child: DataTable(
          border: TableBorder.symmetric(
            inside: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          columns: [
            DataColumn(
                label: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 3,
              ),
              child: const Text(
                "Тип данных",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )),
            DataColumn(
                label: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 3,
              ),
              child: const Text(
                "Данные",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )),
          ],
          rows: catchData != null
              ? [
                  DataRow(cells: [
                    const DataCell(Text("Адрес")),
                    DataCell(Text(utf8convert(catchData["adress"] ?? "")))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Координаты")),
                    DataCell(Text((catchData["lat"].toString()) +
                        "\n" +
                        (catchData["long"].toString())))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Данные по заявке")),
                    DataCell(
                        Text(utf8convert(catchData['claim_summary'] ?? "")))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Данные по рейду")),
                    DataCell(Text(utf8convert(catchData['raid_summary'] ?? "")))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Исполнитель")),
                    DataCell(Text(utf8convert(catchData['staff_worker'] ?? "")))
                  ]),
                ]
              : []),
    );
  }

  Widget releaseTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
      child: DataTable(
          border: TableBorder.symmetric(
            inside: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          columns: [
            DataColumn(
                label: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 3,
              ),
              child: const Text(
                "Тип данных",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )),
            DataColumn(
                label: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 3,
              ),
              child: const Text(
                "Данные",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )),
          ],
          rows: releaseData != null
              ? [
                  DataRow(cells: [
                    const DataCell(Text("Адрес")),
                    DataCell(Text(utf8convert(releaseData["adress"] ?? "")))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Координаты")),
                    DataCell(Text((releaseData["lat"].toString()) +
                        "\n" +
                        (releaseData["long"]!.toString())))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Данные по заявке")),
                    DataCell(
                        Text(utf8convert(releaseData['claim_summary'] ?? "")))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Данные по рейду")),
                    DataCell(
                        Text(utf8convert(releaseData['raid_summary'] ?? "")))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Исполнитель")),
                    DataCell(
                        Text(utf8convert(releaseData['staff_worker'] ?? "")))
                  ]),
                ]
              : []),
    );
  }

  @override
  void initState() {
    setState(() {
      kind = utf8convert(widget.data['kind'] ?? "");
      sex = utf8convert(widget.data['sex'] ?? "");
      chinN = utf8convert(widget.data['chin_n'] ?? "");
      badgeN = utf8convert(widget.data['badge_n'] ?? "");
      info = utf8convert(widget.data['info'] ?? "");
      catchInfo = widget.data['catch_info'] ?? -1;
      releaseInfo = widget.data['release_info'] ?? -1;
      org = utf8convert(widget.data['org'] ?? "");
      municipality = utf8convert(widget.data['municipality'] ?? "");
      status = utf8convert(widget.data['status'] ?? "");
      catchDate = utf8convert(widget.data['catch_date'] ?? "");
      releaseDate = utf8convert(widget.data['release_date'] ?? "");
    });
    setState(() {
      if (catchInfo != -1) {
        getEventData(catchInfo, "catchData");
      }
      if (releaseInfo != -1) {
        getEventData(releaseInfo, "releaseData");
      }
    });

    imageController = PageController(initialPage: 0);
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Item ${widget.index}'),
          elevation: 2,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.primary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linearToEaseOut);
            _currentIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Фото"),
            BottomNavigationBarItem(
                icon: Icon(Icons.table_rows), label: "Данные"),
          ],
        ),
        body: Hero(
          tag: widget.index,
          child: PageView(
              children: [
                Center(
                  child: Center(
                      child: Image.network(
                    "https://projects.masu.edu.ru/" +
                        widget.data["profile_pic"],
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height,
                  )),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        child: Stack(
                            alignment: AlignmentDirectional.topStart,
                            children: [
                              PageView.builder(
                                controller: imageController,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(20),
                                    child: Image.network(
                                        "https://projects.masu.edu.ru/" +
                                            widget.data["pictures"][index]),
                                  );
                                },
                                onPageChanged: (int index) {
                                  setState(() {
                                    _currentImage = index;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.data["pictures"].length,
                              ),
                              Visibility(
                                visible: 0 == widget.data["pictures"].length - 1
                                    ? false
                                    : true,
                                child: Container(
                                  alignment: Alignment.center,
                                  // margin: EdgeInsets.only(bottom: 20),
                                  width: MediaQuery.of(context).size.width,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0;
                                            i < widget.data["pictures"].length;
                                            i++)
                                          if (i == _currentImage) ...[
                                            circleBar(true)
                                          ] else
                                            circleBar(false),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text("Основная информация",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center),
                      ),
                      dataTable(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text("Информация об отлове",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center),
                      ),
                      Visibility(
                        visible: catchData != null,
                        replacement: const Text("Информация отсутсвует"),
                        child: catchTable(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text("Информация о выпуске",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center),
                      ),
                      Visibility(
                          visible: releaseData != null,
                          replacement: const Text(
                            "Информация отсутсвует",
                            style: TextStyle(fontSize: 20),
                          ),
                          child: releaseTable()),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ],
              scrollDirection: Axis.horizontal,
              controller: pageController,
              onPageChanged: (index) => setState(() {
                    _currentIndex = index;
                  })),
        ));
  }
}
