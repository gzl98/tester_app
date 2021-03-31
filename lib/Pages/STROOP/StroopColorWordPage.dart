import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/STROOP/StroopTestInfo.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/TTSUtil.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class StroopColorWordPage extends StatefulWidget {
  static const routerName = "/StroopColorWordPage";

  @override
  State<StatefulWidget> createState() {
    return StroopColorWordPageState();
  }
}

class StroopColorWordPageState extends State<StroopColorWordPage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    CreateStroopTest createTest = new CreateStroopTest();
    this.testList = createTest.getListStroopColorWordTest(10);
    //初始化语音播放器
  }
  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }
  int _currentIndex = 1;
  Timer _timer;
  double currentTime = 0;

  //闪烁文字标志
  bool _wordflag = true;
  //显示对题标志
  bool _rightFlag = false;
  //准备操作是否完成标志
  int _prepareFinishedFlag = 0;
  //每道题按钮禁用类
  bool _pressAableFlag = true;
  //时间控制
  final pointOneSec = const Duration(milliseconds: 100);
  CurrentState currentState = CurrentState.questionBegin;
  //存放结果类
  StroopTestResultInfo _resultInfo = StroopTestResultInfo();
  //正式题目列表
  List<SingleStroopCard> testList;
  //语音工具类
  TTSUtil tts = new TTSUtil();

  //中间显示的文字
  Map showText = {
    CurrentState.questionPrepare: "准 备",
  };

  //中间显示文字的颜色
  Map showTextColor = {
    CurrentState.questionPrepare: Colors.deepOrangeAccent,
  };

  //初始化正式开始答题的状态
  initDoingQuestionBegin() {
    setState(() {
      //时钟取消
      this._timer.cancel();
      this.currentState = CurrentState.doingQuestionBegin;
      CreateStroopTest createTest = new CreateStroopTest();
      //重新生成测试题
      this.testList = createTest.getListStroopColorWordTest(10);
      this._currentIndex = 1;
      this._rightFlag = false;
      this._wordflag = true;
      this.currentTime = 0;
    });
  }

  initSingleTest() {
    setState(() {
      this._wordflag = true;
      this._rightFlag = false;
      //每题开始按钮可以用
      this._pressAableFlag = true;
      this.tts.speak(this.testList[this._currentIndex - 1].sound);
    });
  }
  //初始化结束状态
  void initEndingAll(){
    this.currentState=CurrentState.questionAllDone;
    this._timer.cancel();
  }
  void doingQuestion() {
    setState(() {
      this.currentTime = 0;
      this.currentState = CurrentState.doingQuestion;
    });
    Future.delayed(Duration(seconds: 2), () {
      //读第一次的值
      this.initSingleTest();
      this._timer = Timer.periodic(pointOneSec, callbackTime);
    });
  }

  void callbackTime(timer) {
    setState(() {
      if (currentTime == 20) {
        if (this._currentIndex < this.testList.length) {
          this._currentIndex++;
          this.initSingleTest();
        } else {
          this._timer.cancel();
          if(this.currentState == CurrentState.doingQuestion) initEndingAll();
          //准备没有答对三个
          if(this.currentState == CurrentState.preDoingQuestion){
            //返回主页
            Navigator.pushNamedAndRemoveUntil(
                context, TestNavPage.routerName, (route) => false);
          }

        }
      } else if (this.currentTime == 5) {
        //隐藏文字
        this._wordflag = false;
      }
      this.currentTime = (this.currentTime + 1) % 21;
    });
  }

  void prepareShow() {
    setState(() {
      currentState = CurrentState.preDoingQuestion;
    });
    Future.delayed(Duration(seconds: 2), () {
      this.initSingleTest();
      this._timer = Timer.periodic(pointOneSec, callbackTime);
    });
  }

  //检查用户测试的对错
  bool _checkRight() {
    return this.testList[this._currentIndex - 1].checkSoundAndWord();
  }
  //按下按钮
  doingTestPress(){
    setState(() {
      if(this._pressAableFlag==true){
        if (this._checkRight()) {
          setState(() {
            this._rightFlag = true;
            if (this.currentState == CurrentState.preDoingQuestion) {
              this._prepareFinishedFlag++;
              print(this._prepareFinishedFlag);
              //准备答对三次显示正式答题浮窗
              if (this._prepareFinishedFlag == 3) initDoingQuestionBegin();
            }
          });
        }
        //反应错误 反应错误数据加一
        else {
          this._rightFlag = false;
        }
        if(this.currentState==CurrentState.doingQuestion)
          this._resultInfo.addSingleTimeResult(this.currentTime, this._rightFlag,this._currentIndex);
          this._pressAableFlag=false;
      }
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
        "进度：" + this._currentIndex.toString() + "/"+this.testList.length.toString(),
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }

  Widget buildWordCard(SingleStroopCard card) {
    var circleBoxDecoration = new BoxDecoration(
      border: new Border.all(color: Color(0xFFB9BBBB), width: 0.5), // 边色与边宽度
      borderRadius: new BorderRadius.circular((25)), // 圆角度
      color: Color(0xFFE2E4E6),
      //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
    );
    var cardWordStyle = TextStyle(
      fontSize: setSp(250),
      color: card.color,
    );
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: setHeight(40)),
      child: this._wordflag == true
          ? Text(
              card.word,
              style: cardWordStyle,
            )
          : this._rightFlag == true
              ? Container(
                  child: Opacity(
                    opacity: 0.85,
                    child: Image.asset(
                      "images/v2.0/correct.png",
                      width: setWidth(350),
                    ),
                  ),
                )
              : Container(),
      decoration: circleBoxDecoration,
    );
  }

  Widget buildMainWidget() {
    return Stack(
      children: [
        Positioned(
          top: setHeight(300),
          width: setWidth(900),
          height: setHeight(500),
          left: setWidth(850),
          child: buildWordCard(this.testList[this._currentIndex - 1]),
        ),
        currentState == CurrentState.questionPrepare
            ? Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: setHeight(140)),
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
                  margin: EdgeInsets.only(bottom: setHeight(140)),
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

  Widget buildFloatWidget(String warning) {
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
              warning,
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
                  if (currentState == CurrentState.questionBegin) {
                    currentState = CurrentState.questionPrepare;
                    prepareShow();
                  } else if (currentState == CurrentState.doingQuestionBegin) {
                    doingQuestion();
                  }
                });
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
                height: setHeight(300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("总反应数："+this._resultInfo.totalRect.toString()+"      ", style: resultTextStyle),
                    Text("正确反应数："+this._resultInfo.rightRect.toString()+"      ", style: resultTextStyle),
                    Text("错误反应数："+this._resultInfo.getErrorRectCount().toString()+"      ", style: resultTextStyle),
                    Text("平均反应时间："+this._resultInfo.getMeanRectTime().toStringAsFixed(2)+"ms    ", style: resultTextStyle),
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
              //调用接口向后端传参
              onPressed: () {
                Map map = {
                  //题目名称
                  "testName":"Stroop色词",
                  //题目
                  "question": this.testList,
                  //测试者反应的题目序号
                  "pressIndex": this._resultInfo.rectIndexList,
                  //测试者反应结果
                  "pressResult": this._resultInfo.rectResult,
                  //测试者反应的时间
                  "pressTime": this._resultInfo.totalRectTime,
                  //测试者的平均反应时间
                  "meanRectTime":this._resultInfo.getMeanRectTime(),
                  //测试者的总反应数
                  "totalRect":this._resultInfo.totalRect,
                  //测试者的正确反应数
                  "rightRect":this._resultInfo.rightRect,
                  //测试者的错误反应数
                  "errorRect":this._resultInfo.getErrorRectCount(),
                };
                // map.addAll(_wmsQuestion.result);
                String resultInfoStr = json.encode(map);
                //print(resultInfoStr);
                setAnswer(stroopColorWordID, score:this._resultInfo.rightRect , answerText: resultInfoStr);
                //加入该题目结束标志
                testFinishedList[stroopColorWordID-1]=true;
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

  Widget buildButtonRect() {
    return SizedBox(
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(30)))),
          color: Color(0xFF7D7A7A),
          child: Container(
              child: Text(
                this._pressAableFlag?"空格按钮":"禁用",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: setSp(58)),
          )),
          onPressed:()=>this.doingTestPress(),
    ));
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
                Positioned(
                    left: setWidth(1900),
                    width: setWidth(500),
                    top: setHeight(1400),
                    height: setHeight(150),
                    child: buildButtonRect()),
                currentState == CurrentState.questionBegin
                    ? buildFloatWidget("熟悉操作")
                    : Container(),
                currentState == CurrentState.doingQuestionBegin
                    ? buildFloatWidget("正式开始")
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
  preDoingQuestion, //准备答题

  doingQuestionBegin, //正式准备答题
  doingQuestion, //开始答题
  questionAllDone //全部答题完毕
}
enum TtsState { playing, stopped, paused, continued }
