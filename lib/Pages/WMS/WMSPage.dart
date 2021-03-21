import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Fragments/QuestionInfoFragment.dart';
import 'package:tester_app/Pages/WMS/WMSQuestion.dart';
import 'package:tester_app/Utils/Utils.dart';

class WMSPage extends StatefulWidget {
  static const routerName = "/WMSPage";

  @override
  State<StatefulWidget> createState() {
    return WMSPageState();
  }
}

class WMSPageState extends State<WMSPage> {
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
    300,
    900,
    1610,
    400,
    1000,
    1500,
    140,
    630,
    1120,
    1610
  ];
  List<double> buttonY = [200, 125, 200, 500, 520, 615, 800, 1000, 950, 1000];

  int index;
  Timer _timer;
  int currentTime = 0;
  WMSQuestion _wmsQuestion = WMSQuestion();
  final pointOneSec = const Duration(milliseconds: 100);
  ButtonState buttonState = ButtonState.showQuestion;
  bool success = true;
  Map nextButtonText = {
    ButtonState.showQuestion: "开 始 做 题",
    ButtonState.showingQuestion: "请观察方块亮起顺序",
    ButtonState.nextQuestion: "下 一 题",
    ButtonState.doingQuestion: "请按照顺序点击方块",
  };

  void callback(timer) {
    setState(() {
      if (currentTime == 0) {
        if (_wmsQuestion.hasNextIndex()) {
          index = _wmsQuestion.getNextQuestion();
        } else {
          _timer.cancel();
          index = null;
          buttonState = ButtonState.doingQuestion;
          _wmsQuestion.resetIndex();
        }
      } else if (currentTime == 8) {
        index = null;
      }
      currentTime = (currentTime + 1) % 10;
    });
  }

  void showQuestions() {
    setState(() {
      buttonState = ButtonState.showingQuestion;
    });
    _wmsQuestion.generateRandomQuestionList();
    _timer = Timer.periodic(pointOneSec, callback);
  }

  List<Widget> buildClickedButtons() {
    List<Widget> buttons = [];
    for (int i = 0; i < 10; i++) {
      ElevatedButton button = ElevatedButton(
        onPressed: () => buttonClicked(i),
        child: Text(
          (i + 1).toString(),
          style: TextStyle(fontSize: setSp(75), fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              i == index ? Colors.amber : Colors.blue[700]),
          elevation: MaterialStateProperty.all(setWidth(10)),
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

  void buttonClicked(int index) {
    if (buttonState != ButtonState.doingQuestion) return;
    if (_wmsQuestion.hasNextIndex()) {
      if (index != _wmsQuestion.getNextQuestion()) {
        setState(() {
          success = false;
          buttonState = _wmsQuestion.questionAllDone()
              ? ButtonState.nextQuestion
              : ButtonState.showQuestion;
        });
        showMessageDialog(context, "回答错误！");
      }
      if (_wmsQuestion.currentQuestionIsDone()) {
        setState(() {
          success = false;
          buttonState = _wmsQuestion.questionAllDone()
              ? ButtonState.nextQuestion
              : ButtonState.showQuestion;
        });
        showMessageDialog(context, "回答正确！");
      }
    }
  }

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
              child: Stack(
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Container(
                      width: maxWidth,
                      height: setHeight(200),
                      color: Color.fromARGB(255, 48, 48, 48),
                    ),
                    buildMainWidget(),
                  ]),
                ],
              )),
        ));
  }
}

enum ButtonState {
  showQuestion,
  showingQuestion,
  doingQuestion,
  doingQuestionDone,
  nextQuestion,
}
