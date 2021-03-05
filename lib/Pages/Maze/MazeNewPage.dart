
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/DrawWidget/DrawPainter.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Fragments/QuestionInfoFragment.dart';
import 'package:tester_app/Utils/EventBusType.dart';
import 'package:tester_app/Utils/Utils.dart';

class MazePage extends StatefulWidget {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //startCountdownTimer();
      showConfirmDialog(context,questionContent,startCountdownTimer);
    });
  }

  //TODO:定义题目名称，规则
  final String questionTitle = "迷宫";
  final String questionContent =
      "\t\t\t\t本题目主要考察问题与解决问题的能力，请用画笔从迷宫开始到结束。";

  //TODO：根据情况定义分数和时间，不定义即为不显示
  int score ;
  int remainingTime = 30;
  Timer _timer;

  //TODO: 定义主体布局，长宽分别为1960*1350像素，设置大小时统一使用setWidth和setHeight，setSp函数，使用maxWidth和maxHeight不需要使用上述3个函数
  Widget buildMainWidget() {
    return Container(
      // color: Colors.redAccent,
        child: MyPainterPage(imgPath: 'images/migong.jpeg',),
    );
  }
  void showConfirmDialog(BuildContext context,String content, Function confirmCallback) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("请阅读该题的规则"),
            content: new Text(content),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  confirmCallback();
                  Navigator.of(context).pop();
                },
                child: new Text("确认答题"),
              ),
            ],
          );
        });
  }
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
      setState(() {
        if (remainingTime < 1) {
          _timer.cancel();
        } else {
          remainingTime = remainingTime - 1;
        }
      })
    };
    _timer = Timer.periodic(oneSec, callback);
  }
  //TODO: 定义下一题按钮的函数体
  onNextButtonPressed() {
    if(this._timer.isActive) {this._timer.cancel();}
      eventBus.fire(NextEvent(2,30-this.remainingTime));
      Navigator.pushNamedAndRemoveUntil(
          context, "/BVMT", (route) => false);
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
                  score: score,
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
                  onNextButtonPressed: onNextButtonPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
