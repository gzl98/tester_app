import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/Utils.dart';

import 'package:tester_app/Pages/COT/COTQuestion.dart';

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

  Timer _timer;
  int currentTime = 0;
  final pointOneSec = const Duration(milliseconds: 100);
  COTQuestion _cotQuestion = COTQuestion(3, 0); // 出题器
  int currentState = 0; // 题目流程 0:显示悬浮窗 1:显示题目 2:显示准备 3:显示图形 4:答题正确 5:答题错误 6:答题完毕
  bool formal = false; // 是否为正式测试
  String imagePath = "images/v2.0/COT/0.png"; // 显示图片的路径
  bool success = true; // 答题正确或错误

  void callback(timer) {
    setState(() {
      if (currentTime == 0) {
      } else if (currentTime == 8) {
      }
      currentTime = (currentTime + 1) % 10;
    });
  }

  void showQuestions() {
    setState(() {
      currentState = 1;
    });

    _timer = Timer.periodic(pointOneSec, callback);
  }

  void prepareShow() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        currentState = 1;
      });
      showQuestions();
    });
  }

  Widget buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(150),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Text(
        "用时：",
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }

  Widget buildMainWidget() {
    return Stack(
      children: [
        currentState == 1
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: setHeight(300),
                    ),
                    Container(
                      width: setWidth(900),
                      height: setHeight(600),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 229, 229, 229),
                          borderRadius:
                              BorderRadius.all(Radius.circular(setWidth(50))),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 100, 100, 100),
                                blurRadius: setWidth(10),
                                offset: Offset(setWidth(1), setHeight(2)))
                          ]),
                      child: Center(
                        child: Image.asset(
                          "images/v2.0/COT/" +
                              _cotQuestion.getAnswer().toString() +
                              '.png',
                          width: setWidth(350),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(100),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "请记住屏幕中央的这个图形，当该图形出现时请尽可能快地按下屏幕中的按钮",
                            style: TextStyle(
                              fontSize: setSp(50),
                            ),
                          ),
                          SizedBox(
                            height: setHeight(30),
                          ),
                          Text(
                            "注意：请一定要又快又准地按下屏幕中的按钮，错误按键会使成绩下降",
                            style: TextStyle(
                                fontSize: setSp(50), color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: setHeight(50),
                    ),
                    Container(
                      width: setWidth(600),
                      height: setHeight(150),
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
                            currentState = 2;
                          });
                        },
                        child: Text(
                          "开始",
                          style: TextStyle(
                              color: Colors.white, fontSize: setSp(60)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: setHeight(300),
                    ),
                    Container(
                      width: setWidth(900),
                      height: setHeight(600),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 229, 229, 229),
                          borderRadius:
                              BorderRadius.all(Radius.circular(setWidth(50))),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 100, 100, 100),
                                blurRadius: setWidth(10),
                                offset: Offset(setWidth(1), setHeight(2)))
                          ]),
                      child: Center(
                        child: currentState == 2 ?
                            Text(
                                "准备",
                              style: TextStyle(fontSize: setSp(180), color: Colors.red,),
                            ) :
                            Image.asset(
                              imagePath,
                              width: setWidth(350),
                              fit: BoxFit.fill,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(100),
                    ),
                    Container(
                      width: setWidth(600),
                      height: setHeight(150),
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
                            currentState = 2;
                          });
                        },
                        child: Text(
                          "确认",
                          style: TextStyle(
                              color: Colors.white, fontSize: setSp(60)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
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
              formal ? "正式测试" : "熟悉操作方法",
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
                  currentState = 1;
                });
                _cotQuestion.generateAnswer();
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
                        currentState > 1 ? buildTopWidget() : Container(),
                        currentState > 1
                            ? Container(
                                width: maxWidth,
                                height: setHeight(5),
                                color: Colors.red,
                              )
                            : Container(),
                        Container(
                          width: maxWidth,
                          height: maxHeight - setHeight(155),
                          color: Color.fromARGB(255, 238, 241, 240),
                          child: currentState == 0
                              ? Container()
                              : buildMainWidget(),
                        ),
                      ]),
                ),
                currentState == 0 ? buildFloatWidget() : Container(),
              ],
            ),
          ),
        ));
  }
}
