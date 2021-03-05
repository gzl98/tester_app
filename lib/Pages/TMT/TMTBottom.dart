import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Rules.dart';
import 'package:tester_app/Utils/Utils.dart';
import '../../Utils/EventBusType.dart';

//页面底端组件
// ignore: must_be_immutable
class TMTPageBottom extends StatefulWidget{
  @override
  State<TMTPageBottom> createState() {
    // TODO: implement createState
    return TMTPageBottomState();
  }
}
class TMTPageBottomState extends State<TMTPageBottom>{
  Timer _timer;
  int _currentTime=300;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //startCountdownTimer();
      showConfirmDialog(context,tmtRules,startCountdownTimer);
    });
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
  Widget buildTime(){
    return Text(
      '倒计时：'+_currentTime.toString()+'s',
      style: TextStyle(
          fontSize: setSp(50),
          color: _currentTime>10 ? Color.fromARGB(255, 17, 132, 255) : Color.fromARGB(255, 255, 0, 0)
      ),
    );
  }
  Widget buildButtonNextQuestion(context,value) {
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
            if(value=='下一题'){

              //触发下一题事件
              eventBus.fire(NextEvent(0,300-this._currentTime));
              print('触发下一题！');
              Navigator.pushNamedAndRemoveUntil(
                  context, "/Character", (route) => false);
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
          child: Column(

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButtonNextQuestion(context, "下一题"),
              // Icon(Icons.keyboard_arrow_right,size: setSp(60),),
              // Text("下一题",style: _textStyle,)
            ],
          ),
        )
      ],
    );
  }
}

//评分单选按钮
class CheckScore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ScoreRadiaState();
  }
}

//单选按钮状态
class _ScoreRadiaState extends State<CheckScore> {
  int _score = 1;
  var _textStyle = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "请选择该测试者分数：",
            style: _textStyle,
          ),
          Radio(
            value: 1,
            groupValue: this._score,
            onChanged: (value) {
              setState(() {
                this._score = value;
              });
            },
          ),
          Text(
            "0分",
            style: _textStyle,
          ),
          SizedBox(width: 20),
          Radio(
            value: 2,
            groupValue: this._score,
            onChanged: (value) {
              setState(() {
                this._score = value;
              });
            },
          ),
          Text(
            "1分",
            style: _textStyle,
          ),
          SizedBox(width: 20),
          Radio(
            value: 3,
            groupValue: this._score,
            onChanged: (value) {
              setState(() {
                this._score = value;
              });
            },
          ),
          Text(
            "2分",
            style: _textStyle,
          ),
        ],
      ),
    );
  }
}

//页面底端工具栏
class ToolsBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: ButtonBar(
        children: [
          IconButton(icon: Icon(Icons.create), onPressed: null),
          IconButton(icon: Icon(Icons.undo), onPressed: null),
          IconButton(icon: Icon(Icons.clear), onPressed: null),
        ],
        mainAxisSize: MainAxisSize.max,
        alignment: MainAxisAlignment.center,
      ),
    );
  }
}
