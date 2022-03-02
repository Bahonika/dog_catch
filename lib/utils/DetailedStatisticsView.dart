import 'package:dog_catch/data/entities/Municipality.dart';
import 'package:dog_catch/data/repository/MunicipalityRepository.dart';
import 'package:dog_catch/utils/GroupedStatisticsView.dart';
import 'package:flutter/material.dart';

import '../data/entities/StatisticsInfo.dart';

class DetailedStatisticsView extends StatefulWidget{
  const DetailedStatisticsView({Key? key, required this.callback}) : super(key: key);

  final Future<Map<String, StatisticsInfo>> Function(int) callback;


  @override
  State<StatefulWidget> createState() => _DetailedStatisticsViewState();

}
class _DetailedStatisticsViewState extends State<DetailedStatisticsView> {

  final MunicipalityRepository municipalityRepository = MunicipalityRepository();
  List<Municipality>? municipalities;
  Map<String, StatisticsInfo>? statistics;
  int municapality = 1;

  void uploadMunicipalytys() async{
    municipalities = await MunicipalityRepository().getAll();
    setState(() {
    });
  }

  void uploadStatistics(int id) async {
    statistics = await widget.callback(id);
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    if(municipalities == null){
      uploadMunicipalytys();
    }
    if(statistics == null){
      uploadStatistics(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        municipalities != null
            ?
            DropdownButton(
              focusColor: Theme.of(context).colorScheme.primary,
              items: municipalities!
                  .map((e) => DropdownMenuItem(
                  value: e.id, child: Text(e.name)))
                  .toList(),
              onChanged: (int? value) {
                setState(() {
                  municapality = value!;
                  uploadStatistics(municapality);
                });
              },
              value: municapality,
              )
            : const Text("Загружается..."),
        if(statistics != null)
          SizedBox(
            // TODO: constrained height
              height: 300,
              child: GroupedStatisticsView(map: statistics!))
      ],
    );
  }

}