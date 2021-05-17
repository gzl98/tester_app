import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/MemoryMatrix/MemoryMatrixQuestion.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class MemoryMatrixPage extends StatefulWidget {
  static const routerName = '/memoryMatrixPage';

  @override
  State<StatefulWidget> createState() {
    return MemoryMatrixPageState();
  }
}

class MemoryMatrixPageState extends State<MemoryMatrixPage> {
  int currentState = 0;
  MemoryMatrixQuestion memoryMatrixQuestion;
  List question;
  int questionSize;
  int questionNum;
  int currentAnswerNum;
  bool finishedTest = false;
  int correctNumber;
  int maxCorrectNumber;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    memoryMatrixQuestion = MemoryMatrixQuestion();
    correctNumber = 0;
    maxCorrectNumber = 0;
    question = [
      [0, 0],
      [0, 0]
    ];
    questionSize = 2;
    startGame();
  }

  void dispose() {
    super.dispose();
  }

  void startGame() {
    setState(() {
      currentAnswerNum = 0;
      questionNum = memoryMatrixQuestion.questionNum;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        currentState = 1;
        questionSize = memoryMatrixQuestion.questionSize;
        question = memoryMatrixQuestion.getQuestion();
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            currentState = 2;
            for (int i = 0; i < questionSize; i++) {
              for (int j = 0; j < questionSize; j++) {
                question[i][j] = 0;
              }
            }
          });
        });
      });
    });
  }

  selectMatrix(i, j) {
    List answer = memoryMatrixQuestion.getAnswer();
    setState(() {
      if (answer[i][j] == 1) {
        currentAnswerNum++;
        question[i][j] = 1;
      } else {
        currentState = 0;
        question[i][j] = 1;
        if (questionNum < 5)
          startGame();
        else
          finishedTest = true;
      }
      if (currentAnswerNum == questionNum + 1) {
        correctNumber++;
        currentState = 0;
        question[i][j] = 1;
        maxCorrectNumber = questionNum;
        if (questionNum < 5)
          startGame();
        else
          finishedTest = true;
      }
    });
  }

  Widget buildRow(i, n) {
    List<Widget> row = [];
    for (int j = 0; j < n; j++) {
      row.add(InkWell(
        onTap: currentState == 2 ? () => {selectMatrix(i, j)} : null,
        child: new Container(
          width: setWidth(200),
          height: setHeight(200),
          color: question[i][j] == 0 ? Colors.white : Colors.orange,
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: row,
    );
  }

  Widget buildColumn(n) {
    List<Widget> column = [];
    for (int i = 0; i < n; i++) {
      column.add(buildRow(i, n));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: column,
    );
  }

  Widget buildTopWidget() {
    return Container(
      width: maxWidth,
      height: setHeight(150),
      alignment: Alignment.center,
      child: currentState % 3 == 2
          ? Text(
              '找出刚刚出现的橙色方块！',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: setSp(62),
                  fontWeight: FontWeight.bold),
            )
          : Text(
              '记住橙色方块出现的位置！',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: setSp(62),
                  fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget buildMainTestWidget() {
    List<double> baseSize = [100, 80, 40];
    if (questionSize == 3) {
      baseSize = [130, 110, 70];
    }
    if (questionSize == 4) {
      baseSize = [160, 140, 100];
    }
    return Stack(
      children: [
        Center(
            child: Column(
          children: [
            SizedBox(
              height: setHeight(300),
            ),
            Container(
              width: setWidth(baseSize[0] + questionSize * 200),
              height: setHeight(baseSize[0] + questionSize * 200 + 20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                        blurRadius: 15.0, //阴影模糊程度
                        spreadRadius: 2.0 //阴影扩散程度
                        )
                  ]),
              child: Center(
                child: Container(
                  width: setWidth(baseSize[1] + questionSize * 200),
                  height: setWidth(baseSize[1] + questionSize * 200),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Container(
                        width: setWidth(baseSize[2] + questionSize * 200),
                        height: setWidth(baseSize[2] + questionSize * 200),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: buildColumn(questionSize)),
                  ),
                ),
              ),
            ),
          ],
        ))
      ],
    );
  }

  Widget buildFloatWidget() {
    return Stack(
      children: [
        Container(
          width: maxWidth,
          height: maxHeight,
          color: Color.fromARGB(220, 150, 150, 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: setHeight(100),
              ),
              Center(
                child: Container(
                    width: setWidth(600),
                    height: setHeight(400),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                              blurRadius: 15.0, //阴影模糊程度
                              spreadRadius: 1.0 //阴影扩散程度
                              )
                        ]),
                    child: Center(
                      child: Container(
                        width: setWidth(550),
                        height: setHeight(350),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: setHeight(70),
                            ),
                            Text(
                              '目标：' + (questionNum + 1).toString() + '个',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: setSp(70),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '准备',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: setSp(80),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildResultWidget() {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              SizedBox(
                height: setHeight(500),
              ),
              Center(
                child: Container(
                  width: setWidth(1000),
                  height: setHeight(500),
                  decoration: new BoxDecoration(
                    border:
                        new Border.all(color: Colors.blue, width: 5), // 边色与边宽度
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "最多记忆个数:",
                            style: TextStyle(
                              fontSize: setSp(68),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (maxCorrectNumber + 1).toString() + "个",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: setSp(72),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "                正确率:",
                            style: TextStyle(
                              fontSize: setSp(68),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (correctNumber / (questionNum + 1) * 100)
                                    .toStringAsFixed(2) +
                                "%",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: setSp(72),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (correctNumber * 100 ~/ (questionNum + 1))
                                .toString(),
                            style: TextStyle(
                              color: Colors.brown,
                              fontSize: setSp(100),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: setHeight(350),
              ),
              Center(
                child: Container(
                  width: setWidth(400),
                  height: setHeight(150),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.green, Colors.green],
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
                      testFinishedList[questionIdMemoryMatrix] = true;
                      Navigator.pushNamedAndRemoveUntil(
                          context, TestNavPage.routerName, (route) => false);
                      setState(() {});
                      print(1);
                    },
                    child: Text(
                      "继续",
                      style:
                          TextStyle(color: Colors.white, fontSize: setSp(60)),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: finishedTest
            ? buildResultWidget()
            : Container(
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
                          buildTopWidget(),
                          buildMainTestWidget(),
                        ],
                      ),
                    ),
                    currentState % 3 == 0 ? buildFloatWidget() : Container(),
                  ],
                ),
              ),
      ),
    );
  }
}
