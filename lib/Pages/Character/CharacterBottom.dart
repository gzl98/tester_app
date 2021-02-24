import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tester_app/Utils/EventBusType.dart';
import 'package:tester_app/Utils/Utils.dart';

class CharacterPageBottom extends StatefulWidget {
  @override
  State<CharacterPageBottom> createState() {
    // TODO: implement createState
    return CharacterPageBottomState();
  }
}
//页面底端组件
//ignore: must_be_immutable

class CharacterPageBottomState extends State<CharacterPageBottom> {
  Timer _timer;
  int _currentTime = 90;

  @override
  void initState() {
    super.initState();
    eventBus
        .on<ChractStartEvent>()
        .listen((ChractStartEvent data) => startCountdownTimer());
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            if (_currentTime < 1) {
              _timer.cancel();
            } else {
              _currentTime = _currentTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  var _textStyle = TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600);

  Widget buildTime() {
    return Text(
      '倒计时：' + _currentTime.toString() + 's',
      style: TextStyle(
          fontSize: setSp(50),
          color: _currentTime > 10
              ? Color.fromARGB(255, 17, 132, 255)
              : Color.fromARGB(255, 255, 0, 0)),
    );
  }

  Widget buildButtonNextQuestion(context, value) {
    return SizedBox(
      width: setWidth(260),
      height: setHeight(120),
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(30)))),
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.keyboard_arrow_right,size: setSp(80),),
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: setSp(58)),
              )
            ],
          ),
          onPressed: () {
            if (value == '下一题') {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/Maze", (route) => false);
              //触发下一题事件
              eventBus.fire(ChractSendDataEvent(1, 90 - this._currentTime));
              print('触发下一题！');
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Column(),
        ),
        Expanded(
          flex: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTime(),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButtonNextQuestion(context, "下一题"),
            ],
          ),
        )
      ],
    );
  }
}
