import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/Pages/NewCharacter/NewCharacterTemp.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class CharacterWangPage extends StatefulWidget {
  static const routerName = "/CharacterWangPage";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CharacterWangPageState();
  }
}

class CharacterWangPageState extends State<CharacterWangPage> {

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  //强制退出
  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  //熟悉操作界面是否隐去
  bool knowOperationHidden=false;

  //熟悉+正式延时时间设置
  int knowDelayedTime=1;

  //是否展示结果界面
  bool showResult=true;

  //声明变量
  Timer _timer;
  //正式倒计时90s答题时间
  int _currentTime = 90;

  //倒计时操作
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
      setState(() {
        if (_currentTime < 1) {
          //倒计时结束操作
          _timer.cancel();
          //计时结束，固定时间
          _currentTime=0;
          //统计结果
          MainTestCompare();
          stop = true;
          setState(() {
            showResult=false;
          });
          // countRightOrWrongNumbers();
        } else {
          _currentTime = _currentTime - 1;
        }
      })
    };
    _timer = Timer.periodic(oneSec, callback);
  }

  //倒计时组件
  Widget buildTime() {
    return Text(
      '时间：' + _currentTime.toString() + 's',
      style: TextStyle(
          fontSize: setSp(60),
          fontWeight: FontWeight.w600,
          color: _currentTime > 10
              ? Colors.white
              : Color.fromARGB(255, 255, 0, 0)),
    );
  }


  //middle界面复制过来的
  //全局答题按键index
  int indexNum = -1;

  //10道题测试分数
  int testScore = 0;

  //显示10道测试题目总分
  String testScoreField = "";

  //110道题目是否可见
  bool mainTestHidden = true;

  //光标是否跳转(0未跳转，1该跳转，-1跳转完成)
  int cursorJump = 0;

  //正式题目得分
  int mainScore = 0;

  //所有题目答题框
  List testField = new List<String>.generate(120, (int i) {
    return "";
  });

  //所有题目答案
  List testAnswer = [
    //测试题目答案
    1, 5, 2, 1, 3, 6, 2, 4, 1, 6,
    //所有题目答案
    //前四行答案
    2, 1, 6, 1, 2,
    4, 6, 1, 2, 5, 6, 3, 4, 1, 2, 6, 9, 4, 3, 8,
    4, 5, 7, 8, 1, 3, 7, 4, 8, 5, 2, 9, 3, 4, 7,
    2, 4, 5, 1, 6, 4, 1, 5, 6, 7, 9, 8, 3, 6, 4,
    //后四行答案
    9, 5, 8, 3, 6, 7, 4, 5, 2, 3, 7, 9, 2, 8, 1,
    6, 9, 7, 2, 3, 6, 4, 9, 1, 7, 2, 5, 6, 8, 4,
    2, 8, 7, 9, 3, 7, 8, 5, 1, 9, 2, 1, 4, 3, 6,
    5, 2, 1, 6, 4, 2, 1, 6, 9, 7, 3, 5, 4, 8, 9
  ];

  //是否停止答题
  bool stop = false;

  //正式测试题110道的正误
  List testCorrect = new List<bool>.generate(110, (int i) {
    return false;
  });

  //10道测试题答案评分函数
  TestCompare() {
    for (int i = 0; i < 10; i++) {
      if (testField[i] != "") {
        if (int.parse(testField[i]) == testAnswer[i]) {
          testScore++;
        }
      }
    }
  }


  //上传数据
  sendData(){
    print("flag1 " + testField.toString());
    print("flag2 " + testCorrect.toString());
    String test_temp = "";
    for (int i = 10; i < 120; i++) {
      test_temp += testField[i];
    }
    String correct_temp = "";
    for (int j = 0; j < 110; j++) {
      if (testCorrect[j] == true) {
        correct_temp += "1";
      } else {
        correct_temp += "0";
      }
    }
    print("flag3 " + test_temp);
    print("flag4 " + correct_temp);
    print(mainScore);
    //print(answerTime);
    String answerMerge = "";
    answerMerge = test_temp + "&" + correct_temp;
    print("flag5 " + answerMerge);
    print(answerMerge.length);
    print(answerMerge.indexOf("&"));
    //上传数据到后台服务器
    //setAnswer(12,answerTimeDelta: answerTime, score: mainScore, answerText: answerMerge);
    setAnswer(questionIDSDMT, answerTimeDelta: 90-_currentTime, score: mainScore, answerText: answerMerge);
  }


  //110道测试题答案评分函数
  MainTestCompare() {
    for (int i = 10; i < 120; i++) {
      if (testField[i] != "") {
        if (int.parse(testField[i]) == testAnswer[i]) {
          mainScore++;
          testCorrect[i - 10] = true;
        }
      }
    }
  }


  //自定义控件
  //一个TextField范例，返回Expanded
  Widget My_Text(int i) {
    return Expanded(
      flex: 1,
      child: Align(
        child: Text(
          testField[i],
          style: TextStyle(
              color: testField[i] == "" ? Colors.white : Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w600),
        ),
        alignment: Alignment.center,
      ),
    );
  }

  //一行答题框示例，返回Expanded
  Widget My_Row(int m, int n, int flex) {
    //建立数组用于存放循环生成的widget
    List<Widget> temp = [];
    //单独一个widget组件，用于返回需要生成的内容widget
    Widget content;
    for (int i = m; i < n - 1; i++) {
      temp.add(My_Text(i));
      temp.add(VerticalDivider(
        width: 2.0,
        color: Colors.grey,
        thickness: 2.0,
      ));
    }
    temp.add(My_Text(n - 1));

    content = Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: new Border.all(width: 2.0, color: Colors.grey),
          color: Colors.white,
        ),
        child: Row(
          children: temp,
        ),
      ),
    );

    return content;
  }

  Widget My_FlatButton(int num) {
    return FlatButton(
      onPressed: () {
        if (stop) return;
        setState(() {
          if (indexNum < 9) {
            indexNum++;
          }
          if (cursorJump == -1 && indexNum > 9 && indexNum < 119) {
            indexNum++;
          }
          if (cursorJump == 1) {
            indexNum = 10;
            cursorJump = -1;
          }
          testField[indexNum] = num.toString();
        });
      },
      color: Colors.white,
      child: Text(
        num.toString(),
        style: TextStyle(
            fontSize: setSp(50), fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }


  //*顶部背景*
  Widget buildTopWidget() {
    return Expanded(
      flex: 4,
      child: Container(
        color: Color.fromARGB(200, 0, 0, 0),
        child: Row(
          children: <Widget>[
            //缩放闹钟图片
            Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 3, child: Text("")),
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/v2.0/clock.png'),
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter),
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: Text("")),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Align(
                  child: buildTime(),
                  alignment: Alignment.centerLeft,
                )),
            Expanded(flex: 10, child: Text("")),
          ],
        ),
      ),
    );
  }


  //*熟悉操作界面*
  Widget buildFloatWidget() {
    return Container(
      //确保占满屏幕宽度和高度
      width: maxWidth,
      height: maxHeight,
      color: Color.fromARGB(220, 150, 150, 150),
      child: Column(
        //主轴对齐位置
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //空间位置调整
          SizedBox(
            height: setHeight(100),
          ),
          Container(
            width: setWidth(700),
            height: setHeight(700),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.all(Radius.circular(setWidth(50))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      //数字越大越模糊。默认值是0，表示一点也不进行模糊
                      blurRadius: setWidth(10),
                      //阴影与容器的距离
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Text(
              "熟悉操作界面",
              style: TextStyle(fontSize: setSp(60)),
            ),
          ),
          SizedBox(
            height: setHeight(250),
          ),
          Container(
            width: setWidth(500),
            height: setHeight(120),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff418ffc), Color(0xff174cfc)],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(setWidth(1), setHeight(1)),
                    blurRadius: setWidth(5),
                  )
                ]),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                setState(() {
                  knowOperationHidden=true; //要隐藏
                });
                //熟悉延时函数
                // Future.delayed(Duration(seconds: knowDelayedTime), (){
                //   setState(() {
                //     knowDelayedShow=0; //开始延迟显示
                //   });
                // });
              },
              child: Text(
                "开始",
                style: TextStyle(color: Colors.white, fontSize: setSp(60)),
              ),
            ),
          ),
        ],
      ),
    );
  }


  //结束当前题目，交卷
  Widget nextButton(){
    return Expanded(
        flex: 2,
        child: Align(
          child: RaisedButton(
            color: Colors.white,
            splashColor: Colors.pinkAccent,
            onPressed: () {
              //倒计时结束操作，避免空点击
              if (_timer != null && _timer.isActive){
                _timer.cancel();
                //统计结果
                MainTestCompare();
                stop = true;
                setState(() {
                  showResult=false;
                });
              }
            },
            shape: Border.all(
                color: Colors.black45,
                style: BorderStyle.solid,
                width: 2),
            child: Text(
              "~~~~~~~提交测试结果~~~~~~~",
              style: TextStyle(
                  fontSize: setSp(40), fontWeight: FontWeight.w600),
            ),
          ),
          alignment: Alignment.bottomCenter,
        ));
  }


  Widget buildMiddleWidget(){
    return Row(
      children: <Widget>[
        //左边区域
        Expanded(
          flex: 5,
          child: Offstage(
            offstage: mainTestHidden, //这里控制
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                //第一行
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma1.png'),
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(""),
                      ),
                      My_Row(10, 15, 5),
                      Expanded(
                        flex: 2,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第二行
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma2.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      My_Row(15, 30, 15),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第三行
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma3.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      My_Row(30, 45, 15),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第四行
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma4.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      My_Row(45, 60, 15),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第五行
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma5.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      My_Row(60, 75, 15),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第六行
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma6.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      My_Row(75, 90, 15),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第七行
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma7.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      My_Row(90, 105, 15),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第八行
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma8.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      My_Row(105, 120, 15),
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
          ),
        ),
        VerticalDivider(
          width: 3.0,
          color: Color.fromARGB(50, 0, 0, 0),
          thickness: 2.0,
        ),
        //右边区域
        Expanded(
          flex: 3,
          child: Column(
            children: <Widget>[
              //符号编码对照表文字
              Expanded(
                flex: 1,
                child: Align(
                  child: Text(
                    "符号编码对照表",
                    style: TextStyle(
                        fontSize: setSp(40), fontWeight: FontWeight.w600),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ),
              //符号编码对照图片
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/example1.png'),
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/example2.png'),
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.bottomCenter),
                  ),
                ),
              ),
              //符号编码测试文字
              Expanded(
                flex: 1,
                child: Align(
                  child: Text(
                    "符号编码测试",
                    style: TextStyle(
                        fontSize: setSp(40), fontWeight: FontWeight.w600),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ),
              //符号编码测试图片
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/test.png'),
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter),
                  ),
                ),
              ),
              //测试答题框
              Container(
                height: setHeight(20),
              ),
              My_Row(0, 10, 1),
              Container(
                height: setHeight(10),
              ),
              // Expanded(flex: 1, child: Text("")),
              //测试结果分数
              Expanded(
                  flex: 1,
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                    Expanded(
                        flex: 2,
                        child: Align(
                          child: RaisedButton(
                            color: Colors.white,
                            splashColor: Colors.indigoAccent,
                            onPressed: () {
                              setState(() {
                                TestCompare();
                                testScoreField = "$testScore分";
                                //归零，避免重复点击分数累加
                                testScore = 0;
                              });
                            },
                            // 设置边框样式
                            shape: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 2),
                            child: Text(
                              "测试分数：",
                              style: TextStyle(
                                  fontSize: setSp(40),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          alignment: Alignment.bottomRight,
                        )),
                    Expanded(
                      flex: 1,
                      child: Align(
                          child: Text(
                            testScoreField,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                          alignment: Alignment.center),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                  ])),
              //开始正式测试
              Expanded(
                  flex: 2,
                  child: Align(
                    child: RaisedButton(
                      color: Colors.white,
                      splashColor: Colors.pinkAccent,
                      onPressed: () {
                        setState(() {
                          mainTestHidden = false;
                          cursorJump = 1;
                          //计时器
                          startCountdownTimer();
                        });
                      },
                      shape: Border.all(
                          color: Colors.black45,
                          style: BorderStyle.solid,
                          width: 2),
                      child: Text(
                        "~~~~~~~开始正式测试~~~~~~~",
                        style: TextStyle(
                            fontSize: setSp(40), fontWeight: FontWeight.w600),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                  )),
              // Expanded(flex: 1, child: Text("")),
              //数字键盘
              Expanded(
                  flex: 6,
                  child: Table(
                    border: TableBorder.all(
                        color: Colors.grey,
                        width: 1.0,
                        style: BorderStyle.solid),
                    children: <TableRow>[
                      //123
                      TableRow(
                        children: <Widget>[
                          My_FlatButton(1),
                          My_FlatButton(2),
                          My_FlatButton(3),
                        ],
                      ),
                      //456
                      TableRow(
                        children: <Widget>[
                          My_FlatButton(4),
                          My_FlatButton(5),
                          My_FlatButton(6),
                        ],
                      ),
                      //789
                      TableRow(
                        children: <Widget>[
                          My_FlatButton(7),
                          My_FlatButton(8),
                          My_FlatButton(9),
                        ],
                      ),
                      //空白,0,delete
                      TableRow(
                        children: <Widget>[
                          FlatButton(
                              color: Colors.white,
                              highlightColor: Colors.white,
                              child: Text("")),
                          My_FlatButton(0),
                          FlatButton(
                            onPressed: () {
                              if (stop) return;
                              setState(() {
                                if (indexNum > -1 &&
                                    indexNum < 10 &&
                                    cursorJump == 0) {
                                  indexNum--;
                                  testField[indexNum + 1] = "";
                                }
                                if (cursorJump == -1 &&
                                    indexNum > 9 &&
                                    indexNum < 120) {
                                  indexNum--;
                                  testField[indexNum + 1] = "";
                                }
                                if (cursorJump == 1) {
                                  indexNum = 9;
                                }
                              });
                            },
                            color: Colors.white,
                            child: Text(
                              "Del",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              nextButton(),
              Expanded(
                flex: 1,
                child: Text(""),
              ),
            ],
          ),
        ),
      ],
    );
  }




  double floatWindowRadios = 30;
  TextStyle resultTextStyle = TextStyle(
      fontSize: setSp(50), fontWeight: FontWeight.bold, color: Colors.blueGrey);

  //显示结果部件
  Widget buildResultWidget() {
    return Container(
      width: maxWidth,
      height: maxHeight,
      color: Color.fromARGB(220, 45, 45, 45),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: setHeight(200)),
          Container(
            width: setWidth(800),
            height: setHeight(450),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.all(
                    Radius.circular(setWidth(floatWindowRadios))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      blurRadius: setWidth(10),
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Column(children: [
              Container(
                height: setHeight(100),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow()],
                  color: Color.fromARGB(255, 229, 229, 229),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(setWidth(floatWindowRadios)),
                      topRight: Radius.circular(setWidth(floatWindowRadios))),
                ),
                child: Text(
                  "测验结果",
                  style: TextStyle(
                      fontSize: setSp(50),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: setHeight(30)),
                height: setHeight(230),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 5,
                          child: Align(
                            child:Text(
                                "正确数：" +
                                    mainScore.toString() +
                                    "      ",
                                style: resultTextStyle),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                        Expanded(
                            flex: 5,
                            child:Align(
                              child:Text(
                                  "答题用时：" + (90-_currentTime).toString() + " s",
                                  style: resultTextStyle),
                              alignment: Alignment.centerLeft,
                            )
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(height: setHeight(300)),
          Container(
            width: setWidth(500),
            height: setHeight(120),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.white,width: setWidth(1)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 253, 160, 60),
                  Color.fromARGB(255, 217, 127, 63)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(setWidth(1), setHeight(1)),
                  blurRadius: setWidth(5),
                )
              ],
            ),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (route) => false);
                sendData();
                //加入该题目结束标志
                testFinishedList[questionIDSDMT]=true;
              },
              child: Text(
                "结 束",
                style: TextStyle(color: Colors.white, fontSize: setSp(60)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //主界面布局
  @override
  Widget buildPage(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        //第一个child被绘制在最底端，后面的依次在前一个child的上面
        // 主界面
        Column(
          children: <Widget>[
            //上面4，下面29
            buildTopWidget(),
            //分界线
            Divider(
              height: 3.0,
              color: Color.fromARGB(120, 255, 0, 0),
              thickness: 3.0,
            ),
            Expanded(
                flex: 29,
                child: buildMiddleWidget(),
            ),
          ],
        ),
        //结果界面
        Offstage(
          offstage: showResult,
          child: buildResultWidget(),
        ),
        //医生形象
        showResult==false?Positioned(
          //设置距离四个边的距离
            right:setWidth(400),
            bottom: 0,
            child: Image.asset("images/v2.0/doctor_result.png", width: setWidth(480),)
        ):Container(),
        // // 正式界面
        // Offstage(
        //   offstage: checkOperationHidden,
        //   child: buildCheckWidget(),
        // ),
        //熟悉界面
        Offstage(
          offstage: knowOperationHidden,
          child: buildFloatWidget(),
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