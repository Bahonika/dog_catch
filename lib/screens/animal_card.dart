import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  const AnimalCard({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item $index'),
      ),
      body: Center(
        child: Hero(
          tag: index,
          child: Container(
            color: const Color.fromRGBO(159, 72, 72, 1),
            child: Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
