import 'package:animation2d/ball.dart';
import 'package:animation2d/bat.dart';
import 'package:flutter/material.dart';

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin{
  Animation<double>? animation;
  AnimationController? controller;

  double? width;
  double? height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller!);
    animation!.addListener(() {setState(() {
      posX++;
      posY++;
    });});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width! / 5;
      batHeight = height! / 20;
      return Stack(
        children: [
          Positioned(child: Ball(), top: 0),
          Positioned(
            child: Bat(batWidth, batHeight),
            bottom: 0,
          ),
        ],
      );
    });
  }
}
