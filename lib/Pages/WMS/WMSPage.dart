import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Fragments/QuestionInfoFragment.dart';
import 'package:tester_app/Pages/WMS/WMSQuestion.dart';
import 'package:tester_app/Utils/Utils.dart';

class WMSPage extends StatefulWidget {
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

  //TODO:定义题目名称，规则
  final String questionTitle = "空间广度";
  final String questionContent =
      "\t\t\t\t本题目主要考察空间记忆能力，当测试开始时，您需要记住方块亮起的顺序，之后按照相同或相反的顺序依次点击，点击顺序完全正确得一分，否则不得分，共32组测试，预计用时20分钟。";

  //TODO：根据情况定义分数和时间，不定义即为不显示
  int score = 30;
  int remainingTime;

  //TODO: 定义主体布局，长宽分别为1960*1350像素，设置大小时统一使用setWidth和setHeight，setSp函数，使用maxWidth和maxHeight不需要使用上述3个函数
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

  //TODO: 定义下一题按钮的函数体
  onNextButtonPressed() {
    switch (buttonState) {
      case ButtonState.showQuestion:
        // showing questions
        showQuestions();
        break;
      case ButtonState.showingQuestion:
        break;
      case ButtonState.doingQuestion:
        break;
      case ButtonState.doingQuestionDone:
        break;
      case ButtonState.nextQuestion:
        // submit and goto next question
        showMessageDialog(context, "提交成功");
        break;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //左侧题目信息Fragment+
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
                  nextButtonText: buttonState != ButtonState.showQuestion
                      ? nextButtonText[buttonState]
                      : nextButtonText[buttonState] +
                          _wmsQuestion.getCurrentLength().toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ButtonState {
  showQuestion,
  showingQuestion,
  doingQuestion,
  doingQuestionDone,
  nextQuestion,
}
