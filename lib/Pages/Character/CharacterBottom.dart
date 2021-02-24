import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tester_app/Utils/EventBusType.dart';
import 'package:tester_app/Utils/Utils.dart';



class CharacterPageBottom extends StatefulWidget{
  @override
  State<CharacterPageBottom> createState() {
    // TODO: implement createState
    return CharacterPageBottomState();
  }
}
//页面底端组件
//ignore: must_be_immutable

class CharacterPageBottomState extends State<CharacterPageBottom>{
  Timer _timer;
  int _currentTime=90;
  @override
  void initState() {
    super.initState();
    eventBus.on<ChractStartEvent>().listen((ChractStartEvent data) => startCountdownTimer());
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
  var _textStyle=TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.w600
  );
  Widget buildTime(){
    return Text(
      '倒计时：'+_currentTime.toString()+'s',
      style: TextStyle(
          fontSize: setSp(50),
          color: _currentTime>10 ? Color.fromARGB(255, 17, 132, 255) : Color.fromARGB(255, 255, 0, 0)
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Icon(Icons.keyboard_arrow_left,size: 30.0,),
              Text("上一题",style: _textStyle,)
            ],
          ),
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
            children: [
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
              Text("下一题",style: _textStyle,)
            ],
          ),
        )

      ],
    );
  }
}