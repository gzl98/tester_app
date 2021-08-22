import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/RVIPTest/RVIPQuestion.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/Utils.dart';
//多个状态
enum CurrentState {
  waiting,          //刚进入界面等待
  questionPrepare,  //题目闪烁
  doingQuestion,    //答题时间
  oneTestResult,    //答完一道显示结果
  questionDone,     //答题完毕
}
class RVIPTestPage extends StatefulWidget{
  static const routerName = "/RVIP";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RVIPState();
  }
}

class RVIPState extends State<RVIPTestPage> {
  //当前状态（初始为等待）
  final int totalTime = 2*60*1000;
  final int  seqLength = 200;
  final int targetCount = 10;
  CurrentState currentState = CurrentState.waiting;
  bool _wordflag = true;
  bool _rightFlag = false;
  // 题目生成器
  var _testGenerator;
  // 题目列表
  String _testList;
  RVIPtResultInfo _resultInfo = RVIPtResultInfo();
  // 当前显示的题目标号
  int _currentIndex = 0;
  Timer _timer;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    _testGenerator = RVIPSingleTest(this.seqLength, this.targetCount);
    startTest();
  }

  //强制退出
  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  // 开始测试
  void startTest() {
    setState(() {
      this._testList = this._testGenerator.generatorTestByCount(3);
      print(this._testList);
    });
    if (this.currentState != CurrentState.questionDone) {
      Future.delayed(Duration(milliseconds: 1500), () {
        doingTest();
      });
    }
  }

  void doingTest() {
    setState(() {
      this.currentState = CurrentState.doingQuestion;
    });
    Future.delayed(Duration(milliseconds: 600), () {
      //读第一次的值
      this._timer = Timer.periodic(Duration(milliseconds: this.totalTime~/this.seqLength), callbackTime);
    });
  }
  void callbackTime(timer) {
    setState(() {
      if (this._currentIndex < this._testList.length - 1) {
        this._currentIndex ++;
      }
      else if (this._currentIndex == this._testList.length - 1) {
        this.currentState = CurrentState.questionDone;
        this._timer.cancel();
      }
    });
  }
  void pressButton(){
    if (currentState == CurrentState.doingQuestion) {
      bool result_flag = this._testGenerator.judgeInTargets(this._currentIndex);
      setState(() {
        this._resultInfo.addSingleTimeResult(0, result_flag, this._currentIndex);
      });
    } else {
      print("还未进入答题状态，无效确认");
    }
  }

  Widget _buildNumCard(String num) {
    var circleBoxDecoration = new BoxDecoration(
      border: new Border.all(color: Color(0xFFB9BBBB), width: 0.5), // 边色与边宽度
      borderRadius: new BorderRadius.circular((25)), // 圆角度
      color: Color(0xFFE2E4E6),
      //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
    );
    var cardWordStyle = TextStyle(
      fontSize: setSp(250),
    );
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: setHeight(40)),
      child: this._wordflag == true
          ? Text(
        num,
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

  Widget _buildTargetInfo() {
    var circleBoxDecoration = new BoxDecoration(
      border: new Border.all(color: Color(0xFFB9BBBB), width: 0.1), // 边色与边宽度
      borderRadius: new BorderRadius.circular((25)), // 圆角度
      color: Color(0xFFF8F8F8),
      //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
    );
    return Container(
      margin: EdgeInsets.only(top: setHeight(40)),
      padding: EdgeInsets.only(left: setWidth(20)),
      alignment: Alignment.topLeft,
      child: Text(
        "目标：\n" +
            this._testGenerator.getTargetListStr(),
        style: TextStyle(color: Colors.black, fontSize: setSp(80)),
      ),
      decoration: circleBoxDecoration,
    );
  }

  Widget _buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(150),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Text(
        "快速视觉信息处理任务",
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }

  //
  Widget _buildMainContext() {
    return Expanded(
        flex: 4,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(""),
              ),
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text("")
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildNumCard(this._testList[this._currentIndex]),
                    ),
                    Expanded(
                        flex: 1,
                        child: _buildTargetInfo()
                    ),
                    Expanded(
                        flex: 2,
                        child: Text("")
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(""),
              ),
            ],
          ),
        )
    );
  }

  //确认按钮
  Widget _confirmButton() {
    return Expanded(
        flex: 2,
        child: Container(
          width: maxWidth,
          height: maxHeight,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            color: Color.fromARGB(255, 213, 232, 212),
            onPressed: () => this.pressButton(),
            child: Text("确认", style: TextStyle(fontSize: setSp(70),
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),),
          ),
        )
    );
  }

  Widget _buildBottomWidget() {
    return Expanded(
        flex: 1,
        child: Container(
          width: maxWidth,
          height: maxHeight,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(""),
              ),
              Expanded(
                  flex: 8,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(""),
                      ),
                      _confirmButton(),
                      Expanded(
                        flex: 3,
                        child: Text(""),
                      ),
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }

  //主界面布局
  @override
  Widget buildPage(BuildContext context) {
    //TODO: 定义主体布局，长宽分别为1960*1350像素
    return Stack(
      children: <Widget>[
        Container(
          color: Color.fromARGB(255, 218, 232, 252),
          width: maxWidth,
          height: maxHeight,
          child: Column(
            children: <Widget>[
              _buildTopWidget(),
              Container(
                width: maxWidth,
                height: setHeight(5),
                color: Colors.red,
              ),
              _buildMainContext(),
              _buildBottomWidget(),
            ],
          ),
        ),
        currentState == CurrentState.waiting
            ? _showPrepareBackground()
            : Container(),
        currentState == CurrentState.waiting ? _showPrepare() : Container(),
        currentState == CurrentState.questionDone
            ? _buildResultFloatWidget()
            : Container(),
        currentState == CurrentState.questionDone
            ? Positioned(
            right: setWidth(400),
            bottom: 0,
            child: Image.asset(
              "images/v2.0/doctor_result.png",
              width: setWidth(480),
            ))
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: buildPage(context),
      ),
    );
  }

  //准备开始背景
  Widget _showPrepareBackground() {
    return Positioned(
      top: setHeight(630),
      right: setWidth(860),
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
    );
  }

  //准备开始颜色
  Widget _showPrepare() {
    return Positioned(
      top: setHeight(630),
      right: setWidth(860),
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
          "准 备 开 始",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: setSp(70), color: Colors.deepOrangeAccent),
        ),
      ),
    );
  }

  Widget _buildResultFloatWidget() {
    double floatWindowRadios =30;
    TextStyle resultTextStyle = TextStyle(
        fontSize: setSp(45), fontWeight: FontWeight.bold, color: Colors.blueGrey);
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
                    Text("错误数："+this._resultInfo.getErrorRectCount()+"      ", style: resultTextStyle),
                    Text("正确反应数："+this._resultInfo.getRightCount()+"      ", style: resultTextStyle),
                    Text("错过数目："+this._resultInfo.getMissingCount(this.targetCount)+"      ", style: resultTextStyle),
                    // Text("平均反应时间："+"0"+"ms    ", style: resultTextStyle),
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
                // Map map = {
                //   //题目名称
                //   "testName":"Stroop色词",
                //   //题目
                //   "question": this.testList,
                //   //测试者反应的题目序号
                //   "pressIndex": this._resultInfo.rectIndexList,
                //   //测试者反应结果
                //   "pressResult": this._resultInfo.rectResult,
                //   //测试者反应的时间
                //   "pressTime": this._resultInfo.totalRectTime,
                //   //测试者的平均反应时间
                //   "meanRectTime":this._resultInfo.getMeanRectTime(),
                //   //测试者的总反应数
                //   "totalRect":this._resultInfo.totalRect,
                //   //测试者的正确反应数
                //   "rightRect":this._resultInfo.rightRect,
                //   //测试者的错误反应数
                //   "errorRect":this._resultInfo.getErrorRectCount(),
                // };
                // map.addAll(_wmsQuestion.result);
                //String resultInfoStr = json.encode(map);
                //print(resultInfoStr);
                //setAnswer(stroopColorWordID, score:this._resultInfo.rightRect , answerText: resultInfoStr);
                //加入该题目结束标志
                //testFinishedList[stroopColorWordID]=true;
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
}


