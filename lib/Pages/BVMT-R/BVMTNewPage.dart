import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/DrawWidget/DrawPainter.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Fragments/QuestionInfoFragment.dart';
import 'package:tester_app/Utils/EventBusType.dart';
import 'package:tester_app/Utils/Utils.dart';

class BVMTPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BVMTPageState();
  }
}

class BVMTPageState extends State<BVMTPage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //startCountdownTimer();
      showConfirmDialog(context, questionContent, startCountdownTimer);
    });
  }

  //TODO:定义题目名称，规则
  final String questionTitle = "BVMT";
  final String questionContent =
      "\t\t\t\t在本题中，您将要对六个几何图案进行记忆，六个几何图案是以2×3的形式排列在画板上的，首先您有10s的学习时间，在10s后，图案会消失，您需要在空白画板上尽可能在正确的位置绘制出相应图案，如果您已准备好，点击确认答题按钮，10s倒计时即将开始。";

  //TODO：根据情况定义分数和时间，不定义即为不显示
  int score;

  int remainingTime = 10;
  Timer _timer;
  bool panelShow = false;

  //TODO: 定义主体布局，长宽分别为1960*1350像素，设置大小时统一使用setWidth和setHeight，setSp函数，使用maxWidth和maxHeight不需要使用上述3个函数
  Widget buildMainWidget() {
    return Container(
      // color: Colors.redAccent,
      child: !this.panelShow
          ? Image.asset(
              "images/BVMT.jpg",
              fit: BoxFit.fill,
            )
          : MyPainterPage(
              imgPath: "images/blank.jpg",
            ),
    );
  }

  void showConfirmDialog(
      BuildContext context, String content, Function confirmCallback) {
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
            if (remainingTime <= 0) {
              changeImg();
              _timer.cancel();
              startCountdownTimer_1();
            } else {
              remainingTime = remainingTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  void startCountdownTimer_1() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            remainingTime = remainingTime + 1;
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  void changeImg() {
    setState(() {
      panelShow = !panelShow;
    });
  }

  //TODO: 定义下一题按钮的函数体
  onNextButtonPressed() {
    if (this._timer.isActive) {
      this._timer.cancel();
    }
    if (this.panelShow) {
      eventBus.fire(NextEvent(3, this.remainingTime));
      Navigator.pushNamedAndRemoveUntil(
          context, "/completePage", (route) => false);
    }
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
