import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/Pages/NumberReasoning/NumberReasoningQuestion.dart';
import 'package:tester_app/Pages/WMS/WMSQuestion.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/questions.dart';

import 'CountDownView.dart';

class NumberReasoningPage extends StatefulWidget {
  static const routerName = "/NumberReasoningPage";

  @override
  State<StatefulWidget> createState() {
    return NumberReasoningPageState();
  }
}

class NumberReasoningPageState extends State<NumberReasoningPage> {
  bool finishedTest = false;
  Timer _timer; //计时器
  double currentTime = 2000, totalTime = 2000; //总时间20秒
  NumberReasoningQuestion numberReasoningQuestion =
      NumberReasoningQuestion(); //初始化出题器
  final duration = const Duration(milliseconds: 10); //定义0.01秒的Duration
  //记录答题信息
  List questionList = [];
  List questionIndexList = [];
  List answerList = [];

  List questionNumbersList;
  List choiceList;
  int questionIndex; //指示当前缺省的数字索引

  int chooseNum = -1;
  int score = 0;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(duration, callback);
    });
    getNextQuestion();
    super.initState();
  }

  void getNextQuestion() {
    setState(() {
      questionNumbersList = numberReasoningQuestion.getQuestion();
      choiceList = numberReasoningQuestion.getChoiceList();
      questionIndex = numberReasoningQuestion.questionIndex;
      //记录答题信息
      questionList.add(questionNumbersList);
      questionIndexList.add(questionIndex);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  //定时器回调函数
  void callback(timer) {
    setState(() {
      currentTime--;
      if (currentTime == 0) {
        _timer.cancel();
        //  答题结束
      }
    });
  }

  List<Widget> buildQuestionNumbers() {
    Text symbol = Text(
      ">>",
      style: TextStyle(
          color: Colors.white,
          fontSize: setSp(90),
          fontWeight: FontWeight.bold),
    );
    List<Widget> numbers = [];
    for (int i = 0; i < questionNumbersList.length; ++i) {
      Text number = Text(
        questionNumbersList[i].toString(),
        style: TextStyle(
            color: Colors.white,
            fontSize: setSp(150),
            fontWeight: FontWeight.bold),
      );
      if (i != 0) {
        numbers.add(Container(
          alignment: Alignment.center,
          width: setWidth(200),
          height: setHeight(200),
          child: symbol,
        ));
      }
      numbers.add(Container(
        alignment: Alignment.center,
        width: setWidth(200),
        height: setHeight(200),
        child: questionIndex == i
            ? Text(
                "?",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: setSp(160),
                    fontWeight: FontWeight.bold),
              )
            : number,
      ));
      // numbers.add(sizedBox);
    }
    return numbers;
  }

  List<Widget> buildChoiceButtons() {
    SizedBox sizedBox = SizedBox(width: setWidth(100));
    List<Widget> buttons = [SizedBox(width: setWidth(120)), sizedBox];
    for (int num in choiceList) {
      TextButton button = TextButton(
        onPressed: () {
          buttonClicked(num);
        },
        child: Text(
          num.toString(),
          style: TextStyle(
              color: Colors.black,
              fontSize: setSp(86),
              fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(setWidth(8)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(setWidth(20))),
          )),
        ),
      );
      buttons.add(
        Container(
          // color: Colors.red,
          width: setWidth(300),
          height: setHeight(220),
          child: Stack(children: [
            Container(
              width: setWidth(200),
              height: setHeight(200),
              child: button,
            ),
            chooseNum == num
                ? Container(
                    margin: EdgeInsets.only(
                        top: setHeight(60), left: setWidth(100)),
                    child: Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        num == numberReasoningQuestion.currentAnswer
                            ? "images/v2.0/correct.png"
                            : "images/v2.0/wrong.png",
                        width: setWidth(170),
                      ),
                    ),
                  )
                : Container(),
          ]),
        ),
      );
      buttons.add(sizedBox);
    }
    return buttons;
  }

  void buttonClicked(value) {
    if (value == numberReasoningQuestion.currentAnswer) {
      //回答正确
      score++;
    } else {
      //回答错误
    }
    setState(() {
      answerList.add(value);
      chooseNum = value;
    });
    if (numberReasoningQuestion.isEnd()) {
      _timer.cancel();
      Future.delayed(Duration(seconds: 1), () {
        //提交跳转
        setState(() {
          finishedTest = true;
        });
      });
    } else {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          chooseNum = -1;
        });
        getNextQuestion();
      });
    }
  }

  Widget buildMainWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: setWidth(30)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // color: Colors.red,
              width: setWidth(2000),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "请推算出",
                  ),
                  TextSpan(
                      text: " ? ",
                      style: TextStyle(color: Colors.red, fontSize: setSp(90))),
                  TextSpan(text: "处的数字是多少"),
                ]),
                style: TextStyle(
                  // height: setHeight(3.5),
                  fontSize: setSp(80),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: setHeight(220)),
            Row(children: buildQuestionNumbers()),
            SizedBox(height: setHeight(110)),
            Container(
              width: setWidth(2000),
              height: setHeight(5),
              color: Colors.white,
            ),
            SizedBox(height: setHeight(150)),
            Row(children: buildChoiceButtons()),
            SizedBox(height: setHeight(250)),
          ],
        ),
        SizedBox(width: setWidth(100)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: setHeight(600),
            ),
            Container(
                margin: EdgeInsets.only(left: setHeight(30)),
                child: CustomPaint(
                  painter: CountDownView(
                      currentTime, totalTime, setWidth(60), setHeight(1050)),
                )),
            Container(
              // color: Colors.white,
              margin: EdgeInsets.only(top: setHeight(550)),
              child: Image.asset(
                "images/v3.0/alarm.png",
                height: setHeight(140),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBackgroundWidget() {
    return Positioned(
      child: Image.asset(
        "images/v3.0/blackBoard2.jpg",
        fit: BoxFit.fill,
        width: maxWidth,
      ),
    );
  }

  Widget buildResultWidget() {
    return Stack(
      children: [
        Container(
          width: maxWidth,
          height: maxHeight,
          child: Image.asset(
            "images/v3.0/result.png",
            fit: BoxFit.fill,
          ),
        ),
        Center(
          child: Container(
              // color: Colors.red,
              width: setWidth(1000),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: setHeight(160)),
                  Row(
                    children: [
                      Text(
                        "                    正确数 : ",
                        style: TextStyle(
                          fontSize: setSp(60),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        score.toString() + "个",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: setSp(64),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: setHeight(20)),
                  Row(
                    children: [
                      Text(
                        "                    正确率 : ",
                        style: TextStyle(
                          fontSize: setSp(60),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (100 * score ~/ answerList.length).toString() + "% ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: setSp(64),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ((totalTime - currentTime) ~/ 100).toString() + "s",
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: setSp(100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        Positioned(
          bottom: setHeight(100),
          left: (maxWidth - setWidth(400)) / 2,
          child: Container(
            width: setWidth(400),
            height: setHeight(150),
            child: TextButton(
              onPressed: () {
                testFinishedList[questionIdNumberReasoning] = true;
                Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (route) => false);
              },
              child: Text(
                "继 续",
                style: TextStyle(
                    fontSize: setSp(80),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: setWidth(5))],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff97cc42), Color(0xff5e9a01)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(setWidth(20))),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => showQuitDialog(context),
        child: Scaffold(
          body: finishedTest
              ? buildResultWidget()
              : Container(
                  // 主要背景
                  color: Colors.grey[100],
                  width: maxWidth,
                  height: maxHeight,
                  child: Stack(
                    children: [
                      buildBackgroundWidget(),
                      buildMainWidget(),
                    ],
                  ),
                ),
        ));
  }
}
