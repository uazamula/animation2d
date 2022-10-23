import 'dart:math';

import 'package:animation2d/ball.dart';
import 'package:animation2d/bat.dart';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double increment = 5;

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  Animation<double>? animation;
  AnimationController? controller;

  double? width = 0;
  double? height = 0;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;

  double randX = 1;
  double randY = 1;

  int score = 0;
  bool isBuilt = false;

  @override
  void initState() {
    posX = 0;
    posY = 50;
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller!);
    animation!.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += (increment * randX).round()
            : posX -= (increment * randX).round();
        (vDir == Direction.down)
            ? posY += (increment * randY).round()
            : posY -= (increment * randY).round();
      });
      if (isBuilt) {
        checkBorders();
      }
    });
    controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void checkBorders() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width! - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    // by init height=0
    if (posY >= height! - diameter - batHeight && vDir == Direction.down) {
      // check if the bat is here, otherwise loose
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() => score++);
      } else {
        controller!.stop();
        dispose();
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  void safeSetState(Function() function) {
    if (mounted && controller!.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      isBuilt = true; // added this
      batWidth = width! / 5;
      batHeight = height! / 20;
      return Stack(
        children: [
          Positioned(
            top: posY,
            left: posX,
            child: Ball(),
          ),
          Positioned(
            bottom: 0,
            left: batPosition,
            child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                child: Bat(batWidth, batHeight)),
          ),
          Positioned(
            top: 0,
            right: 24,
            child: Text('Score: ' + score.toString()),
          )
        ],
      );
    });
  }

  double randomNumber() {
    // 0.5..1.5
    var ran = Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }
}
