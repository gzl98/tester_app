import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';

Widget buildWordCard(String text,Color color) {
  var circleBoxDecoration = new BoxDecoration(
    border: new Border.all(color: Color(0xFFB9BBBB), width: 0.5), // 边色与边宽度
    borderRadius: new BorderRadius.circular(setWidth(25)), // 圆角度
    color: Color(0xFFE2E4E6),
    //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
  );
  var cardWordStyle = TextStyle(
    fontSize: setSp(250),
    color: color,
  );
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(top: setHeight(0)),
    child: Text(
      text,
      style: cardWordStyle,
    ),
    decoration: circleBoxDecoration,
  );
}

Widget buildSecondWordCard(String text,Color color){
  return Container(
      alignment: Alignment.center,
      width: maxWidth,
      height: setHeight(1000),
      child: Container(
        margin: EdgeInsets.only(top: setHeight(400)),
        alignment: Alignment.center,
        width: setWidth(800),
        height: setHeight(550),
        child: buildWordCard(text, color),
      ),
  );
}