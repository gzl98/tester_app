import 'dart:async';
// import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/Pages/PairAssoLearning/PairAssoLearningQuestion.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class PairALMainPage extends StatefulWidget {
  static const routerName = "/PairALMainPage";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PairALMainPageState();
  }
}

class PairALMainPageState extends State<PairALMainPage> {

  //出题器
  PairALQuestion pairALQuestion;
  //初始化页面状态为题目闪烁
  CurrentState currentState;
  //应答题数目/出题数目
  int questionSize;
  //答题数目统计
  int questionNum;
  //目前按键数目
  int currentAnswerNum;
  //每次的答案矩阵，先4再6
  List question;
  //当前状态
  CurrentState state;
  //当前关卡数
  int checkpoint;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    startGame();
  }

  //强制退出
  @override
  void dispose() {
    super.dispose();
    // if (_timer != null && _timer.isActive) _timer.cancel();
  }

  //初始化参数
  void startGame(){
    setState(() {
      checkpoint=1;
      questionSize=2;
      currentAnswerNum=0;
      currentState = CurrentState.questionPrepare;
    });
  }

  //橘色框
  Widget squareYellowBox(){
    return Expanded(
        flex: 1,
        child:Align(
          child: Container(
            width: setWidth(270),
            height: setHeight(270),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 242, 204),
                border: Border.all(color: Colors.orangeAccent, width: 2.0),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/v4.0/PairAL/'+"circular"+'.png'),
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                      ],
                    )
                ),
                Expanded(
                  flex: 1,
                  child: Text(""),
                )
              ],
            ),
          ),
          alignment: Alignment.bottomCenter,
        )
    );
  }

  //绿色框
  Widget squareGreenBox(String temp){
    return Expanded(
        flex: 1,
        child:Align(
          child: Container(
            width: maxWidth,
            height: maxHeight,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 213, 232, 212),
              border: Border.all(color: Colors.teal, width: 2.0),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text(""),
                ),
                Expanded(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/v4.0/PairAL/'+temp+'.png'),
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                  )
                              ),
                            ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                      ],
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Text(""),
                )
              ],
            )
          ),
          alignment: Alignment.bottomCenter,
        )
    );
  }

  //上面的六个框
  Widget buildTopWidget(){
    return Expanded(
        flex: 4,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Align(
                            child: Container(
                              width: maxWidth,
                              height: setHeight(160),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 3.0),
                              ),
                              child: Align(
                                child: Text('第'+checkpoint.toString()+'关',
                                  style: TextStyle(
                                    fontSize: setSp(60),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            alignment: Alignment.topCenter,
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(""),
                      ),
                      squareYellowBox(),
                      Expanded(
                        flex: 4,
                        child: Text(""),
                      ),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Row(
                    children: <Widget>[
                      squareYellowBox(),
                      Expanded(
                          flex: 7,
                          child: Text("")
                      ),
                      squareYellowBox(),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Row(
                    children: <Widget>[
                      squareYellowBox(),
                      Expanded(
                          flex: 7,
                          child: Text("")
                      ),
                      squareYellowBox(),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(""),
                      ),
                      squareYellowBox(),
                      Expanded(
                        flex: 4,
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

  //下面的四个图案
  Widget buildBottomWidget(){
    return Expanded(
        flex: 1,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Text(""),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Text(""),
                      ),
                      squareGreenBox('square'),
                      squareGreenBox('circular'),
                      squareGreenBox('triangle'),
                      squareGreenBox('cross'),
                      Expanded(
                        flex: 7,
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

  // double floatWindowRadios = 30;
  // TextStyle resultTextStyle = TextStyle(
  //     fontSize: setSp(50), fontWeight: FontWeight.bold, color: Colors.blueGrey);

  //显示结果部件
  // Widget buildResultWidget() {
  //   return Container(
  //     width: maxWidth,
  //     height: maxHeight,
  //     color: Color.fromARGB(220, 45, 45, 45),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SizedBox(height: setHeight(200)),
  //         Container(
  //           width: setWidth(800),
  //           height: setHeight(450),
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //               color: Color.fromARGB(255, 229, 229, 229),
  //               borderRadius: BorderRadius.all(
  //                   Radius.circular(setWidth(floatWindowRadios))),
  //               boxShadow: [
  //                 BoxShadow(
  //                     color: Color.fromARGB(255, 100, 100, 100),
  //                     blurRadius: setWidth(10),
  //                     offset: Offset(setWidth(1), setHeight(2)))
  //               ]),
  //           child: Column(children: [
  //             Container(
  //               height: setHeight(100),
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 boxShadow: [BoxShadow()],
  //                 color: Color.fromARGB(255, 229, 229, 229),
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(setWidth(floatWindowRadios)),
  //                     topRight: Radius.circular(setWidth(floatWindowRadios))),
  //               ),
  //               child: Text(
  //                 "测验结果",
  //                 style: TextStyle(
  //                     fontSize: setSp(50),
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.blue),
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(top: setHeight(30)),
  //               height: setHeight(230),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                       Expanded(
  //                         flex: 5,
  //                         child: Align(
  //                           child:Text(
  //                               "正确数：" +
  //                                   correctNumber.toString() +
  //                                   "      ",
  //                               style: resultTextStyle),
  //                           alignment: Alignment.centerLeft,
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                       Expanded(
  //                         flex: 5,
  //                         child:Align(
  //                           child:Text(
  //                               "错误数：" + wrongNumber.toString() + "      ",
  //                               style: resultTextStyle),
  //                           alignment: Alignment.centerLeft,
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                       Expanded(
  //                           flex: 5,
  //                           child:Align(
  //                             child:Text(
  //                                 "准确率：" + correctPercent.toString() + " %",
  //                                 style: resultTextStyle),
  //                             alignment: Alignment.centerLeft,
  //                           )
  //                       ),
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ]),
  //         ),
  //         SizedBox(height: setHeight(300)),
  //         Container(
  //           width: setWidth(500),
  //           height: setHeight(120),
  //           decoration: BoxDecoration(
  //             // border: Border.all(color: Colors.white,width: setWidth(1)),
  //             gradient: LinearGradient(
  //               begin: Alignment.topCenter,
  //               end: Alignment.bottomCenter,
  //               colors: [
  //                 Color.fromARGB(255, 253, 160, 60),
  //                 Color.fromARGB(255, 217, 127, 63)
  //               ],
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black54,
  //                 offset: Offset(setWidth(1), setHeight(1)),
  //                 blurRadius: setWidth(5),
  //               )
  //             ],
  //           ),
  //           child: TextButton(
  //             style: ButtonStyle(
  //                 backgroundColor:
  //                 MaterialStateProperty.all(Colors.transparent)),
  //             onPressed: () {
  //               Navigator.pushNamedAndRemoveUntil(
  //                   context, TestNavPage.routerName, (route) => false);
  //               sendData();
  //               //加入该题目结束标志
  //               testFinishedList[questionIdNewCharacter]=true;
  //             },
  //             child: Text(
  //               "结 束",
  //               style: TextStyle(color: Colors.white, fontSize: setSp(60)),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  //主界面布局
  @override
  Widget buildPage(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Color.fromARGB(255, 218, 232, 252),
      width: maxWidth,
      height: maxHeight,
      child: Column(
        children: <Widget>[
          buildTopWidget(),
          Divider(height: 3.0, color: Color.fromARGB(120, 255, 0, 0), thickness: 3.0,),
          buildBottomWidget(),
        ],
      ),
    );
  }


  //解决显示黑黄屏的问题,Scaffold的问题导致的
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: buildPage(context),
      ),
    );
  }
}

//多个状态
enum CurrentState {
  questionPrepare, //题目闪烁
  doingQuestion, //答题时间
  questionDone, //答题完毕
}