import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';

import '../../Fragments/QuestionInfoFragment.dart';

class WMSPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WMSPageState();
  }
}

class WMSPageState extends State<WMSPage> {
  final String questionTitle = "空间广度";
  final String questionContent =
      "\t\t\t\t本题目主要考察空间记忆能力，当测试开始时，您需要记住方块亮起的顺序，之后按照相同或相反的顺序依次点击，点击顺序完全正确得一分，否则不得分，共32组测试，预计用时20分钟。";
  double score = 30;
  int remainingTime = 200;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
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

  onNextButtonPressed() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: Container(
          // 主要背景
          color: Colors.grey[100],
          width: maxWidth,
          height: maxHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //左侧题目信息Fragment
                child: QuestionInfoFragment(
                  questionTitle: questionTitle,
                  questionContent: questionContent,
                  score: score,
                  remainingTime: remainingTime,
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
                //右侧主要布局Fragment
                child: MainFragment(
                  mainWidget: buildMainWidget(),
                  onNextButtonPressed: onNextButtonPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
