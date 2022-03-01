import 'package:dog_catch/data/entities/DateFormats.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../data/entities/User.dart';
import '../data/repository/StatisticRepository.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key, required this.user}) : super(key: key);

  final AuthorizedUser user;

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  StatisticsRepository statistics = StatisticsRepository();

  final colorList = [
    const Color.fromRGBO(242, 209, 102, 1),
    const Color.fromRGBO(228, 131, 64, 1),
  ];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Map<String, double> totalStatistics = {};


  void pickStartDate() async{
    var picked = await showDatePicker(context: context,
        initialDate: startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    startDate = picked ?? startDate;
    if(startDate.isAfter(endDate)){
      endDate = DateTime(startDate.year, startDate.month, startDate.day);
    }
    setState(()=>{});
  }

  void pickEndDate() async{
    var picked = await showDatePicker(context: context,
        initialDate: endDate,
        firstDate: startDate,
        lastDate: DateTime(2100));
    endDate = picked ?? endDate;
    setState(()=>{});
  }

  void getStatistics() async{
    var data = await statistics.getAll(startDate, endDate, widget.user);
    totalStatistics["Поймано"] = (data["total"]["catched"] as int).toDouble();
    totalStatistics["Выпущено"] = (data["total"]["released"] as int).toDouble();
    setState(()=>{});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Статистика"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text("C: ",
                      style:  TextStyle(
                         fontWeight: FontWeight.bold,
                          fontSize: 20
                       ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(appDateFormat.format(startDate),
                        style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(onPressed: pickStartDate,
                        child: const Icon(
                            Icons.date_range_outlined
                        ))
                  )
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("По: ",
                      style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(appDateFormat.format(endDate),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(onPressed: pickEndDate,
                          child: const Icon(
                              Icons.date_range_outlined
                          ))
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: getStatistics,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Поиск статистики",
                      style:  TextStyle(
                          fontSize: 20
                      ),
                    ),
                  )
              ),
            totalStatistics.isEmpty ?
                const Text("Нет данных") :
                Expanded(
                    child: PieChart(
                      dataMap: totalStatistics,
                      chartValuesOptions: const ChartValuesOptions(
                        chartValueStyle: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      legendOptions: const LegendOptions(
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(fontSize: 20),
                        legendPosition: LegendPosition.top,
                        showLegendsInRow: true,
                      ),
                      colorList: colorList,
                      chartRadius: MediaQuery.of(context).size.width * 0.73,
                    ))
                // DefaultTabController(
                //     length: 3,
                //     child: Column (
                //       children: const [
                //         TabBar(
                //             tabs: [
                //               Tab(text: "Общая статистика"),
                //               Tab(text: "По видам животных"),
                //               Tab(text: "По муниципалитетам"),
                //             ]
                //         ),
                //         TabBarView(
                //             children: [
                //               Center(child: Text("O")),
                //               Center(child: Text("В")),
                //               Center(child: Text("М")),
                //             ]
                //         )
                //       ],
                //     )
                // )
            ],

        ),

      )

    );
  }
}
