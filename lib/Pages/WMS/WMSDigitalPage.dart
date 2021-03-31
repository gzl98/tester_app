import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/Pages/WMS/WMSQuestion.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/questions.dart';

class WMSDigitalPage extends StatefulWidget {
  static const routerName = "/WMSDigitalPage";

  @override
  State<StatefulWidget> createState() {
    return WMSDigitalPageState();
  }
}

class WMSDigitalPageState extends State<WMSDigitalPage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();

    // currentLen = 3;
    // textList = List.generate(currentLen, (index) => '1');
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  int currentLen = 3, currentIndex = 0; //输入字符的最大长度和当前索引的控制
  bool isLight = false; //控制闪烁的变量
  int digit; //当前播放的数字
  Timer _timer; //计时器
  int currentTime = 0; //辅助计时器你
  WMSQuestion _wmsQuestion = WMSQuestion(test: true); //初始化出题器
  final pointOneSec = const Duration(milliseconds: 100); //定义0.1秒的Duration
  final pointFiveSec = const Duration(milliseconds: 500); //定义0.5秒的Duration
  CurrentState currentState = CurrentState.questionBegin; //初始化当前页面状态为Begin
  bool test = true; //是否为test阶段的标志
  bool reverse; //正序倒序的标志

  List textList; //当前输入

  List questionList = []; //保存题目
  List answerList = []; //保存答题结果

  //展示题目界面定时器回调函数
  void showingCallback(timer) {
    setState(() {
      if (currentTime == 0) {
        //判断是否有下一道题
        if (_wmsQuestion.hasNextIndex()) {
          //获取下一道题，并进行高亮
          digit = _wmsQuestion.getNextQuestion();
        } else {
          //取消定时器
          _timer.cancel();
          //清除高亮状态
          digit = null;
          //改变当前状态为开始做题
          currentState = CurrentState.doingQuestion;
          //重置题目生成器的索引
          // _wmsQuestion.resetIndex();
          //开启闪烁计时器
          currentTime = 5;
          _timer = Timer.periodic(pointOneSec, doingCallback);
        }
      } else if (currentTime == 5) {
        //清除高亮状态，构成闪烁效果
        digit = null;
      }
      //递增计时器
      currentTime = (currentTime + 1) % 10;
    });
  }

  //开始展示题目
  void showQuestions() {
    setState(() {
      //设置当前状态为展示问题
      currentState = CurrentState.showingQuestion;
      //生成新的题目
      _wmsQuestion.generateRandomQuestionList(needZero: false);
      //重置状态
      currentIndex = 0;
      currentLen = _wmsQuestion.getCurrentLength();
      textList = List.generate(currentLen, (index) => '');
      if (!test) {
        //记录当前题目
        questionList.add(_wmsQuestion.getQuestionList(reverse: reverse));
      }
      //启动计时器和callback函数
      currentTime = 8;
      _timer = Timer.periodic(pointOneSec, showingCallback);
    });
  }

  //展示题目界面定时器回调函数
  void doingCallback(timer) {
    setState(() {
      if (currentTime == 0) {
        isLight = true;
      } else if (currentTime == 4) {
        //清除高亮状态，构成闪烁效果
        isLight = false;
      }
      //递增计时器
      currentTime = (currentTime + 1) % 8;
    });
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

  //构建小键盘
  Widget buildSmallKeyBoard() {
    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(Color.fromARGB(255, 241, 241, 241)),
      elevation: MaterialStateProperty.all(setWidth(6)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          side: BorderSide(width: setWidth(1), color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(10))),
        ),
      ),
    );
    TextStyle textStyle = TextStyle(
        fontSize: setSp(50),
        color: Colors.black54,
        fontWeight: FontWeight.bold);
    List<Widget> digitalList = [];
    for (int i = 0; i < 3; ++i) {
      List<Widget> childrenList = [];
      for (int j = 0; j < 3; ++j) {
        TextButton button = TextButton(
          onPressed: () => buttonClicked(j * 3 + i + 1),
          child: Text((j * 3 + i + 1).toString(),
              style: TextStyle(
                  fontSize: setSp(65),
                  color: Colors.black54,
                  fontWeight: FontWeight.bold)),
          style: buttonStyle,
        );
        Widget container = Container(
          margin: EdgeInsets.only(
              right: setWidth(6),
              left: setWidth(6),
              top: setHeight(15),
              bottom: setHeight(15)),
          width: setWidth(150),
          height: setHeight(150),
          child: button,
        );
        childrenList.insert(0, container);
      }
      Widget childWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: childrenList,
      );
      digitalList.add(childWidget);
    }
    Widget functionKeys = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: setWidth(150),
          height: setHeight(150),
          margin: EdgeInsets.only(
              right: setWidth(6),
              left: setWidth(12),
              top: setHeight(15),
              bottom: setHeight(15)),
          child: TextButton(
            onPressed: currentIndex > 0 ? () => buttonClicked(-1) : null,
            child: Text("清除", style: textStyle),
            style: buttonStyle,
          ),
        ),
        Container(
          width: setWidth(150),
          height: setHeight(330),
          margin: EdgeInsets.only(
              right: setWidth(6),
              left: setWidth(12),
              top: setHeight(15),
              bottom: setHeight(15)),
          child: TextButton(
            onPressed:
                currentIndex == currentLen ? () => buttonClicked(0) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("确", style: textStyle),
                SizedBox(height: setHeight(35)),
                Text("认", style: textStyle),
              ],
            ),
            style: buttonStyle,
          ),
        ),
      ],
    );
    return Container(
      width: setWidth(700),
      height: setHeight(600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: digitalList + [functionKeys],
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(radius: setWidth(4), colors: [
          Color.fromARGB(255, 238, 240, 242),
          Color.fromARGB(255, 214, 216, 217),
        ]),
        border: Border.all(color: Colors.grey[300], width: setWidth(1)),
        borderRadius: BorderRadius.all(Radius.circular(setWidth(10))),
        boxShadow: [
          BoxShadow(
              color: Colors.black45,
              offset: Offset(setWidth(10), setHeight(15)),
              blurRadius: setWidth(10))
        ],
      ),
    );
  }

  //判断对错
  bool checkCorrect() {
    var question = _wmsQuestion.getQuestionList(reverse: reverse);
    for (int i = 0; i < question.length; ++i) {
      if (question[i].toString() != textList[i]) return false;
    }
    return true;
  }

  void buttonClicked(index) {
    switch (index) {
      case -1:
        //退格
        setState(() {
          currentIndex--;
          textList[currentIndex] = '';
        });
        break;
      case 0:
        //提交
        if (_timer.isActive) _timer.cancel();
        if (!test) {
          answerList.add(textList);
        }
        //判断对错
        if (checkCorrect()) {
          //当前题目答完，则进行判对
          setState(() {
            currentState = CurrentState.questionCorrect; //判对
            _wmsQuestion.questionCorrect(); //判对
          });
          if (_wmsQuestion.questionAllDone()) {
            if (test) {
              //如果为test阶段，则进入正式测试
              Future.delayed(pointFiveSec, () {
                setState(() {
                  test = false; //更改test标志
                  _wmsQuestion = WMSQuestion(test: false); //重新创建测试题
                  currentState = CurrentState.questionBegin; //恢复初始状态
                });
              });
            } else {
              //如果所有题目都回答完毕，则提交结果，并延迟0.1秒将状态改为“全部答完”
              Map map = {
                "question": questionList,
                "answer": answerList,
                "result": _wmsQuestion.result,
              };
              String text = json.encode(map);
              print(text);
              setAnswer(
                  reverse ? questionIdWMSDigitalReverse : questionIdWMSDigital,
                  score: _wmsQuestion.correctCounts,
                  answerText: text);
              Future.delayed(pointFiveSec, () {
                setState(() {
                  currentState = CurrentState.questionAllDone;
                });
              });
            }
          } else {
            //进行下一题
            Future.delayed(pointFiveSec, () {
              prepareShowQuestion();
            });
          }
        } else {
          //如果当前index不等于题目的答案，则进行判错
          setState(() {
            //修改状态
            currentState = CurrentState.questionWrong; //判错
            _wmsQuestion.questionWrong(); //判错
          });
          if (test) {
            Future.delayed(pointFiveSec, () {
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
            setAnswer(
                reverse ? questionIdWMSDigitalReverse : questionIdWMSDigital,
                score: _wmsQuestion.correctCounts,
                answerText: text);
            Future.delayed(pointFiveSec, () {
              setState(() {
                currentState = CurrentState.questionAllDone;
              });
            });
          } else {
            //否则延迟0.1秒继续进行下一道题
            Future.delayed(pointFiveSec, () {
              prepareShowQuestion();
            });
          }
        }
        break;
      default:
        //输入数字
        setState(() {
          textList[currentIndex] = index.toString();
          currentIndex++;
        });
        break;
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

  Widget buildEditText() {
    double digitalWidth = 150;
    List<Widget> editWidgets = [];
    for (int i = 0; i < currentLen; i++) {
      Widget digital = Column(
        children: [
          Text(
            textList[i],
            //   i.toString(),
            style: TextStyle(
              fontSize: setSp(180),
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 98, 78, 75),
            ),
          ),
          Container(
            margin: EdgeInsets.all(setWidth(2.5)),
            width: setWidth(digitalWidth),
            height: setHeight(15),
            color: currentIndex == i && isLight
                ? Color.fromARGB(255, 197, 250, 252)
                : Colors.blue,
          )
        ],
      );
      editWidgets.add(digital);
    }
    return Container(
        width: setWidth((digitalWidth + 5) * currentLen),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: editWidgets,
            ),
          ],
        ));
  }

  Widget buildMainWidget() {
    return Stack(
      children: () {
        double marginBottom = 160;
        if (currentState == CurrentState.showingQuestion) {
          return [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: setHeight(marginBottom)),
                child: Text(
                  digit != null ? digit.toString() : '',
                  style: TextStyle(
                    fontSize: setSp(350),
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 98, 78, 75),
                  ),
                ),
              ),
            )
          ];
        }
        if (currentState == CurrentState.doingQuestion ||
            currentState == CurrentState.questionCorrect ||
            currentState == CurrentState.questionWrong) {
          return [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: setHeight(marginBottom * 2)),
                child: buildEditText(),
              ),
            ),
            Positioned(
              right: setWidth(100),
              bottom: setHeight(90),
              child: buildSmallKeyBoard(),
            ),
          ];
        }
        if (currentState == CurrentState.questionPrepare) {
          double height = 260, width = 1000;
          return [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: setHeight(marginBottom)),
                width: setWidth(width - 30),
                height: setHeight(height),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.35),
                      blurRadius: setWidth(10),
                      offset: Offset(setWidth(0), setHeight(8)),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: setHeight(marginBottom)),
                alignment: Alignment.center,
                width: setWidth(width),
                height: setHeight(height),
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
                  "准 备",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: setSp(130), color: Colors.deepOrangeAccent),
                ),
              ),
            ),
          ];
        }
        return [Container()];
      }(),
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
                  children: [
                    // SizedBox(height: setHeight(30)),
                    Text(
                        "正确数：" +
                            _wmsQuestion.correctCounts.toString() +
                            "      ",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text(
                        "错误数：" + _wmsQuestion.wrongCounts.toString() + "      ",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text(
                        "最大长度：" + _wmsQuestion.maxLength.toString() + "位      ",
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
                testFinishedList[reverse
                    ? questionIdWMSDigitalReverse
                    : questionIdWMSDigital] = true;
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
                            margin: EdgeInsets.only(bottom: setHeight(110)),
                            child: Opacity(
                              opacity: 0.85,
                              child: Image.asset(
                                "images/v2.0/correct.png",
                                width: setWidth(370),
                              ),
                            )),
                      )
                    : Container(),
                currentState == CurrentState.questionWrong
                    ? Center(
                        child: Container(
                            margin: EdgeInsets.only(bottom: setHeight(110)),
                            child: Opacity(
                              opacity: 0.85,
                              child: Image.asset(
                                "images/v2.0/wrong.png",
                                width: setWidth(370),
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
