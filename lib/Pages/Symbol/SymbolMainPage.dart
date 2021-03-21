import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/Utils.dart';

class SymbolMainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SymbolMainPageState();
  }
}

class SymbolMainPageState extends State<SymbolMainPage>{

  @override
  Widget buildPage(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        //*顶部背景*
        Expanded(
            flex:4,
            child:Container(
              color: Color.fromARGB(200, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  //缩放闹钟图片
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child:Text("")
                        ),
                        Expanded(
                            flex:7,
                            child:Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/clock.png'),
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.topCenter),
                              ),
                            ),
                        ),
                        Expanded(
                            flex: 3,
                            child:Text("")
                        ),
                      ],
                    )
                  ),
                  Expanded(
                    flex: 2,
                    child:Align(
                      child:Text("时间：120",style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: Colors.white),),
                      alignment: Alignment.centerLeft,
                    )
                  ),
                  Expanded(
                      flex: 10,
                      child:Text("")
                  ),
                ],
              ),
            ),
        ),
        Divider(
          height: 3.0,
          color: Color.fromARGB(120, 255, 0, 0),
          thickness: 3.0,
        ),
        //*底部图案*
        //上面空白间隔
        Expanded(
          flex: 7,
          child: Text(""),
        ),
        //图片区域
        Expanded(
          flex: 6,
          child: Row(
            children: <Widget>[
              //共33
              //空白左
              Expanded(
                flex: 6,
                child: Text(""),
              ),
              //图片左
              Expanded(
                flex: 6,
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(20, 0, 0, 0),
                      border: Border.all(color: Colors.blue,width: 3.0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  )
                )
              ),
              //空白中
              Expanded(
                flex: 1,
                child: Text(""),
              ),
              //图片+文字右
              Expanded(
                  flex: 15,
                  child: Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(20, 0, 0, 0),
                          border: Border.all(color: Colors.indigo[100],width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 2,
                          //准备框
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(""),
                              ),
                              //准备两个字
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  child:Text("准备",style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.w400, color: Colors.red[300],),),
                                    decoration: new BoxDecoration(
                                        // border: new Border.all(color: Color.fromARGB(20, 0, 0, 0), width: 0.5),
                                      border: Border(
                                          top: BorderSide(color: Color.fromARGB(20, 0, 0, 0), width: 0.5), // 上边边框
                                          right: BorderSide(color: Colors.transparent), // 右侧边框
                                          bottom: BorderSide(color: Color.fromARGB(20, 0, 0, 0), width: 5), // 底部边框
                                          left: BorderSide(color: Colors.transparent)), // 左侧边框
                                        gradient: LinearGradient(colors: [Colors.transparent,Color.fromARGB(1, 0, 0, 0),Colors.transparent],
                                            begin: Alignment.centerLeft, end: Alignment.centerRight),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromARGB(5, 0, 0, 0),
                                              offset: Offset(0.0, 6.0), //阴影y轴偏移量
                                              blurRadius: 0, //阴影模糊程度
                                              spreadRadius: 0 //阴影扩散程度
                                          )
                                        ],
                                    ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(""),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                      ],
                    ),
                  )
              ),
              //空白右
              Expanded(
                flex: 5,
                child: Text(""),
              ),
            ],
          ),
        ),
        //中间空白间隔
        Expanded(
          flex: 1,
          child: Text(""),
        ),
        //有无两个按键区域
        Expanded(
          flex: 14,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 25,
                child: Text(""),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  width: 250.0,
                  height: 260.0,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(5, 0, 0, 0),
                    border: Border.all(color: Colors.indigo[100],width: 2.0),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(5, 0, 0, 0),
                            offset: Offset(6.0, 6.0), //阴影x轴偏移量
                            blurRadius: 10, //阴影模糊程度
                            spreadRadius: 0 //阴影扩散程度
                        )
                      ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 10,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(""),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                //撑满组件维度
                                height: double.infinity,
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Colors.white,
                                  splashColor: Colors.pinkAccent,
                                  onPressed: (){
                                  },
                                  child: Text(
                                    "有",style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: Color.fromARGB(150, 0, 0, 0)),
                                  ),
                                ),
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(""),
                            ),
                            Expanded(
                              flex: 5,
                                child: Container(
                                  //撑满组件维度
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: RaisedButton(
                                    color: Colors.white,
                                    splashColor: Colors.pinkAccent,
                                    onPressed: (){
                                    },
                                    child: Text(
                                      "无",style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: Color.fromARGB(150, 0, 0, 0)),
                                    ),
                                  ),
                                )
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(""),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                )
              ),
              Expanded(
                flex: 1,
                child: Text(""),
              ),
            ],
          ),
        ),
        //下面空白间隔
        Expanded(
          flex: 1,
          child: Text(""),
        ),
      ],
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