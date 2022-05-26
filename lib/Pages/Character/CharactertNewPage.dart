import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Fragments/QuestionInfoFragment.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'CharacterMiddle.dart';
import 'package:tester_app/Utils/EventBusType.dart';

class CharacterNewPage extends StatefulWidget {

  static const routerName = "/CharacterNewPage";

  @override
  State<StatefulWidget> createState() {
    return CharacterNewPageState();
  }
}

class CharacterNewPageState extends State<CharacterNewPage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    //监听事件接受
    eventBus.on<ChractStartEvent>().listen((ChractStartEvent data) {
      startCountdownTimer();
    });
  }

  //TODO:定义题目名称，规则
  final String questionTitle = "符号编码";
  final String questionContent =
      "一.允许对照符号表填写\n二.禁止跳着填写，必须按顺序\n三.90秒时间内完成，110分满分";

  //TODO：根据情况定义分数和时间，不赋值即为不显示
  //剩余答题时间
  int remainingTime = 90;

  //是否停止答题
  bool stop = false;

  //TODO: 定义主体布局，长宽分别为1960*1350像素，设置大小时统一使用setWidth和setHeight，setSp函数，使用maxWidth和maxHeight不需要使用上述3个函数
  Widget buildMainWidget() {
    return Container(
      child: CharacterPageMiddle(stop: stop),
    );
  }


  double floatWindowRadios = 30;
  TextStyle resultTextStyle = TextStyle(
      fontSize: setSp(50), fontWeight: FontWeight.bold, color: Colors.blueGrey);


  // //显示结果部件
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
  //               testFinishedList[questionIdSymbol]=true;
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

  //TODO: 定义下一题按钮的函数体
  buildButtonNextQuestion() {
    if (_timer.isActive) _timer.cancel();
    Navigator.pushNamedAndRemoveUntil(context, "/MazeNew", (route) => false);
    //触发下一题事件+回传测试所用时间
    eventBus.fire(ChractSendDataEvent(1, 90 - this.remainingTime));
    print('触发下一题！');
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //左侧题目信息Fragment+
                child: QuestionInfoFragment(
                  questionTitle: questionTitle,
                  questionContent: questionContent,
                  remainingTime: remainingTime,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 230, 230),
                  // color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: setWidth(3),
                    ),
                  ],
                ),
                width: setWidth(560),
                height: maxHeight,
              ),
              Container(
                //右侧主要布局Fragment
                child: MainFragment(
                  mainWidget: buildMainWidget(),
                  onNextButtonPressed: buildButtonNextQuestion,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //计时器功能
  Timer _timer;

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            if (remainingTime < 1) {
              _timer.cancel();
              stop = true;
            } else {
              remainingTime = remainingTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  Widget buildTime() {
    return Text(
      '倒计时：' + remainingTime.toString() + 's',
      style: TextStyle(
          fontSize: setSp(50),
          color: remainingTime > 10
              ? Color.fromARGB(255, 17, 132, 255)
              : Color.fromARGB(255, 255, 0, 0)),
    );
  }
}
