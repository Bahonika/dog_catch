import 'package:flutter/material.dart';

class SpinKit extends StatefulWidget {
  const SpinKit({Key? key}) : super(key: key);

  @override
  _SpinKitState createState() => _SpinKitState();
}

class _SpinKitState extends State<SpinKit> with SingleTickerProviderStateMixin{
  late AnimationController animation;
  @override
  void initState() {
    animation = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    animation.repeat();
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(animation),
      child: Container(
        height: 50,
        width: 50,
        color: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        child: Container(
          height: 15,
          width: 15,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
