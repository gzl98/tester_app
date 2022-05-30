import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/WMS/WMSQuestion.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/questions.dart';

class WMSSpacePage extends StatefulWidget {
  static const routerName = "/WMSSpacePage";

  @override
  State<StatefulWidget> createState() {
    return WMSSpacePageState();
  }
}

class WMSSpacePageState extends State<WMSSpacePage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  List<double> buttonX = [
    400,
    950,
    1450,
    2100,
    2050,
    250,
    650,
    1150,
    1550,
    1950
  ];
  List<double> buttonY = [330, 130, 330, 130, 530, 1130, 830, 1130, 830, 1080];

  int index, currentLen = 3; //高亮方形按钮的索引
  Timer _timer; //计时器
  int currentTime = 0; //辅助计时器你
  WMSQuestion _wmsQuestion = WMSQuestion(test: true); //初始化出题器
  final pointOneSec = const Duration(milliseconds: 100); //定义0.1秒的Duration
  CurrentState currentState = CurrentState.questionBegin; //初始化当前页面状态为Begin
  bool test = true; //是否为test阶段的标志
  bool reverse;

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
    CurrentState.questionCorrect: Colors.blue[400],
    CurrentState.questionWrong: Colors.blue[400],
  };

  //定时器回调函数
  void callback(timer) {
    setState(() {
      if (currentTime == 0) {
        //判断是否有下一道题
        if (_wmsQuestion.hasNextIndex()) {
          //获取下一道题，并进行高亮
          index = _wmsQuestion.getNextQuestion();
        } else {
          //取消定时器
          _timer.cancel();
          //清除高亮状态
          index = null;
          //改变当前状态为开始做题
          currentState = CurrentState.doingQuestion;
          //重置题目生成器的索引
          _wmsQuestion.resetIndex();
        }
      } else if (currentTime == 8) {
        //清除高亮状态，构成闪烁效果
        index = null;
      }
      //递增计时器
      currentTime = (currentTime + 1) % 10;
    });
  }

  List questionList = [];
  List answerList = [];

  void showQuestions() {
    //开始展示题目
    setState(() {
      //设置当前状态为展示问题
      currentState = CurrentState.showingQuestion;
    });
    //生成新的题目
    _wmsQuestion.generateRandomQuestionList();
    currentLen = _wmsQuestion.getCurrentLength();
    if (!test) {
      //记录当前题目
      questionList.add(_wmsQuestion.getQuestionList(reverse: reverse));
      answerList.add([]);
    }
    //启动计时器和callback函数
    _timer = Timer.periodic(pointOneSec, callback);
  }

  void prepareShowQuestion() {
    //准备展示题目
    Future.delayed(Duration(seconds: 1), () {
      //延时一秒后开始展示题目
      setState(() {
        //改变当前状态
        currentState = CurrentState.showingQuestion;
      });
      //调用展示题目函数
      showQuestions();
    });
  }

  List<Widget> buildClickedButtons() {
    List<Widget> buttons = [];
    for (int i = 0; i < 10; i++) {
      ElevatedButton button = ElevatedButton(
        onPressed: currentState == CurrentState.doingQuestion
            ? () => buttonClicked(i)
            : null,
        child: Container(),
        // Text(
        //   (i + 1).toString(),
        //   style: TextStyle(fontSize: setSp(75), fontWeight: FontWeight.bold),
        // ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              i == index ? Colors.blue[700] : Color.fromARGB(255, 98, 78, 75)),
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

  void buttonClicked(index) {
    //触发方形按钮点击事件，index为按钮的id值
    if (currentState != CurrentState.doingQuestion)
      return; //如果不是开始答题状态，点击按钮没有效果
    if (_wmsQuestion.hasNextIndex()) {
      //当前题目还没有答完
      if (!test) answerList.last.add(index);
      if (index != _wmsQuestion.getNextQuestion(reverse: reverse)) {
        //如果当前index不等于题目的答案，则进行判错
        setState(() {
          //修改状态
          currentState = CurrentState.questionWrong; //判错
          _wmsQuestion.questionWrong(); //判错
        });
        if (test) {
          Future.delayed(pointOneSec, () {
            Navigator.pushNamedAndRemoveUntil(
                context, TestNavPage.routerName, (route) => false);
          });
        } else if (_wmsQuestion.questionAllDone()) {
          //如果所有题目都回答完毕，则提交结果，并延迟0.1秒将状态改为“全部答完”
          Map map = {
            "question": questionList,
            "answer": answerList,
            "result": _wmsQuestion.result,
          };
          String text = json.encode(map);
          print(text);
          setAnswer(reverse ? questionIdWMSSpaceReverse : questionIdWMSSpace,
              score: _wmsQuestion.correctCounts, answerText: text);
          Future.delayed(pointOneSec, () {
            setState(() {
              currentState = CurrentState.questionAllDone;
            });
          });
        } else {
          //否则延迟0.1秒继续进行下一道题
          Future.delayed(pointOneSec, () {
            prepareShowQuestion();
          });
        }
      } else {
        //答题正确
        if (_wmsQuestion.currentQuestionIsDone()) {
          //当前题目答完，则进行判对
          setState(() {
            currentState = CurrentState.questionCorrect; //判对
            _wmsQuestion.questionCorrect();
          });
          if (_wmsQuestion.questionAllDone()) {
            //题目全部达答完
            if (test) {
              //如果为test阶段，则进入正式测试
              Future.delayed(pointOneSec, () {
                setState(() {
                  test = false; //更改test标志
                  _wmsQuestion = WMSQuestion(test: false); //重新创建测试题
                  currentState = CurrentState.questionBegin; //恢复初始状态
                });
              });
            } else {
              //正式测试阶段
              //如果所有题目都回答完毕，则提交结果，并延迟0.1秒将状态改为“全部答完”
              Map map = {
                "question": questionList,
                "answer": answerList,
                "result": _wmsQuestion.result,
              };
              String text = json.encode(map);
              print(text);
              setAnswer(
                  reverse ? questionIdWMSSpaceReverse : questionIdWMSSpace,
                  score: _wmsQuestion.correctCounts,
                  answerText: text);
              Future.delayed(pointOneSec, () {
                setState(() {
                  currentState = CurrentState.questionAllDone;
                });
              });
            }
          } else {
            //进行下一题
            Future.delayed(pointOneSec, () {
              prepareShowQuestion();
            });
          }
        }
      }
    }
  }

  Widget buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(150),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Text(
        "长度：$currentLen位",
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }

  Widget buildMainWidget() {
    return Stack(
      children: buildClickedButtons() +
          [
            Center(
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
            ),
            Center(
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
                      fontSize: setSp(70), color: showTextColor[currentState]),
                ),
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
                borderRadius: BorderRadius.all(
                    Radius.circular(setWidth(floatWindowRadios))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      blurRadius: setWidth(10),
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Text(
              test ? "熟悉操作方法" : "正式测查",
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

  double floatWindowRadios = 30;
  TextStyle resultTextStyle = TextStyle(
      fontSize: setSp(45), fontWeight: FontWeight.bold, color: Colors.blueGrey);

  Widget buildResultFloatWidget() {
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
                    Text(
                        "    正确数：" +
                            _wmsQuestion.correctCounts.toString() +
                            "    ",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text(
                        "    错误数：" +
                            _wmsQuestion.wrongCounts.toString() +
                            "    ",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text("最大长度：" + _wmsQuestion.maxLength.toString() + "位    ",
                        style: resultTextStyle),
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
                testFinishedList[(reverse
                    ? questionIdWMSSpaceReverse
                    : questionIdWMSSpace)] = true;
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
    QuestionInfo questionInfo =
        Map.from(ModalRoute.of(context).settings.arguments)["questionInfo"];
    reverse = questionInfo.reverse;
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
  showingQuestion, //正式显示题目
  doingQuestion, //开始答题
  questionCorrect, //答题正确
  questionWrong, //答题错误
  questionAllDone //全部答题完毕
}