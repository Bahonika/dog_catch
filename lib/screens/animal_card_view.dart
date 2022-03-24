import 'package:better_player/better_player.dart';
import 'package:dog_catch/data/entities/animal_card.dart';
import 'package:dog_catch/data/entities/event_info.dart';
import 'package:dog_catch/data/repository/event_info_repository.dart';
import 'package:dog_catch/utils/custom_card.dart';
import 'package:flutter/material.dart';
import '../data/entities/abstract/displayable.dart';
import '../data/repository/abstract/api.dart';

class AnimalCardView extends StatefulWidget {
  const AnimalCardView({Key? key, required this.index, required this.data})
      : super(key: key);

  final int index;
  // ignore: prefer_typing_uninitialized_variables
  final data;

  @override
  State<AnimalCardView> createState() => _AnimalCardViewState();
}

class _AnimalCardViewState extends State<AnimalCardView> {
  final EventInfoRepository eventInfoRepository = EventInfoRepository();

  int _currentIndex = 0;
  int _currentImage = 0;

  late PageController pageController;
  late PageController imageController;

  late AnimalCard animalCard;

  EventInfo? catchData;
  EventInfo? releaseData;

  String? catchVideoUrl;
  String? releaseVideoUrl;

  void uploadEventInfos(AnimalCard card) async {
    catchData = await eventInfoRepository.getById(card.catchInfo);
    catchVideoUrl = Api.mediaPath + catchData!.videoUrl;
    if (card.releaseInfo != -1) {
      releaseData = await eventInfoRepository.getById(card.releaseInfo);
    }
    if (releaseData != null) {
      releaseVideoUrl = Api.mediaPath + releaseData!.videoUrl;
    }
    setState(() {});
  }

  @override
  void initState() {
    setState(() {
      animalCard = widget.data;
      uploadEventInfos(animalCard);
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

  Widget getDataTable(String title, Displayable? displayable) {
    List<DataRow> rows = [];
    displayable?.getFields().forEach((key, value) {
      rows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(key + ":",
                style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(value)),
          ],
        ),
      );
    });
    Widget child = rows.isEmpty
        ? const Text(
            "Информация отсутствует",
            style: TextStyle(fontSize: 18),
          )
        : DataTable(
            headingRowHeight: 0,
            columns: [
              DataColumn(
                  label: ConstrainedBox(
                      constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 3,
              ))),
              DataColumn(
                  label: ConstrainedBox(
                      constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 3,
              ))),
            ],
            rows: rows);

    return CustomCard(title: title, child: child);
  }

  Widget getVideoWidget(String? url) {
    if (url != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BetterPlayer.network(url,
            betterPlayerConfiguration:
            const BetterPlayerConfiguration(fit: BoxFit.contain)),
      );
    } else {
      return const SizedBox();
    }
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
          title: Text(animalCard.kind +": " + animalCard.sexToStr().toLowerCase()),
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
                    Api.mediaPath + animalCard.profileImagePath,
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
                                        Api.mediaPath +
                                        animalCard.imagePaths[index]),
                                  );
                                },
                                onPageChanged: (int index) {
                                  setState(() {
                                    _currentImage = index;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: animalCard.imagePaths.length,
                              ),
                              Visibility(
                                visible: animalCard.imagePaths.length > 1,
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
                                            i < animalCard.imagePaths.length;
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
                      getDataTable("Основная информация", animalCard),
                      getDataTable("Информация об отлове", catchData),
                      getVideoWidget(catchVideoUrl),
                      getDataTable("Информация о выпуске", releaseData),
                      getVideoWidget(releaseVideoUrl),
                      const SizedBox(height: 15)
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
