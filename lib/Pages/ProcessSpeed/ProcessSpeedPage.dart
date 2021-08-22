import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/Pages/FlashLight/FlashLightQuestion.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/questions.dart';

import 'ProcessSpeedQuestion.dart';

class ProcessSpeedPage extends StatefulWidget {
  static const routerName = "/ProcessSpeed";

  @override
  State<StatefulWidget> createState() {
    return ProcessSpeedPageState();
  }
}

class ProcessSpeedPageState extends State<ProcessSpeedPage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    //创建图片控件
    for (var x in alignmentList) {
      images.add(Image.asset(
        "images/v4.0/ProcessSpeed/image.png",
        width: setWidth(300),
        height: setWidth(300),
        fit: BoxFit.cover,
        alignment: Alignment(x, 0),
      ));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  List<bool> indexList = List.generate(6, (index) => false);
  int maxChoose = 2;
  Timer _timer; //计时器
  int currentTime = 0; //辅助计时器
  ProcessSpeedQuestion processSpeedQuestion =
      ProcessSpeedQuestion(); //初始化出题器，闪烁按钮个数为4
  final millisecond = const Duration(milliseconds: 1); //定义1毫秒的Duration
  final pointOneSec = const Duration(milliseconds: 100); //定义0.1秒的Duration
  CurrentState currentState = CurrentState.questionBegin; //初始化当前页面状态为Begin

  //保存五个图片的View List
  List<double> alignmentList = [-1.0, -0.5, 0.0005, 0.5, 1.005];
  List<Widget> images = [];
  List<int> imagesIndex = [0, 1, 2, 3, 4, 2];

  //中间显示的文字
  Map showText = {
    CurrentState.questionPrepare: "准 备",
  };

  //中间显示文字的颜色
  Map showTextColor = {
    CurrentState.questionPrepare: Colors.deepOrangeAccent,
  };

  //定时器回调函数
  void callback(timer) {
    setState(() {
      //递增计时器
      currentTime++;
    });
  }

  List questionList = [];
  List answerList = [];

  void showQuestions() {
    //开始展示题目
    setState(() {
      //设置当前状态为展示问题
      currentState = CurrentState.doingQuestion;
    });
    //获取新的题目
    imagesIndex = processSpeedQuestion.getNextQuestion();
    //记录当前题目
    questionList.add(imagesIndex);
    //启动计时器和callback函数
    _timer = Timer.periodic(millisecond, callback);
  }

  void prepareShowQuestion() {
    //准备展示题目
    Future.delayed(Duration(seconds: 1), () {
      //延时一秒后开始展示题目
      //调用展示题目函数
      showQuestions();
    });
  }

  void buttonClicked(index) {
    //触发方形按钮点击事件，index为按钮的id值
    if (currentState != CurrentState.doingQuestion)
      return; //如果不是开始答题状态，点击按钮没有效果
    if (indexList[index]) {
      //清除一个选中
      setState(() {
        indexList[index] = false;
        maxChoose++;
      });
    } else {
      if (maxChoose > 0) {
        //选中一个图片
        setState(() {
          indexList[index] = true;
          maxChoose--;
        });
        if (maxChoose == 0) {
          //进入答案判断
          int index1 = indexList.indexOf(true),
              index2 = indexList.lastIndexOf(true);
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              currentState =
                  questionList.last[index1] == questionList.last[index2]
                      ? CurrentState.questionCorrect
                      : CurrentState.questionWrong;
            });
          });
          _timer.cancel();
          Future.delayed(Duration(milliseconds: 1250), () {
            if (!processSpeedQuestion.questionAllDone()) {
              setState(() {
                currentState = CurrentState.questionPrepare;
                indexList[index1] = indexList[index2] = false;
                maxChoose = 2;
              });
              prepareShowQuestion();
            } else {
              //题目全部做完，显示结果页面
              setState(() {
                currentState = CurrentState.questionAllDone;
              });
            }
          });
        }
      }
    }
  }

  Widget buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140), right: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(150),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "当前题目：1/5",
          style: TextStyle(color: Colors.white, fontSize: setSp(55)),
        ),
      ]),
    );
  }

  Widget buildMainWidget() {
    List<Widget> children = [];
    for (int i = 0; i < imagesIndex.length; i++) {
      Widget button = Container(
          width: setWidth(400),
          height: setHeight(400),
          child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(setWidth(0))),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              shape: indexList[i]
                  ? MaterialStateProperty.all(ContinuousRectangleBorder(
                      side: BorderSide(
                          color: Colors.green[800], width: setWidth(18))))
                  : null,
            ),
            onPressed: () {
              buttonClicked(i);
            },
            child: images[imagesIndex[i]],
          ));
      children.add(button);
    }

    return Stack(
      children: [
        currentState == CurrentState.doingQuestion ||
                currentState == CurrentState.questionCorrect ||
                currentState == CurrentState.questionWrong
            ? Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: setHeight(180)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
              )
            : Container(),
        currentState == CurrentState.questionPrepare
            ? Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: setHeight(80)),
                  width: setWidth(820),
                  height: setHeight(120),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.35),
                        blurRadius: setWidth(5),
                        offset: Offset(setWidth(0), setHeight(3)),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
        currentState == CurrentState.questionPrepare
            ? Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: setHeight(80)),
                  alignment: Alignment.center,
                  width: setWidth(850),
                  height: setHeight(120),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 236, 239, 238),
                        Color.fromARGB(255, 250, 250, 250),
                        Color.fromARGB(255, 236, 239, 238),
                      ],
                    ),
                  ),
                  child: Text(
                    showText[currentState],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: setSp(70),
                        color: showTextColor[currentState]),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  double floatWindowRadios = 30;

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
                borderRadius: BorderRadius.all(
                    Radius.circular(setWidth(floatWindowRadios))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      blurRadius: setWidth(10),
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Text(
              "开始测试",
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
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                setState(() {
                  currentState = CurrentState.questionPrepare;
                });
                prepareShowQuestion();
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

  Widget buildResultFloatWidget() {
    TextStyle resultTextStyle = TextStyle(
        fontSize: setSp(45),
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey);
    return Container(
      width: maxWidth,
      height: maxHeight,
      color: Color.fromARGB(220, 45, 45, 45),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: setHeight(200)),
          Container(
            width: setWidth(800),
            height: setHeight(450),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.all(
                    Radius.circular(setWidth(floatWindowRadios))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      blurRadius: setWidth(10),
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Column(children: [
              Container(
                height: setHeight(100),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow()],
                  color: Color.fromARGB(255, 229, 229, 229),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(setWidth(floatWindowRadios)),
                      topRight: Radius.circular(setWidth(floatWindowRadios))),
                ),
                child: Text(
                  "测验结果",
                  style: TextStyle(
                      fontSize: setSp(50),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: setHeight(30)),
                height: setHeight(230),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: setHeight(30)),
                    Text("    正确数：" + "    ", style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text("    错误数：" + "    ", style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text("    正确率：" + "%    ", style: resultTextStyle),
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(height: setHeight(300)),
          Container(
            width: setWidth(500),
            height: setHeight(120),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.white,width: setWidth(1)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 253, 160, 60),
                  Color.fromARGB(255, 217, 127, 63)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(setWidth(1), setHeight(1)),
                  blurRadius: setWidth(5),
                )
              ],
            ),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                testFinishedList[questionIdFlashLight] = false;
                Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (route) => false);
              },
              child: Text(
                "结 束",
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
                          height: maxHeight - setHeight(155),
                          color: Color.fromARGB(255, 238, 241, 240),
                          child: currentState == CurrentState.questionBegin ||
                                  currentState == CurrentState.questionAllDone
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
                            margin: EdgeInsets.only(bottom: setHeight(20)),
                            child: Opacity(
                              opacity: 0.85,
                              child: Image.asset(
                                "images/v2.0/correct.png",
                                width: setWidth(400),
                              ),
                            )),
                      )
                    : Container(),
                currentState == CurrentState.questionWrong
                    ? Center(
                        child: Container(
                            margin: EdgeInsets.only(bottom: setHeight(20)),
                            child: Opacity(
                              opacity: 0.85,
                              child: Image.asset(
                                "images/v2.0/wrong.png",
                                width: setWidth(400),
                              ),
                            )),
                      )
                    : Container(),
                currentState == CurrentState.questionAllDone
                    ? buildResultFloatWidget()
                    : Container(),
                currentState == CurrentState.questionAllDone
                    ? Positioned(
                        right: setWidth(400),
                        bottom: 0,
                        child: Image.asset(
                          "images/v2.0/doctor_result.png",
                          width: setWidth(480),
                        ))
                    : Container(),
              ],
            ),
          ),
        ));
  }
}

enum CurrentState {
  questionBegin, //显示开始浮窗
  questionPrepare, //显示准备字样
  doingQuestion, //开始答题
  questionCorrect, //答题正确
  questionWrong, //答题错误
  questionAllDone //全部答题完毕
}
