import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';

import '../QuestionInfoFragment.dart';

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

  TextStyle userInfoTitleFontStyle = TextStyle(
      fontSize: setSp(42),
      fontWeight: FontWeight.bold,
      // color: Colors.red[400],
      color: Color.fromARGB(255, 253, 97, 94),
      shadows: [
        Shadow(
            color: Colors.grey,
            offset: Offset(setWidth(1.5), setHeight(1.5)),
            blurRadius: setWidth(1.5)),
      ]);
  TextStyle scoreAndTimeFontStyle =
      TextStyle(fontSize: setSp(60), fontWeight: FontWeight.w900, shadows: [
    Shadow(
        color: Colors.grey,
        offset: Offset(setWidth(1), setHeight(1)),
        blurRadius: setWidth(5)),
  ]);
  TextStyle questionTitleFontStyle = TextStyle(
      fontSize: setSp(70),
      fontWeight: FontWeight.bold,
      color: Colors.lightBlue,
      shadows: [
        Shadow(
            // color: Color.fromARGB(100, 0, 0, 0),
            color: Colors.grey,
            offset: Offset(setWidth(2), setHeight(2)),
            blurRadius: setWidth(8)),
      ]);
  TextStyle questionContentFontStyle =
      TextStyle(fontSize: setSp(45), height: setHeight(4));

  Widget buildLeft() {
    return Column(
      children: [
        Container(
          height: setHeight(160),
          child: Center(
            child: Text(
              "空间广度",
              style: questionTitleFontStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: setWidth(33)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "题目规则：",
              style: questionContentFontStyle,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: setWidth(33)),
            child: Text(
              "\t\t\t\t本题目主要考察空间记忆能力，当测试开始时，您需要记住方块亮起的顺序，之后按照相同或相反的顺序依次点击，点击顺序完全正确得一分，否则不得分，共32组测试，预计用时20分钟。",
              style: questionContentFontStyle,
            ),
          ),
        ),
        Container(
          // color: Colors.amber,
          height: setHeight(200),
          child: Center(
            child: Text(
              "得分：20 / 32",
              style: scoreAndTimeFontStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget buildTitle() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(
          left: setWidth(40),
          right: setWidth(40),
        ),
        width: setWidth(2000),
        height: setHeight(90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '姓名：Andrew',
              style: userInfoTitleFontStyle,
            ),
            Text(
              '年龄：22',
              style: userInfoTitleFontStyle,
            ),
            Text(
              '总答题次数：121',
              style: userInfoTitleFontStyle,
            ),
          ],
        ));
  }

  Widget buildNextButton() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: setHeight(15)),
        width: setWidth(1960),
        height: setHeight(95),
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
            setState(() {
              score++;
            });
            // Navigator.pushNamed(context, '/Maze');
          },
        ),
      ),
    );
  }

  Widget buildMainWidget() {
    return Container(
      // color: Colors.redAccent,
      child: Stack(
        children: buildClickedButtons(),
      ),
    );
  }

  List<double> buttonX = [
    630,
    1120,
    1610,
    450,
    1120,
    1610,
    140,
    630,
    1120,
    1610
  ];
  List<double> buttonY = [125, 125, 125, 500, 615, 615, 800, 1000, 950, 1100];

  List<Widget> buildClickedButtons() {
    List<Widget> buttons = [];
    for (int i = 0; i < 10; i++) {
      ElevatedButton button = ElevatedButton(
        onPressed: () => buttonClicked(i),
        child: Text((i + 1).toString()),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
          elevation: MaterialStateProperty.all(setWidth(2)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(setWidth(20))),
          )),
        ),
      );
      Positioned positioned = Positioned(
        left: setWidth(buttonX[i]),
        top: setHeight(buttonY[i]),
        child: Container(
          width: setWidth(200),
          height: setHeight(200),
          child: button,
        ),
      );
      buttons.add(positioned);
    }
    return buttons;
  }

  void buttonClicked(int index) {}

  double score = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: Container(
          color: Colors.grey[100],
          width: maxWidth,
          height: maxHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // child: buildLeft(),
                child: QuestionInfoFragment(
                  questionTitle: "空间广度",
                  questionContent:
                      "\t\t\t\t本题目主要考察空间记忆能力，当测试开始时，您需要记住方块亮起的顺序，之后按照相同或相反的顺序依次点击，点击顺序完全正确得一分，否则不得分，共32组测试，预计用时20分钟。",
                  score: score,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 230, 230),
                  // color: Colors.grey[200],
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
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTitle(),
                    Container(
                      width: setWidth(2000),
                      height: setHeight(1400),
                      child: Center(
                        child: Container(
                          width: setWidth(1960),
                          height: setHeight(1350),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]),
                          ),
                          child: buildMainWidget(),
                        ),
                      ),
                    ),
                    buildNextButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
