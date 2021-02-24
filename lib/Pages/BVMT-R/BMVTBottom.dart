import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Rules.dart';
import 'package:tester_app/Utils/Utils.dart';
import '../../Utils/EventBusType.dart';

//页面底端组件
// ignore: must_be_immutable
class BMVTPageBottom extends StatefulWidget{
  @override
  State<BMVTPageBottom> createState() {
    // TODO: implement createState
    return BMVTPageBottomState();
  }
}
class BMVTPageBottomState extends State<BMVTPageBottom>{
  Timer _timer;
  int _currentTime=10;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //startCountdownTimer();
      showConfirmDialog(context,bvmtRules,startCountdownTimer);
    });
  }
  void showConfirmDialog(BuildContext context,String content, Function confirmCallback) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(

            title: new Text("请阅读该题的规则: \n \n \n"
                "                                                                    在本题中，您将要对六个几何图案进行记忆，                                       \n \n\n"
                "                                                                    六个几何图案是以2×3的形式排列在画板上的，      \n \n\n"
                "                                                                    首先您有10s的学习时间，在10s后，图案会消失，      \n \n\n"
                "                                                                    您需要在空白画板上尽可能在正确的位置绘制出相应图案，       \n\n\n"
                "                                                                    如果您已准备好，点击确认答题按钮，10s倒计时即将开始。       \n\n\n"),
            content: new Text(content),
            elevation:5,
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
          eventBus.fire(TimeCutDown(10));
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
          color: _currentTime>3 ? Color.fromARGB(255, 17, 132, 255) : Color.fromARGB(255, 255, 0, 0)
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
            if(value=='上一题'){
              Navigator.pushNamedAndRemoveUntil(
                  context, "/SymbolEncoding", (route) => false);
            }
            else if(value=='下一题'){
              Navigator.pushNamedAndRemoveUntil(
                  context, "/completePage", (route) => false);
              //触发下一题事件
              eventBus.fire(NextEvent(4,30-this._currentTime));

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
              buildButtonNextQuestion(context,"下一题"),
              // Icon(Icons.keyboard_arrow_right,size: setSp(60),),
              // Text("下一题",style: _textStyle,)
            ],
          ),
        )

      ],
    );
  }
}



//页面底端工具栏
class ToolsBars extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: ButtonBar(
        children: [
          IconButton(
              icon: Icon(Icons.create),
              onPressed: null
          ),
          IconButton(
              icon: Icon(Icons.undo),
              onPressed: null
          ),
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: null
          ),
        ],
        mainAxisSize: MainAxisSize.max,
        alignment:MainAxisAlignment.center,
      ),
    );
  }
}