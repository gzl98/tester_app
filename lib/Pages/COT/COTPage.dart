import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';

import 'package:tester_app/Pages/COT/COTQuestion.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/questions.dart';

//持续操作测试
//这是一项检测持续注意力的测验。屏幕上会先出现一个图形您要记住它，之后屏幕中央会连续出现一系列的图形，每当出现您记住的图形时，请尽可能地按下屏幕中的按钮。
//注意：总共约2分钟，您需要尽快、准确地对每个图形做出判断。

class COTPage extends StatefulWidget {
  static const routerName = "/COTPage";

  @override
  State<StatefulWidget> createState() {
    return COTPageState();
  }
}

class COTPageState extends State<COTPage> {
  AudioPlayer audioPlayer;
  AudioCache player;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    initAudioPlayer();
    super.initState();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    player = AudioCache();
  }

  //播放音频文件
  play() async {
    //如果没有播放路径，则直接退出
    audioPlayer = await player.play("sounds/COT2.wav");
  }

  //停止播放
  stop() async {
    audioPlayer.stop();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  Timer _timer;
  int currentTime = 0; //ms
  int nextQuestionTime = 0; //ms
  final pointOneSec = const Duration(milliseconds: 10);
  COTQuestion _cotQuestion = COTQuestion(3, 0); // 出题器
  int _question = 0; // 当前问题
  int _questionStartTime = 0;
  int currentState =
      0; // 题目流程 0:显示悬浮窗 1:显示题目 2:显示准备 3:显示图形 4:答题正确 5:答题错误 6:答题完毕
  bool formal = false; // 是否为正式测试
  String imagePath = "images/v2.0/COT/0.png"; // 显示图片的路径
  int _answerTimes = 0;
  int _answerCorrectTimes = 0;
  int _answerTime = 0;
  int _answerCorrectTime = 0;

  void answerProblem() {
    print(currentTime);
    print(currentTime - _questionStartTime);
    print(_question);
    print(_cotQuestion.getAnswer());
    int t = currentTime - _questionStartTime;
    if (_question == _cotQuestion.getAnswer()) {
      setState(() {
        currentState = 4;
        imagePath = "images/v2.0/correct.png";
        nextQuestionTime = currentTime + 200;
        if (formal) {
          _answerCorrectTimes += 1;
          _answerTimes += 1;
          _answerTime += t;
          _answerCorrectTime += t;
        } else {
          _answerTime += 1;
          if (_answerTime == 3) {
            questionOver();
          }
        }
      });
    } else {
      setState(() {
        currentState = 5;
        if (formal) {
          _answerTimes += 1;
          _answerTime += t;
        }
        nextQuestionTime = currentTime + 200;
        imagePath = "images/v2.0/wrong.png";
      });
    }
  }

  void questionOver() {
    if (formal) {
      setState(() {
        currentState = 6;
      });
      List<int> result = [];
      result.add(_answerTimes);
      result.add(_answerCorrectTimes);
      result.add(_answerTime);
      result.add(_answerCorrectTime);
      String data = jsonEncode({'result': result});
      setAnswer(3, answerText: data, score: _answerCorrectTimes);
    } else {
      _timer.cancel();
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          setState(() {
            formal = true;
            currentState = 0;
            currentTime = 0;
            nextQuestionTime = 0;
            _cotQuestion.setQuestionState(1);
            _cotQuestion.generateAnswer();
          });
        });
      });
    }
  }

  void callback(timer) {
    setState(() {
      if (currentTime >= 120 * 1000) {
        _timer.cancel();
        questionOver();
      }
      if (currentTime == nextQuestionTime) {
        int question = _cotQuestion.getNextQuestion();
        String questionImagePath =
            "images/v2.0/COT/" + question.toString() + ".png";
        setState(() {
          nextQuestionTime += 1000;
          currentState = 3;
          _question = question;
          imagePath = questionImagePath;
          _questionStartTime = currentTime;
        });
      }
      currentTime += 10;
    });
  }

  void prepareShow() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        currentState = 3;
      });
      _timer = Timer.periodic(pointOneSec, callback);
    });
  }

  Widget buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(150),
      color: Color.fromARGB(255, 48, 48, 48),
      child: formal
          ? Text(
              "用时：" + (20 - currentTime ~/ 1000).toString() + 's',
              style: TextStyle(color: Colors.white, fontSize: setSp(55)),
            )
          : Text(
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
                          prepareShow();
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
                        child: currentState == 2
                            ? Text(
                                "准备",
                                style: TextStyle(
                                  fontSize: setSp(180),
                                  color: Colors.red,
                                ),
                              )
                            : currentState == 3
                                ? ((currentTime ~/ 200) % 2 == 0
                                    ? Image.asset(
                                        imagePath,
                                        width: setWidth(350),
                                        fit: BoxFit.fill,
                                      )
                                    : Container())
                                : Image.asset(
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
                          answerProblem();
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
                play();
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
                height: setHeight(320),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // SizedBox(height: setHeight(30)),
                    Text("总反应数：" + _answerTimes.toString() + "次",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text("正确反应数：" + _answerCorrectTimes.toString() + "次",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text("反应时间：" + (_answerTime / 1000).toString() + "s",
                        style: resultTextStyle),
                    Text(
                        "平均正确反应时间：" +
                            (_answerCorrectTime / 1000).toString() +
                            "s",
                        style: resultTextStyle),
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(height: setHeight(230)),
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
                testFinishedList[questionIdCOT ] = true;
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
                currentState == 6 ? buildResultFloatWidget() : Container(),
                currentState == 6
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
