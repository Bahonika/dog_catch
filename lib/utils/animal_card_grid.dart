import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../data/entities/animal_card.dart';
import '../data/entities/status.dart';
import '../data/repository/abstract/api.dart';
import '../screens/animal_card_view.dart';

class AnimalCardGrid extends StatefulWidget {
  const AnimalCardGrid({Key? key,
                        required this.fetchCallback,
                        required this.isLastCallback})
      : super(key: key);

  final Future<List<AnimalCard>> Function(int) fetchCallback;
  final bool Function() isLastCallback;

  @override
  State<StatefulWidget> createState() => AnimalCardGridState();
}

class AnimalCardGridState extends State<AnimalCardGrid>{

  final _pagingController = PagingController<int, AnimalCard>(
       firstPageKey: 1,
  );

  @override
  void initState() {
    // 3
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageIndex) async{
    final cards = await widget.fetchCallback(pageIndex);

    if (widget.isLastCallback()) {
      // 3
      _pagingController.appendLastPage(cards);
    } else {
      _pagingController.appendPage(cards, pageIndex + 1);
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Color getColorForStatus(Status status) => status == Status.released
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.secondary;

  Decoration createStatusDecoration(AnimalCard animalCard) {
    return BoxDecoration(
      color: getColorForStatus(animalCard.status),
      border: Border(
        bottom: BorderSide(
          width: 10,
          color: getColorForStatus(animalCard.status),
        ),
      ),
    );
  }

  Widget getItem(context, animalCard, index){
    return Hero(
        tag: index,
        child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AnimalCardView(
                            index: index,
                            data: animalCard))),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                  ),
                  child: Container(
                      decoration:
                      createStatusDecoration(animalCard),
                      height: MediaQuery.of(context)
                          .size
                          .width *
                          0.41,
                      width: MediaQuery.of(context)
                          .size
                          .width *
                          0.41,
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.only(
                          bottomRight:
                          Radius.circular(25),
                        ),
                        child: Image.network(
                          "https://" +
                              Api.siteRoot +
                              animalCard.profileImagePath,
                          fit: BoxFit.cover,
                        ),
                      ))),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(
      // 2
          () => _pagingController.refresh(),
    ),
      child:

      PagedGridView(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.05),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<AnimalCard>(
          itemBuilder: getItem
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
          mainAxisSpacing: MediaQuery.of(context).size.width * 0.05,
        )
    ));
  }

}


