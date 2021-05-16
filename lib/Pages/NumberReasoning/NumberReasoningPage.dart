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
    SizedBox sizedBox = SizedBox(width: setWidth(200));
    List<Widget> buttons = [sizedBox];
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
      buttons.add(Container(
        width: setWidth(200),
        height: setHeight(200),
        child: button,
      ));
      buttons.add(sizedBox);
    }
    return buttons;
  }

  void buttonClicked(value) {
    if (value == numberReasoningQuestion.currentAnswer) {
      //回答正确

    } else {
      //回答错误
    }
    setState(() {
      answerList.add(value);
    });
    getNextQuestion();
    if (numberReasoningQuestion.isEnd()) {
      //提交跳转
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
            SizedBox(height: setHeight(110)),
            Row(children: buildChoiceButtons()),
            SizedBox(height: setHeight(300)),
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
                buildBackgroundWidget(),
                buildMainWidget(),
              ],
            ),
          ),
        ));
  }
}
