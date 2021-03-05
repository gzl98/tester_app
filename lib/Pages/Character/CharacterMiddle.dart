import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/EventBusType.dart';
import 'package:tester_app/Utils/HttpUtils.dart';

//给出评分规则
const String characterRules = "1.允许对照符号表填写\n2.禁止跳着填写，必须按顺序\n3.90s时间内完成，110分满分";

//中间题目展示组件
class CharacterPageMiddle extends StatefulWidget {
  final bool stop;

  const CharacterPageMiddle({Key key, this.stop}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CharacterPageMiddleState();
  }
}

class CharacterPageMiddleState extends State<CharacterPageMiddle> {
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

  //动态初始化,重写函数
  @override
  void initState() {
    eventBus.on<ChractSendDataEvent>().listen((ChractSendDataEvent data) {
      sendData(data.value, data.answerTime);
    });
  }

  //上传题目编号以及答题时间
  sendData(value, answerTime) {
    MainTestCompare();
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
    print(answerTime);
    String answerMerge = "";
    answerMerge = test_temp + "&" + correct_temp;
    print("flag5 " + answerMerge);
    print(answerMerge.length);
    print(answerMerge.indexOf("&"));
    //上传数据到后台服务器
    setAnswer(value, answerTime, score: mainScore, answerText: answerMerge);
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
        if (widget.stop) return;
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
            fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        //中间区域
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
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
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
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ),
              //符号编码测试图片
              Expanded(
                flex: 2,
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
              My_Row(0, 10, 1),
              Expanded(flex: 1, child: Text("")),
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
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
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
                          eventBus.fire(ChractStartEvent(10));
                        });
                      },
                      shape: Border.all(
                          color: Colors.black45,
                          style: BorderStyle.solid,
                          width: 2),
                      child: Text(
                        "~~~~~~~开始正式测试~~~~~~~",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                  )),
              Expanded(
                flex: 1,
                child: Text(""),
              ),
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
                              if (widget.stop) return;
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
                  )),
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
}

// //右边信息栏
// class RightInfoColumn extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() =>
//       _TesterInfoState("XXX", "100s", characterRules, "未完成");
// }
//
// class _TesterInfoState extends State<RightInfoColumn> {
//   var personName = "";
//   var testTime = "";
//   var scoreRules = "";
//   var isFinish = "未完成";
//   var _titleStyle = TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600);
//   var _subTitleStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600);
//   var _normalStyle = TextStyle(
//     fontSize: 20.0,
//   );
//
//   _TesterInfoState(
//       this.personName, this.testTime, this.scoreRules, this.isFinish) {
//     print(this.scoreRules);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //每列宽度
//     var paddingEdage = EdgeInsets.all(6);
//     // TODO: implement build
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           color: Colors.black12,
//           child: Center(
//             child: Text("测试者信息", style: _titleStyle),
//           ),
//         ),
//         Divider(
//           height: 3.0,
//           color: Colors.blueGrey,
//           thickness: 1,
//         ),
//         Container(
//           padding: paddingEdage,
//           child: Row(children: <Widget>[
//             Text("测试者姓名：", style: _subTitleStyle),
//             Text(
//               this.personName,
//               style: _normalStyle,
//             )
//           ]),
//         ),
//         Container(
//           padding: paddingEdage,
//           child: Row(children: <Widget>[
//             Text("测试者是否完成：", style: _subTitleStyle),
//             Text(
//               this.isFinish,
//               style: _normalStyle,
//             )
//           ]),
//         ),
//         Container(
//           padding: paddingEdage,
//           child: Row(children: <Widget>[
//             Text("测试者用时：", style: _subTitleStyle),
//             Text(this.testTime, style: _normalStyle)
//           ]),
//         ),
//         Container(
//           padding: paddingEdage,
//           child: Text("评分规则", style: _subTitleStyle),
//         ),
//         Container(
//           padding: paddingEdage,
//           child: Text(this.scoreRules, style: _normalStyle),
//         ),
//       ],
//     );
//   }
// }
//
