import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';

class Item {
  int status;
  double size;
  double x;
  double y;
  double speed;
  double startX;
  double startY;
  double endX;
  double endY;
  int counter = 0;
  int frameIndex = 0;
  VoidCallback callback;
  List<ui.Image> pictures;

  @override
  String toString() {
    return "X: $x, Y: $y";
  }

  Item(this.x, this.y, this.startX, this.startY, this.endX, this.endY, this.speed, this.size, this.callback, this.pictures, this.status);

  void moveToXY(double newX, double newY) {
    x = newX;
    y = newY;
  }

  void move() {
    double xx = endX - startX;
    double yy = endY - startY;
    if (xx < 0 && x < endX) {
      return;
    }
    if (xx > 0 && x > endX) {
      return;
    }
    if (yy < 0 && y < endY) {
      return;
    }
    if (yy > 0 && y > endY) {
      return;
    }
    if (x == endX && y == endY) {
      return;
    }
    if (status == 1) {
      if (xx.abs() < yy.abs()) {
        if (xx == 0) {
          x = x;
        } else {
          x = x + (xx/xx.abs()) * speed * (xx.abs()/yy.abs());
        }
        y = y + (yy/yy.abs()) * speed;
      } else {
        x = x + (xx/xx.abs()) * speed;
        if (yy == 0) {
          y = y;
        } else {
          y = y + (yy/yy.abs()) * speed * (yy.abs()/xx.abs());
        }
      }
    }
  }

  paint(Canvas canvas, Size size) async {
    if (counter == 5) {
      frameIndex = (frameIndex + 1) % pictures.length;
      counter = 0;
    } else {
      counter += 1;
    }
    canvas.drawImage(pictures[frameIndex], Offset(x, y), new Paint());
  }
}

class GameEngine extends StatefulWidget {
  final List<Item> itemList;
  final bool start;

  GameEngine({Key key, this.itemList, this.start}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return GameEngineState();
  }
}

class GameEngineState extends State<GameEngine> {
  bool start = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Timer.periodic(Duration(microseconds: 10), (timer) {
      if (widget.start) {
        setState(() {
          for (Item item in widget.itemList) {
            item.move();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        foregroundPainter: GameEnginePainter(items: widget.itemList),
        child: RepaintBoundary(
          child: Image.asset('images/Goose/bg.jpg', width: setWidth(2560), height: setHeight(1600), fit: BoxFit.cover,),
        )
      ),
    );
  }
}

class GameEnginePainter extends CustomPainter {
  final List<Item> items;

  GameEnginePainter({this.items});

  @override
  void paint(Canvas canvas, Size size) {
    for (Item item in items) {
      item.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}