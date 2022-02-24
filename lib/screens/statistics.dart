import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Map<String, double> dataMap = {
    "Dogs": 5,
    "Cats": 3,
    "Other": 2,
  };
  final colorList = [
    const Color.fromRGBO(242, 209, 102, 1),
    const Color.fromRGBO(228, 131, 64, 1),
    const Color.fromRGBO(159, 73, 43, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: PieChart(
            dataMap: dataMap,
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
        ],
      ),
    );
  }
}
