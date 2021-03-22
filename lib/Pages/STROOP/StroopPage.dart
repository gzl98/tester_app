import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/STROOP/StroopTestInfo.dart';
import 'package:tester_app/Pages/WMS/WMSQuestion.dart';
import 'package:tester_app/Utils/Utils.dart';

class StroopPage extends StatefulWidget {
  static const routerName = "/StroopWordPage";

  @override
  State<StatefulWidget> createState() {
    return StroopPageState();
  }
}

class StroopPageState extends State<StroopPage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    CreateStroopTest createTest = new CreateStroopTest(32);
    this._testList = createTest.getListStroopWordTest();
  }



  int _currentIndex=1;
  Timer _timer;
  double currentTime = 0;
  //闪烁文字标志
  bool  _wordflag=true;
  //显示对题标志
  bool _rightFlag = false;
  final pointOneSec = const Duration(milliseconds: 100);
  CurrentState currentState = CurrentState.questionBegin;
  bool success = true;
  //题目列表
  List<SingleStroopCard> _testList;
  //中间显示的文字
  Map showText = {
    CurrentState.questionPrepare: "准 备",
    CurrentState.showingQuestion: "题 目 播 放 中...",
    CurrentState.doingQuestion: "开 始 作 答",
  };

  //中间显示文字的颜色
  Map showTextColor = {
    CurrentState.questionPrepare: Colors.deepOrangeAccent,
    CurrentState.showingQuestion: Colors.blue[400],
    CurrentState.doingQuestion: Colors.blue[400],
  };

  void callbackTime(timer) {
    setState(() {
      if (currentTime == 0) {
        //显示文字
        this._wordflag = true;
        this._currentIndex += 1;
      } else if (currentTime == 5) {
        //隐藏文字
        _wordflag = false;
        if(this._currentIndex == 32){
          this._timer.cancel();
        }
      }
      currentTime = (currentTime + 1) % 20;
    });
  }

  void showQuestions() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        currentState = CurrentState.doingQuestion;
      });
      this._timer = Timer.periodic(pointOneSec, callbackTime);
    });

  }

  void prepareShow() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        currentState = CurrentState.showingQuestion;
      });
      showQuestions();
    });

  }
  //检查用户测试的对错
  bool checkRight(){

    return true;
  }

  Widget buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(200),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Text(
        "进度："+this._currentIndex.toString()+"/32",
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }
  Widget buildWordCard(SingleStroopCard card){
    var circleBoxDecoration = new BoxDecoration(
      border: new Border.all(color: Color(0xFFB9BBBB), width: 0.5), // 边色与边宽度
      borderRadius: new BorderRadius.circular((25)), // 圆角度
      color:Color(0xFFE2E4E6),
      //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
    );
    var cardWordStyle = TextStyle(
      fontSize: setSp(250),
      color: card.color,
    );
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: setHeight(40)),
      child:
      this._wordflag == true
        ?Text(
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
      children:
          [
            Positioned(
              top: setHeight(300),
              width: setWidth(900),
              height: setHeight(500),
              left: setWidth(850),
              child: buildWordCard(this._testList[this._currentIndex-1]),
            ),
            currentState == CurrentState.doingQuestion
                ? Container()
                : Center(
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
          ),
            currentState == CurrentState.doingQuestion
                ? Container()
                : Center(
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
  Widget buildButtonRect() {
    return SizedBox(
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(30)))),
          color: Color(0xFF737779),
          child: Container(
            child:
              Text(
                "空格按钮",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: setSp(58)),
              )

          ),
          onPressed: () {

          }),
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
                Positioned(
                    left: setWidth(1900),
                    width: setWidth(500),
                    top: setHeight(1400),
                    height: setHeight(150),
                    child: buildButtonRect()
                ),
                currentState == CurrentState.questionBegin
                    ? buildFloatWidget()
                    : Container(),
              ],
            ),
          ),
        ));
  }
}

enum CurrentState {
  questionBegin,    //显示开始浮窗
  questionPrepare,  //显示准备字样
  showingQuestion, //正式显示题目
  doingQuestion, //开始答题
  questionAllDone //全部答题完毕
}
