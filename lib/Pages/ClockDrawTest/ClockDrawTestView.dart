import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/DrawWidget/DrawPainter.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/EventBusType.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class ClockDrawPage extends StatefulWidget {
  static const routerName = '/clockDrawTestPage';

  @override
  State<StatefulWidget> createState() {
    return ClockDrawPageState();
  }
}
class ClockDrawPageState extends State<ClockDrawPage> {
  int _currentCheckpoint=0;
  List<String> _imgPaths=["images/v4.0/ClockDraw/clock.png","images/v4.0/ClockDraw/clock_bg.png",""];

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();

  }

  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: Container(
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
                    _buildTopWidget(),
                    Container(
                      width: maxWidth,
                      height: setHeight(5),
                      color: Colors.red,
                    ),

                    Container(
                      width: maxWidth,
                      height: maxHeight - setHeight(155),
                      color: Color.fromARGB(255, 238, 241, 240),
                      child: _buildMainPaint(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(150),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Text(
        "时钟绘图测试"+((index){
          return " — 第"+(index+1).toString()+"关";
        }(this._currentCheckpoint)),
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }
  Widget _buildMainPaint(){
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            top: setHeight(150),
            left: setWidth(800),
            child: Text(
              "要求—请下面画出时间11:10",
              style: TextStyle(color: Colors.blueAccent, fontSize: setSp(55)),
            ),
        ),
        Positioned(
          // top: setHeight(150),
          // left: setWidth(500),
          width: setWidth(1500),
          height: setHeight(1000),
          child: MyPainterPage(imgPath:this._imgPaths[this._currentCheckpoint])
        ),

        Positioned(
          bottom: setHeight(50),
          left: setWidth(1100),
          child: buildButtonNextQuestion(context, "提交")
        ),
      ],
    );
  }
  //提交按钮
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
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: setSp(58)),
              )
            ],
          ),
          onPressed: () async {
            //弹出对话框并等待
            bool submit=await showSubmitDialog(this._currentCheckpoint);
            if(submit){
              if(this._currentCheckpoint<2){
                setState(() {
                  this._currentCheckpoint = this._currentCheckpoint+1;
                });
                eventBus.fire(NextPicture(this._imgPaths[this._currentCheckpoint]));
              }
              else{
                //进入下一关
                testFinishedList[questionIdDrawClock] = true;
                Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (route) => false);
              }
              print("**************:"+this._imgPaths[this._currentCheckpoint]);
            }
          }),
    );
  }

  // 弹出对话框
  Future<bool> showSubmitDialog(int currentCheckpoint) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("您确定提交当前答案，并进行下一关吗?"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("提交"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
                //提交函数
              },
            ),
          ],
        );
      },
    );
  }

}