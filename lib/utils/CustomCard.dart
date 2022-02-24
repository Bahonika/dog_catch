import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget{

  final String? title;
  final Widget child;

  const CustomCard({Key? key, this.title, required this.child}) :
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                    ],
        ),
      child: Column(
        children: [
          if(title != null) Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(title!,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 1.0)
                ),
                textAlign: TextAlign.center),
            decoration:  const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Color.fromRGBO(118, 137, 110, 1.0)
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: child
          )
        ],
      )
    );
  }

}