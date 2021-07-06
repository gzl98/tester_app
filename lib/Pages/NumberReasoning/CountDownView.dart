import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';

class CountDownView extends CustomPainter {
  CountDownView(this.value, this.maxValue, this.width, this.height);

  double value;
  double maxValue;
  double width;
  double height;

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = setWidth(4)
      ..style = PaintingStyle.stroke;
    //绘制边框
    canvas.drawRRect(
        RRect.fromLTRBR(0, -height / 2 - setWidth(3), width,
            height / 2 + setWidth(3), Radius.circular(setWidth(10))),
        _paint);
    _paint.color = Colors.red;
    _paint.style = PaintingStyle.fill;
    if (value < 0) value = 0;
    if (value > maxValue) value = maxValue;
    canvas.drawRRect(
        RRect.fromLTRBR(setWidth(4), height / 2 - value / maxValue * height,
            width - setWidth(4), height / 2, Radius.circular(setWidth(10))),
        _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
