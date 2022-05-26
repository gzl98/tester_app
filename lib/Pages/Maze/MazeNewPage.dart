
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/DrawWidget/DrawPainter.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Fragments/QuestionInfoFragment.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/EventBusType.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';
// 构建规则页面和注意页面的空间
Widget buildMazeFirstFragment() {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/migong.jpeg'),
          fit: BoxFit.scaleDown,
          alignment: Alignment.center),
    ),
  );
}
Widget buildMazeSecondFragment() {
  return Container(
    alignment: Alignment.center,
    width: maxWidth,
    height: setHeight(1000),
    child: Container(
      margin: EdgeInsets.only(top: setHeight(400)),
      alignment: Alignment.center,
      width: setWidth(800),
      height: setHeight(550),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/migong.jpeg'),
              fit: BoxFit.fill,
              alignment: Alignment.center),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD), width: setWidth(1)),
          color: Color.fromARGB(255, 226, 229, 228),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(25)))),
    ),
  );
}

class MazePage extends StatefulWidget {
  static const routerName = "/MazePage";
  @override
  State<StatefulWidget> createState() {
    return MazePageState();
  }
}

class MazePageState extends State<MazePage> {
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
  //TODO:定义题目名称，规则
  final String questionTitle = "迷宫";
  final String questionContent =
      "\t\t\t\t本题目主要考察问题与解决问题的能力，请用画笔从迷宫开始到结束。";

  CurrentState currentState = CurrentState.questionBegin;

  //TODO：根据情况定义分数和时间，不定义即为不显示
  int score ;
  int remainingTime = 30;
  int totalTime = 30;
  Timer _timer;

  //TODO: 定义主体布局，长宽分别为1960*1350像素，设置大小时统一使用setWidth和setHeight，setSp函数，使用maxWidth和maxHeight不需要使用上述3个函数
  Widget buildMainWidget() {
    return Container(
      // color: Colors.redAccent,
        child: MyPainterPage(imgPath: 'images/migong.png',),
    );
  }

  Widget buildFloatWidget(String warning, String operate) {
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
                    currentState = CurrentState.doingQuestion;
                    startCountdownTimer();
                  }
                  else if(currentState == CurrentState.questionAllDone) {

                  }
                });
              },
              child: Text(
                operate,
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
        fontSize: setSp(45), fontWeight: FontWeight.bold, color: Colors.blueGrey);
    double floatWindowRadios = 30;
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
                    Radius.circular(setWidth(30))),
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
                margin: EdgeInsets.only(top: setHeight(floatWindowRadios)),
                height: setHeight(300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("用时："+(this.totalTime - this.remainingTime).toString()+"s      ", style: resultTextStyle),
                  ]
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
                  "testName":"迷宫导航测试",
                  //测试者用时
                  "time": this.totalTime - this.remainingTime,
                };
                // map.addAll(_wmsQuestion.result);
                String resultInfoStr = json.encode(map);
                //print(resultInfoStr);
                eventBus.fire(NextEvent(MazeID, this.totalTime - this.remainingTime));
                //setAnswer(MazeID, score:this.totalTime - this.remainingTime, answerText: resultInfoStr);
                //加入该题目结束标志
                testFinishedList[MazeID]=true;
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

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
      setState(() {
        if (remainingTime < 1) {
          _timer.cancel();
          currentState = CurrentState.questionAllDone;
        } else {
          remainingTime = remainingTime - 1;
        }
      })
    };
    _timer = Timer.periodic(oneSec, callback);
  }


  //倒计时组件
  Widget buildTime() {
    return Text(
      '时间：' + remainingTime.toString() + 's',
      style: TextStyle(
          fontSize: setSp(60),
          fontWeight: FontWeight.w600,
          color: remainingTime > 10
              ? Colors.white
              : Color.fromARGB(255, 255, 0, 0)),
    );
  }

  //*顶部背景*
  Widget buildTopWidget() {
    return Expanded(
      flex: 4,
      child: Container(
        color: Color.fromARGB(200, 0, 0, 0),
        child: Row(
          children: <Widget>[
            //缩放闹钟图片
            Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 3, child: Text("")),
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/v2.0/clock.png'),
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter),
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: Text("")),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Align(
                  child: buildTime(),
                  alignment: Alignment.centerLeft,
                )),
            Expanded(flex: 10, child: Text("")),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRect() {
    return SizedBox(
        child:RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(30)))),
          color: Colors.green,
          child: Container(
              child: Text(
                "提交",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: setSp(56)),
              )),
          onPressed:() {
            print("tijiao");
            setState(() {
              this.currentState = CurrentState.questionAllDone;
              _timer.cancel();
            });
          },
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
                          child: buildMainWidget(),
                        ),
                      ]),
                ),
                Positioned(
                    left: setWidth(2100),
                    width: setWidth(250),
                    top: setHeight(1350),
                    height: setHeight(200),
                    child: buildButtonRect()),
                currentState == CurrentState.questionBegin
                    ? buildFloatWidget("正式开始", "开始")
                    : Container(),
                currentState == CurrentState.questionAllDone
                    ? buildResultFloatWidget()
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
enum CurrentState {
  questionBegin, //显示开始浮窗
  doingQuestion, //开始答题
  questionAllDone //全部答题完毕
}
