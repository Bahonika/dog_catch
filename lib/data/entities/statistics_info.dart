class StatisticsInfo{

  final int all;
  final int catched;
  final int released;

  StatisticsInfo({
    required this.all,
    required this.catched,
    required this.released
  });

  factory StatisticsInfo.fromJson(Map<String, dynamic> json){
    return StatisticsInfo(
        all: json["all"] as int,
        catched: json["catched"] as int,
        released: json["released"] as int);
  }

  List<MapEntry<String, int>> asRowSet(){
    return [
      MapEntry('Поймано', catched),
      MapEntry('Выпущено', released),
    ];
  }
}