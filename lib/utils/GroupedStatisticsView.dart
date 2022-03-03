import 'package:flutter/cupertino.dart';

import '../data/entities/StatisticsInfo.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GroupedStatisticsView extends StatelessWidget{
  GroupedStatisticsView({Key? key, required Map<String, StatisticsInfo> map})
      : data =  map.entries.toList(),
        super(key: key);

  final List<MapEntry<String, StatisticsInfo>> data;

  Color getColorByStatus(String status) =>
      status == "Поймано" ?
      const Color.fromRGBO(228, 131, 64, 1) :
      const Color.fromRGBO(242, 209, 102, 1);

  @override
  Widget build(BuildContext context) {
    final chartData = [
      charts.Series<MapEntry<String, StatisticsInfo>, String>(
          id: "Поймано",
          domainFn: (MapEntry<String, StatisticsInfo> row, _) => row.key,
          measureFn: (MapEntry<String, StatisticsInfo> row, _) => row.value.catched,
          colorFn: (MapEntry<String, StatisticsInfo> row, _) =>
              charts.ColorUtil.fromDartColor(getColorByStatus("Поймано")),
          data: data),

      charts.Series<MapEntry<String, StatisticsInfo>, String>(
          id: "Отпущено",
          domainFn: (MapEntry<String, StatisticsInfo> row, _) => row.key,
          measureFn: (MapEntry<String, StatisticsInfo> row, _) => row.value.released,
          colorFn: (MapEntry<String, StatisticsInfo> row, _) =>
              charts.ColorUtil.fromDartColor(getColorByStatus("Отпущено")),
          data: data)
    ];

    return charts.BarChart(
      chartData,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

}