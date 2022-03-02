import 'package:dog_catch/data/entities/DateFormats.dart';
import 'package:dog_catch/data/entities/StatisticsFrame.dart';
import 'package:dog_catch/data/entities/StatisticsInfo.dart';
import 'package:dog_catch/utils/DetailedStatisticsView.dart';
import 'package:dog_catch/utils/GroupedStatisticsView.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../data/entities/User.dart';
import '../data/repository/StatisticRepository.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key, required this.user}) : super(key: key);

  final AuthorizedUser user;

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics>{

  StatisticsRepository statistics = StatisticsRepository();

  List<Color> colorList = [
      const Color.fromRGBO(228, 131, 64, 1),
      const Color.fromRGBO(242, 209, 102, 1)
  ];

  Color getColorByStatus(String status) =>
        status == "Поймано" ?
            const Color.fromRGBO(228, 131, 64, 1) :
            const Color.fromRGBO(242, 209, 102, 1);


  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  final _startDateEditingController = TextEditingController();
  final _endDateEditingController = TextEditingController();

  StatisticsFrame? _statisticsFrame;

  List<charts.Series<MapEntry<String, int>, String>>? totalStatistics;


  @override
  void initState() {
    super.initState();
    _startDateEditingController.text = appDateFormat.format(startDate);
    _endDateEditingController.text = appDateFormat.format(endDate);
    getStatistics();
  }

  @override
  void dispose() {
    super.dispose();
    _startDateEditingController.dispose();
    _endDateEditingController.dispose();
  }

  void pickStartDate() async{
    var picked = await showDatePicker(context: context,
        initialDate: startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    startDate = picked ?? startDate;
    _startDateEditingController.text = appDateFormat.format(startDate);
    if(startDate.isAfter(endDate)){
      endDate = DateTime(startDate.year, startDate.month, startDate.day);
      _endDateEditingController.text = appDateFormat.format(endDate);
    }
    setState(()=>{});
    getStatistics();
  }

  void pickEndDate() async{
    var picked = await showDatePicker(context: context,
        initialDate: endDate,
        firstDate: startDate,
        lastDate: DateTime(2100));
    endDate = picked ?? endDate;
    _endDateEditingController.text = appDateFormat.format(endDate);
    setState(()=>{});
    getStatistics();
  }

  void getStatistics() async{
    _statisticsFrame = await statistics.getAll(startDate, endDate, widget.user);
    setState(()=>{});
  }

  Future<Map<String, StatisticsInfo>> getDetailedStatistics(int id){
    return statistics.getDetailed(startDate, endDate, id, widget.user);
  }

  // не работает из-за бага в библиотеке charts_flutter
  Widget createSummaryPie(){
    final totalStatistics = [
      charts.Series<MapEntry<String, int>, String>(
          id: "Общая информация",
          domainFn: (MapEntry<String, int> row, _) => row.key,
          measureFn: (MapEntry<String, int> row, _) => row.value,
          colorFn: (MapEntry<String, int> row, _) =>
              charts.ColorUtil.fromDartColor(
              getColorByStatus(row.key)
          ),
          data: _statisticsFrame!.total.asRowSet())
    ];
    return charts.PieChart(
        totalStatistics,
        animate: true,
        // баг в chart_flutter: не отображается при указании defaultRenderer
        // https://github.com/google/charts/issues/321
        defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
          charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ])
    );
  }

  // придется пока использовать для круговых диаграмм pie
  Widget createSummaryPie2(){
    return PieChart(
      dataMap: Map.fromEntries(_statisticsFrame!.total.asRowSet()
          .map((item) => MapEntry(item.key, item.value.toDouble()))),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Статистика"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Row(
                         children: [
                           const Padding(
                             padding: EdgeInsets.only(right: 8),
                             child: Text("C: ",
                               style:  TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontSize: 14
                               ),
                             ),
                           ),
                           GestureDetector(
                               onTap: pickStartDate,
                               child: AbsorbPointer(
                                 child: IntrinsicWidth(
                                   child: TextFormField(
                                       readOnly: true,
                                       controller: _startDateEditingController,
                                       style: const TextStyle(fontSize: 14),
                                       decoration: const InputDecoration(
                                           border: OutlineInputBorder(),
                                           contentPadding:
                                           EdgeInsets.symmetric(
                                               vertical: 2,
                                               horizontal: 20)
                                       )
                                   ),
                                 ),
                               )
                           ),
                         ]
                     ),

                     Row(
                       children: [
                         const Padding(
                           padding: EdgeInsets.only(right: 8),
                           child: Text("По: ",
                             style:  TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 14
                             ),
                           ),
                         ),
                         GestureDetector(
                             onTap: pickEndDate,
                             child: AbsorbPointer(
                               child: IntrinsicWidth(
                                 child: TextFormField(
                                     readOnly: true,
                                     controller: _endDateEditingController,
                                     style: const TextStyle(fontSize: 14),
                                     decoration: const InputDecoration(
                                         border: OutlineInputBorder(),
                                         contentPadding:
                                         EdgeInsets.symmetric(
                                             vertical: 5,
                                             horizontal: 20)
                                     )
                                 ),
                               ),
                             )
                         ),
                       ],
                     )
                   ],
                 ),
             ),

            _statisticsFrame == null ?
                const Text("Нет данных") :
                DefaultTabController(
                    length: widget.user.role == User.catcher ? 2 : 4,
                    child: Column (
                      children: [
                        TabBar(
                            isScrollable: true,
                            indicatorColor: Theme.of(context).colorScheme.primary,
                            indicatorWeight: 5,
                            labelStyle: const TextStyle(fontSize: 18),
                            labelColor: Colors.black,
                            tabs: [
                              const Tab(text: "Общая статистика"),
                              const Tab(text: "По видам животных"),
                              if (widget.user.role == User.comitee)
                                  const Tab(text: "По муниципалитетам"),
                              if (widget.user.role == User.comitee)
                                const Tab(text: "Детальная статистика"),
                            ]
                        ),
                        SizedBox(
                          // TODO: scrollable tab bar view
                            height: 400,
                            child: TabBarView(
                                children: [
                                  // PieChart(
                                  //       dataMap: totalStatistics,
                                  //       chartValuesOptions: const ChartValuesOptions(
                                  //         chartValueStyle: TextStyle(fontSize: 20, color: Colors.black),
                                  //       ),
                                  //       legendOptions: const LegendOptions(
                                  //         legendShape: BoxShape.circle,
                                  //         legendTextStyle: TextStyle(fontSize: 20),
                                  //         legendPosition: LegendPosition.top,
                                  //         showLegendsInRow: true,
                                  //       ),
                                  //       colorList: colorList,
                                  //       chartRadius: MediaQuery.of(context).size.width * 0.73,
                                  //     ),
                                  Center(child: createSummaryPie2()),
                                  Center(child: GroupedStatisticsView(map: _statisticsFrame!.byKind)),
                                  if (widget.user.role == User.comitee)
                                        Center(child: GroupedStatisticsView(map: _statisticsFrame!.byMunicipality!)),
                                  if (widget.user.role == User.comitee)
                                       Center(child: DetailedStatisticsView(
                                                  callback: getDetailedStatistics)),
                                ]
                            )
                        )
                      ],
                    )
                )
            ],
        ),

      )

    );
  }
}
