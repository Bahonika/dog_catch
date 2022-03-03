import 'package:dog_catch/data/entities/municipality.dart';
import 'package:dog_catch/data/repository/municipality_repository.dart';
import 'package:dog_catch/utils/grouped_statistics_view.dart';
import 'package:dog_catch/utils/spin_kit.dart';
import 'package:flutter/material.dart';

import '../data/entities/statistics_info.dart';

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
  int municipality = 1;

  void uploadMunicipalities() async{
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
      uploadMunicipalities();
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
                  municipality = value!;
                  uploadStatistics(municipality);
                });
              },
              value: municipality,
              )
            : const Center(child: SpinKit()),
        if(statistics != null)
          SizedBox(
            // TODO: constrained height
              height: MediaQuery.of(context).size.height * 0.6 - 48,
              child: GroupedStatisticsView(map: statistics!))
      ],
    );
  }

}