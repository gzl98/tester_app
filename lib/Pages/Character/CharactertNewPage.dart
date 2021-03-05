import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Fragments/QuestionInfoFragment.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'CharacterMiddle.dart';
import 'package:tester_app/Utils/EventBusType.dart';


class CharacterNewPage extends StatefulWidget {
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
  int remainingTime=90;

  //TODO: 定义主体布局，长宽分别为1960*1350像素，设置大小时统一使用setWidth和setHeight，setSp函数，使用maxWidth和maxHeight不需要使用上述3个函数
  Widget buildMainWidget() {
    return Container(
      child:  CharacterPageMiddle(),
    );
  }

  //TODO: 定义下一题按钮的函数体
  buildButtonNextQuestion() {
      Navigator.pushNamedAndRemoveUntil(
          context, "/Maze", (route) => false);
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
