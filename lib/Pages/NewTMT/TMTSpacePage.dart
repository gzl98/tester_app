import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/NewTMT/TMTQuestion.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/questions.dart';


class TMTSpacePage extends StatefulWidget {
  static const routerName = "/TMTSpacePage";

  @override
  State<StatefulWidget> createState() {
    return TMTSpacePageState();
  }
}


class StarView extends CustomPainter {
  StarView(this.lx, this.ly);

  List<double> lx;
  List<double> ly;

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint()
      ..color = Colors.blueAccent
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < lx.length-1; i++) {
      canvas.drawLine(Offset(setWidth(lx[i]+75), setHeight(ly[i]+75)),
          Offset(setWidth(lx[i + 1]+75), setHeight(ly[i + 1]+75)), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
class rr{
  Random _random = Random();
  int _answer;
  int generateAnswer() {
    _answer =_random.nextInt(2); //这个nextInt就是随机生成一个整数好像是0到这个max
    return _answer;
  }

}

class TMTSpacePageState extends State<TMTSpacePage> {
  int temp_a;
  int temp_b;
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    rr ff=new rr();
    temp_a = ff.generateAnswer();
    temp_b = ff.generateAnswer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
    if (_timer2 != null && _timer2.isActive) _timer2.cancel();
  }


  // List<double> buttonX1 = [
  //   1600,    1800,    2000,    1100,    1150,    1250,    1300,    1700,    2000,    1550,    2250,    1850,    1250,    1350,    150,    700,    800,    300,    500,    600,    150,    1000,    2000,    1600,    2200  ];
  // List<double> buttonY1 = [
  //   330,   700,   200,    200,    750,    500,    800,    1000,    950,   850,    450,    1200,    1000,    1200,   1250,    1000,    550,    700,   150,   450,    50,    50,   50,   150,    600 ];
  // List<double> buttonX2 = [
  //   400,    1500,    2000,    1100,    1200,    1250,    300,    1700,    600,    1550,    2250,    1000,    1250,    1350,    1150,    700,    1800,    1300,    1500,    600,    1150,    1500,    2000,    1600,    2200  ];
  // List<double> buttonY2 = [
  //   630,   1700,   200,    200,    750,    900,    800,    1000,    950,   1850,    450,    1200,    1500,    1200,   1250,    1500,    550,    1700,   1150,   650,    1650,    550,   1150,   150,    1600 ];
  // List<double> buttonX3 = [
  //   1600,    1500,    2000,    1100,    1150,    150,    1300,    1700,    1500,    1550,    2250,    1550,    1250,    1350,    150,    1700,    800,    300,    1500,    600,    150,    1500,    2000,    1000,    2200  ];
  // List<double> buttonY3 = [
  //   330,   1700,   1200,    900,    750,    500,    800,    100,    950,   850,    1450,    1200,    1500,    1200,   1250,    1500,    550,    700,   150,   1450,    750,    50,   950,   1500,    600 ];
  // List<double> buttonX4 = [
  //   1600,    1800,    2000,    1100,    1550,    1250,    1300,    1700,    2000,    1050,   250,    1850,    1250,    1850,    150,    1700,    800,    300,    500,    1600,    150,    1000,    1000,    1600,    2000  ];
  // List<double> buttonY4 = [
  //   330,   1700,   1200,    200,    750,    1500,    800,    1500,    950,   1850,    450,    1200,    1000,    200,   1250,    1600,    550,    1700,   150,   450,    550,    50,   50,   150,    500 ];
  // List<double> buttonX5 = [
  //   1600,    1800,    2200,    1100,    1150,    1250,    2300,    1700,    2200,    1550,    2250,    850,    250,    1350,    150,    1700,    800,    1300,    500,    1600,    150,    1000,    1200,    1600,    2200  ];
  // List<double> buttonY5 = [
  //   330,   700,   200,    1200,    750,    1500,    800,    1000,    950,   850,    1450,    1200,    1500,   200,   1250,    1000,    1550,    700,   1150,   450,    1500,    50,   50,   1150,    600 ];

  List<List<double>>Bx=[
  [  1600,    1750,    2000,    1400,    1350,    250,    800,    1700,    2000,    1550,    2250,    1850,    250,    1350,    150,    700,    1800,    0,    1000,    600,    150,    1000,    300,    1600,    2200  ],
  [  400,    1500,    200,    2400,    200,    1250,    300,    1700,    600,    1850,    1250,    0,    750,    1350,    950,    2200,    1800,    1300,    1500,    200,    1150,    1500,    2000,    1600,    2200  ],
  [  100,    1800,    2400,    800,    150,    850,    2300,    1700,    2400,    1550,    650,    850,    250,    1350,    150,    1700,    1200,    300,    500,    1600,    950,    500,    1200,    1800,    2200  ]
  ];
  List<List<double>>By=[
  [  600,   700,   200,    200,    750,    900,    1200,    1200,    950,   850,    450,    1200,    1000,    1200,   1250,    1000,    550,    700,   500,   450,    550,    50,   50,   150,    600 ],
  [  230,   1300,   200,    200,    750,    1000,    1200,    800,    750,   600,    1150,    0,    600,    600,   120,    1000,    350,    300,   500,   450,    850,    50,   50,   350,    800 ],
  [  0,   700,   200,    1200,    750,    1000,    1250,    1200,    950,  600,    150,    600,    500,   400,   300,    1000,    950,    700,   1150,   450,    1200,    50,   750,   350,    600 ]
  ];
  List<double> buttonXtest = [
    800,
    1500,
    800,
    1500,
    800,
    1500,
    800,
    1500
  ];
  List<double> buttonYtest =[
    100,100,    400,400,    700,700,    1000,1000
  ];

      int index;
  Timer _timer; //计时器000
  Timer _timer2; //计时器
  int currentTime1 = 0; //辅助计时器你
  TMTQuestion _tmtQuestion = TMTQuestion(test: true); //初始化出题器
  final OneSec = const Duration(seconds: 1);
  CurrentState currentState = CurrentState.questionBegin; //初始化当前页面状态为Begin
  bool test = true; //是否为test阶段的标志
  int zhengque=0;
  int cuowu=0;
  int t;
  int zongTime1=0;
  int zongTime2=0;
  int temp=0;
  int lasttime=0;

  //中间显示的文字
  Map showText = {
    CurrentState.questionPrepare: "",
    CurrentState.doingQuestion: "",
  };

  //中间显示文字的颜色
  Map showTextColor = {
    CurrentState.questionPrepare: Colors.deepOrangeAccent,
    CurrentState.doingQuestion: Colors.blue[400],
  };

  void callbackzong (timer){

    setState(() {
      if(test==false&&currentState==CurrentState.doingQuestion){
        zongTime1++;
      }
      else{
        zongTime2++;
      }
    });
  }
  void start() {
    if(_timer2!=null&&_timer2.isActive){
      _timer2.cancel();
    }
    _timer2 = Timer.periodic(OneSec, callbackzong);
  }


  List<double> ListAnsX = [];
  List<double> ListAnsY = [];
  List<double> ListAnsXtest = [];
  List<double> ListAnsYtest = [];

  List<Widget> buildClickedButtons() {
    if(test==false){
      List<Widget> buttons = [];
      int a = temp_a;
      int b = temp_b;
      var buttonX=Bx[a];
      var buttonY=By[b];
      for (int i = 0; i < 25; i++) {
        ElevatedButton button = ElevatedButton(
          onPressed: currentState == CurrentState.doingQuestion
              ? () => buttonClicked1(i)
              : null,
          child: Container(
            child:
            Text(  (i + 1).toString(),
              style: TextStyle(fontSize: setSp(62), fontWeight: FontWeight.bold),
            ),
          ),

          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                i == index ? Colors.blue[700] : Color.fromARGB(255, 98, 78, 75)),
            elevation: MaterialStateProperty.all(setWidth(10)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(75))),
            )),
          ),
        );
        Positioned positioned = Positioned(
          left: setWidth(buttonX[i]),
          top: setHeight(buttonY[i]),
          child: Container(
            width: setWidth(150),
            height: setHeight(150),
            child: button,
          ),
        );
        buttons.add(positioned);
      }
      buttons.insert(0, CustomPaint(painter: StarView(ListAnsX, ListAnsY)));
      return buttons;
    }
    else{
      List<Widget> buttons = [];
      for (int i = 0; i < 8; i++) {
        ElevatedButton button = ElevatedButton(
          onPressed: (currentState == CurrentState.questionPrepare||currentState == CurrentState.doingQuestion)
              ? () => buttonClicked2(i)
              : null,
          child: Container(
            child:
            Text(            (i + 1).toString(),
              style: TextStyle(fontSize: setSp(70), fontWeight: FontWeight.bold),
            ),
          ),

          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                i == index ? Colors.blue[700] : Color.fromARGB(255, 98, 78, 75)),
            elevation: MaterialStateProperty.all(setWidth(10)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(75))),
            )),
          ),
        );
        Positioned positioned = Positioned(
          left: setWidth(buttonXtest[i]),
          top: setHeight(buttonYtest[i]),
          child: Container(
            width: setWidth(150),
            height: setHeight(150),
            child: button,
          ),
        );
        buttons.add(positioned);
      }
      buttons.insert(0, CustomPaint(painter: StarView(ListAnsXtest, ListAnsYtest)));
      return buttons;
    }

  }
  void buttonClicked2(index) {
    if(test==false){
      int a = temp_a;
      int b = temp_b;
      var buttonX=Bx[a];
      var buttonY=By[b];
      if(index==ListAnsX.length){
        zhengque=zhengque+1;
        ListAnsX.add(buttonX[ListAnsX.length]);
        ListAnsY.add(buttonY[ListAnsY.length]);
        lasttime=currentTime1;
      }else{
        cuowu=cuowu+1;
      }
      if(ListAnsX.length==25||zongTime1==300) {
        Map map = {
          "正确数": zhengque,
          "错误数": cuowu,
          "用时": zongTime1,
        };
        // String text = json.encode(map);
        // setAnswer(questionIdTMT,
        //     score: zhengque+1, answerText: text);
        Future.delayed(Duration(seconds: 2), () {
          //延时2秒后开始展示题目
          setState(() {
            t = zongTime1;
            currentState = CurrentState.questionAllDone;
            _timer.cancel();
            _timer2.cancel();
          });
        });

      }
    }else{
      if(index==ListAnsXtest.length){
        ListAnsXtest.add(buttonXtest[ListAnsXtest.length]);
        ListAnsYtest.add(buttonYtest[ListAnsYtest.length]);
        lasttime=currentTime1;
        print(ListAnsXtest.length);

      }
      if(ListAnsXtest.length==8){
        Future.delayed(Duration(seconds: 2), () {
          //延时2秒后开始展示题目
          setState(() {
            //改变当前状态
            test=false;
            currentState = CurrentState.doingQuestionPrepare;

          });
        });
      }
    }


  }

  void buttonClicked1(index) {
    if(currentState == CurrentState.doingQuestion&&test==false){
      int a = temp_a;
      int b = temp_b;
      var buttonX=Bx[a];
      var buttonY=By[b];
      var callback = (timer) => {
        setState(() {
          currentTime1++;
          if ((currentTime1-lasttime) % 10 == 0) {
            cuowu=cuowu+1;
            ListAnsX.add(buttonX[ListAnsX.length]);
            ListAnsY.add(buttonY[ListAnsY.length]);
            lasttime=currentTime1;
          }
          if(ListAnsX.length==25||zongTime1==300) {
            Map map = {
              "正确数": zhengque,
              "错误数": cuowu,
              "用时": zongTime1,
            };
            // String text = json.encode(map);
            // setAnswer(questionIdTMT,
            //     score: zhengque, answerText: text);
            Future.delayed(Duration(seconds: 2), () {
              //延时2秒后开始展示题目
              setState(() {
                t = zongTime1;
                currentState = CurrentState.questionAllDone;
                _timer.cancel();
                _timer2.cancel();
              });
            });
          }

        }),
      };
      setState(() {
        if(ListAnsX.length==25||zongTime1==300) {
          Future.delayed(Duration(seconds: 2), () {
            //延时2秒后开始展示题目
            setState(() {
              t = zongTime1;
              currentState = CurrentState.questionAllDone;
              _timer.cancel();
              _timer2.cancel();
            });
          });
        }
      });
      if(_timer!=null&&_timer.isActive){
        _timer.cancel();
      }
      _timer = Timer.periodic(OneSec, callback);
      if(test==false){
        if(index==ListAnsX.length){
          zhengque=zhengque+1;
          ListAnsX.add(buttonX[ListAnsX.length]);
          ListAnsY.add(buttonY[ListAnsY.length]);
          lasttime=currentTime1;
        }else{
          cuowu=cuowu+1;
        }
        if(ListAnsX.length==25||zongTime1==300) {
          Map map = {
            "正确数": zhengque,
            "错误数": cuowu,
            "用时": zongTime1,
          };
          String text = json.encode(map);
          setAnswer(questionIdTMT,
              score: zhengque, answerText: text);
          Future.delayed(Duration(seconds: 2), () {
            //延时2秒后开始展示题目
            setState(() {
              t = zongTime1;
              currentState = CurrentState.questionAllDone;
              _timer.cancel();
              _timer2.cancel();
            });
          });

        }
      }else{
        if(index==ListAnsXtest.length){
          ListAnsXtest.add(buttonXtest[ListAnsXtest.length]);
          ListAnsYtest.add(buttonYtest[ListAnsYtest.length]);
          lasttime=currentTime1;
          print(ListAnsXtest.length);

        }
        if(ListAnsXtest.length==8){
          Future.delayed(Duration(seconds: 1), () {
            //延时2秒后开始展示题目
            setState(() {
              //改变当前状态
              test=false;
              currentState = CurrentState.doingQuestionPrepare;

            });
          });
        }
      }
    }
  }
  Widget buildMainWidget() {
    return Stack(
      children: buildClickedButtons() +
          [
            // Center(
            //   child: Container(
            //     margin: EdgeInsets.only(bottom: setHeight(80)),
            //     width: setWidth(820),
            //     height: setHeight(120),
            //     decoration: BoxDecoration(
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.transparent.withOpacity(0.35),
            //           blurRadius: setWidth(5),
            //           offset: Offset(setWidth(0), setHeight(3)),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // Center(
            //   child: Text(
            //     showText[currentState],
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         fontSize: setSp(70), color: showTextColor[currentState]),
            //   ),
            // ),
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
              test ? "熟悉操作方法" : "正 式 测 试",
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
                  currentState = test?CurrentState.questionPrepare:CurrentState.doingQuestion;
                  start();
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
                height: setHeight(230),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: setHeight(30)),
                    Text(
                        "    正确数：" +
                            zhengque.toString() +
                            "    ",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text(
                        "    错误数：" +
                            cuowu.toString() +
                            "    ",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                    Text("     用时：" + t.toString() + "秒 ",
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
                testFinishedList[questionIdTMT]=true;
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
  Widget buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(150),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Text(
        test==true?"时间：$zongTime2 秒":"时间：$zongTime1 秒",
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    // QuestionInfo questionInfo =
    // Map.from(ModalRoute.of(context).settings.arguments)["questionInfo"];
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
                currentState == CurrentState.doingQuestionPrepare
                    ? buildFloatWidget()
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
  doingQuestionPrepare,
  doingQuestion, //开始答题
  questionAllDone //答题完毕
}
