import 'package:flutter/material.dart';

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
  static int _currentIndex = 0;
  late PageController pageController;
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
  int catch_info = -1,
  release_info = -1;

  @override
  void initState() {
    setState(() {
      kind = utf8convert(widget.data['kind'] ?? "");
      sex = utf8convert(widget.data['sex'] ?? "");
      chinN = utf8convert(widget.data['chin_n'] ?? "");
      badgeN = utf8convert(widget.data['badge_n'] ?? "");
      info = utf8convert(widget.data['info'] ?? "");
      catch_info = widget.data['catch_info'] ?? -1;
      release_info = widget.data['release_info'] ?? -1;
      org = utf8convert(widget.data['org'] ?? "");
      municipality = utf8convert(widget.data['municipality'] ?? "");
      status = utf8convert(widget.data['status'] ?? "");
      catchDate = utf8convert(widget.data['catch_date'] ?? "");
      releaseDate = utf8convert(widget.data['release_date'] ?? "");
    });

    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
          backgroundColor: Colors.blue,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.orangeAccent,
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
                  child: Container(
                    color: const Color.fromRGBO(159, 72, 72, 1),
                    child: Center(
                        child: Image.network(
                      "https://projects.masu.edu.ru/" +
                          widget.data["profile_pic"],
                      fit: BoxFit.fitHeight,
                      height: MediaQuery.of(context).size.height,
                      // height: 400,
                    )),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      color: const Color.fromRGBO(224, 195, 195, 1.0),
                      child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text(
                              "Тип данных",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            )),
                            DataColumn(
                                label: Text(
                              "Данные",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            )),
                          ],
                          // kind
                          // sex
                          // chin_n
                          // badge_n
                          // info
                          // catch_info
                          // release_info
                          // org
                          // municipality
                          // status
                          // catch_date
                          // release_date
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
                                const DataCell(Text('Инофрмация об отлове')),
                                DataCell(Text(catch_info.toString())),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Инофрмация об выпуске')),
                                DataCell(Text(release_info.toString())),
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
                          border: TableBorder.symmetric(
                            inside:
                                const BorderSide(width: 2, color: Colors.green),
                          ))),
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
