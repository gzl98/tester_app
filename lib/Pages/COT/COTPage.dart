import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/Utils.dart';

import 'package:tester_app/Pages/COT/COTQuestion.dart';

enum CurrentState {
  questionBegin, //显示操作浮窗
  questionPrepare, //显示准备字样
  showingQuestion, //
  doingQuestion, //开始答题
  questionCorrect, //答题正确
  questionWrong, //答题错误
  questionAllDone //全部答题完毕
}

class COTPage extends StatefulWidget {
  static const routerName = "/COTPage";

  @override
  State<StatefulWidget> createState() {
    return COTPageState();
  }
}

class COTPageState extends State<COTPage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  int index;
  Timer _timer;
  int currentTime = 0;
  COTQuestion _cotQuestion = COTQuestion(0, 0);
  final pointOneSec = const Duration(milliseconds: 100);
  CurrentState currentState = CurrentState.questionBegin;
  bool success = true;

  //中间显示的文字
  Map showText = {
    CurrentState.questionPrepare: "准 备",
    CurrentState.showingQuestion: "题 目 播 放 中...",
    CurrentState.doingQuestion: "开 始 作 答",
    CurrentState.questionCorrect: "开 始 作 答",
    CurrentState.questionWrong: "开 始 作 答",
  };

  //中间显示文字的颜色
  Map showTextColor = {
    CurrentState.questionPrepare: Colors.deepOrangeAccent,
    CurrentState.showingQuestion: Colors.blue[400],
    CurrentState.doingQuestion: Colors.blue[400],
  };

  void callback(timer) {
    setState(() {
      if (currentTime == 0) {

      } else if (currentTime == 8) {
        index = null;
      }
      currentTime = (currentTime + 1) % 10;
    });
  }

  void showQuestions() {
    setState(() {
      currentState = CurrentState.showingQuestion;
    });

    _timer = Timer.periodic(pointOneSec, callback);
  }

  void prepareShow() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        currentState = CurrentState.showingQuestion;
      });
      showQuestions();
    });
  }

  Widget buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(200),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Text(
        "长度：3位",
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }

  Widget buildMainWidget() {
    return Stack();
  }

  Widget buildFloatWidget() {
    return Container(
      width: maxWidth,
      height: maxHeight,
      color: Color.fromARGB(220, 150, 150, 150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: setHeight(100),
          ),
          Container(
            width: setWidth(700),
            height: setHeight(700),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.all(Radius.circular(setWidth(50))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      blurRadius: setWidth(10),
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Text(
              "熟悉操作方法",
              style: TextStyle(fontSize: setSp(60)),
            ),
          ),
          SizedBox(
            height: setHeight(250),
          ),
          Container(
            width: setWidth(500),
            height: setHeight(120),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff418ffc), Color(0xff174cfc)],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(setWidth(1), setHeight(1)),
                    blurRadius: setWidth(5),
                  )
                ]),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                setState(() {
                  currentState = CurrentState.questionPrepare;
                });
                prepareShow();
              },
              child: Text(
                "开始",
                style: TextStyle(color: Colors.white, fontSize: setSp(60)),
              ),
            ),
          ),
        ],
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
                Container(
                  width: maxWidth,
                  height: maxHeight,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildTopWidget(),
                        Container(
                          width: maxWidth,
                          height: setHeight(5),
                          color: Colors.red,
                        ),
                        Container(
                          width: maxWidth,
                          height: maxHeight - setHeight(205),
                          color: Color.fromARGB(255, 238, 241, 240),
                          child: currentState == CurrentState.questionBegin
                              ? Container()
                              : buildMainWidget(),
                        ),
                      ]),
                ),
                currentState == CurrentState.questionBegin
                    ? buildFloatWidget()
                    : Container(),
                currentState == CurrentState.questionCorrect
                    ? Center(
                  child: Container(
                    // color: Color(0xff3f882b),
                      margin: EdgeInsets.only(top: setHeight(100)),
                      child: Opacity(
                        opacity: 0.85,
                        child: Image.asset(
                          "images/v2.0/correct.png",
                          width: setWidth(170),
                        ),
                      )),
                )
                    : Container(),
                currentState == CurrentState.questionWrong
                    ? Center(
                  child: Container(
                    // color: Color(0xff3f882b),
                      margin: EdgeInsets.only(top: setHeight(100)),
                      child: Opacity(
                        opacity: 0.85,
                        child: Image.asset(
                          "images/v2.0/wrong.png",
                          width: setWidth(170),
                        ),
                      )),
                )
                    : Container(),
              ],
            ),
          ),
        ));
  }
}