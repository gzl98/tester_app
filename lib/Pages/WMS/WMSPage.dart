import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';

class WMSPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WMSPageState();
  }
}

class _WMSPageState extends State<WMSPage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  Widget sizeBox = SizedBox(
    width: setWidth(30),
    height: setHeight(30),
  );

  TextStyle titleFontStyle =
      TextStyle(fontSize: setSp(40), fontWeight: FontWeight.bold);
  TextStyle bigFontStyle =
      TextStyle(fontSize: setSp(60), fontWeight: FontWeight.w900);
  TextStyle questionFontStyle =
      TextStyle(fontSize: setSp(70), fontWeight: FontWeight.bold, shadows: [
    Shadow(
        // color: Color.fromARGB(100, 0, 0, 0),
        color: Colors.grey,
        offset: Offset(setWidth(2), setHeight(2)),
        blurRadius: setWidth(10)),
  ]);

  Widget buildLeft() {
    return Column(
      children: [
        Container(
          height: setHeight(160),
          child: Center(
            child: Text(
              "空间广度",
              style: questionFontStyle,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(left: setWidth(33)),
            children: [
              Text(
                "题目规则：\n\t\t\t\t本题目主要考察空间记忆能力，当测试开始时，您需要记住方块亮起的顺序，之后按照相同或相反的顺序依次点击，点击顺序完全正确得\t\t1分，否则不得分，共32组测试，预计用时20分钟。",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: setSp(45)),
              ),
            ],
          ),
        ),
        Container(
          // color: Colors.amber,
          height: setHeight(200),
          child: Center(
            child: Text(
              "得分：20 / 32",
              style: bigFontStyle,
            ),
          ),
        ),
        Container(
          // color: Colors.amber,
          height: setHeight(150),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              "倒计时：200秒",
              style: bigFontStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTitle() {
    return Container(
        padding: EdgeInsets.only(
          left: setWidth(40),
          right: setWidth(40),
        ),
        width: setWidth(1920),
        height: setHeight(90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '姓名：Andrew',
              style: titleFontStyle,
            ),
            Text(
              '年龄：22',
              style: titleFontStyle,
            ),
            Text(
              '总答题次数：121',
              style: titleFontStyle,
            ),
          ],
        ));
  }

  Widget buildNextButton() {
    return Center(
      child: Container(
        width: setWidth(1960),
        height: setHeight(90),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
            elevation: MaterialStateProperty.all(setWidth(2)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(20))),
            )),
          ),
          child: Text(
            "下 一 题",
            style: TextStyle(
              fontSize: setSp(44),
              fontWeight: FontWeight.w900,
            ),
          ),
          onPressed: () {
            // Navigator.pushNamed(context, '/Maze');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: Container(
          color: Colors.white54,
          width: maxWidth,
          height: maxHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: buildLeft(),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: setWidth(3),
                    ),
                  ],
                ),
                width: setWidth(560),
                height: maxHeight,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTitle(),
                  Container(
                    width: setWidth(2000),
                    // color: Colors.blue,
                    height: setHeight(1400),
                  ),
                  buildNextButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
