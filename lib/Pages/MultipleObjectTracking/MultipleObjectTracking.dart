import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/Utils.dart';

class BallItem {
  double x;
  double y;
  double radius;
  int id;
  int status;
  int originalStatus;

  BallItem(this.x, this.y, this.radius, this.status, this.id) {
    originalStatus = status;
  }

  Offset getOffset() {
    return Offset(x, y);
  }

  void moveTo(Offset position) {
    x = position.dx;
    y = position.dy;
  }

  bool collisionDetection(Offset position) {
    return ((position.dx - x) * (position.dx - x) +
            (position.dy - y) * (position.dy - y)) <
        (4 * radius * radius);
  }

  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint()
      ..color = status == 0 ? Colors.black : Colors.red
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = status == 0 ? PaintingStyle.stroke : PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), radius, _paint);
  }
}

class Painter extends CustomPainter {
  final List<BallItem> items;

  Painter({this.items});

  @override
  void paint(Canvas canvas, Size size) {
    for (BallItem item in items) {
      item.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class MultipleObjectTrackingQuestion {
  int questionHard;
  int questionTimes;
  int totalBallNumber;
  Random random = Random();
  List<int> pink = [];

  MultipleObjectTrackingQuestion() {
    questionHard = 0;
    questionTimes = 0;
    totalBallNumber = 0;
  }

  bool generateQuestion() {
    if (questionHard == 3 && questionTimes == 0) {
      return false;
    }
    pink.clear();
    if (questionHard == 0) {
      totalBallNumber = 8;
    } else if (questionHard == 1) {
      totalBallNumber = 9;
    } else {
      totalBallNumber = 11;
    }
    int counter = 0;
    while (true) {
      int index = random.nextInt(totalBallNumber);
      if (pink.indexOf(index) == -1) {
        counter++;
        pink.add(index);
      }
      if (counter == 3) {
        break;
      }
    }
    questionTimes++;
    if (questionTimes == 2) {
      questionTimes = 0;
      questionHard++;
    }
    return true;
  }

  List<int> getQuestion() {
    return pink;
  }
}

class MultipleObjectTrackingPage extends StatefulWidget {
  static final String routerName = "/MultipleObjectTrackingPage";

  @override
  State<StatefulWidget> createState() {
    return MultipleObjectTrackingPageState();
  }
}

class MultipleObjectTrackingPageState
    extends State<MultipleObjectTrackingPage> {
  List<BallItem> ballItems = [];
  int questionStatus = 0;
  int answerNumber = 0;
  bool canTouch = false;
  MultipleObjectTrackingQuestion multipleObjectTrackingQuestion =
      MultipleObjectTrackingQuestion();
  Timer moveTimer;
  Timer changeWhiteTimer;
  int timeCounter = 0;
  double linearProgressValue = 0.0;
  List<int> scores = [];

  @override
  void initState() {
    super.initState();
    questionStart();
  }

  void questionStart() {
    if (multipleObjectTrackingQuestion.generateQuestion()) {
      setState(() {
        canTouch = false;
        ballItems.clear();
        answerNumber = 0;
      });
      List<int> pink = multipleObjectTrackingQuestion.getQuestion();
      for (int i = 0; i < multipleObjectTrackingQuestion.totalBallNumber; i++) {
        if (pink.indexOf(i) == -1) {
          ballItems.add(BallItem(
              300 + (i % 4) * 125.0, 200 + (i ~/ 4) * 125.0, 20, 0, i));
        } else {
          ballItems.add(BallItem(
              300 + (i % 4) * 125.0, 200 + (i ~/ 4) * 125.0, 20, 1, i));
        }
      }
      timeCounter = 0;
      changeWhiteTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        if (timeCounter == 3000) {
          timeCounter = 0;
          linearProgressValue = 0.0;
          changeWhiteTimer.cancel();
          setState(() {
            for (BallItem ballItem in ballItems) {
              ballItem.status = 0;
            }
            ballStartMove();
          });
        } else {
          timeCounter += 10;
          setState(() {
            linearProgressValue = timeCounter / 3000;
          });
        }
      });
    } else {
      //question over
      setState(() {
        questionStatus = 1;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    moveTimer.cancel();
  }

  void ballStartMove() {
    Random random = Random();
    moveTimer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {
        if (timeCounter == 5000) {
          moveTimer.cancel();
          setState(() {
            canTouch = true;
          });
        }
        timeCounter += 20;
        linearProgressValue = timeCounter / 5000;
      });
      for (BallItem ballItem in ballItems) {
        while (true) {
          Offset endPosition = ballItem.getOffset() +
              Offset((random.nextDouble() - 0.5) * 10,
                  (random.nextDouble() - 0.5) * 10);
          if (endPosition.dx > 10 &&
              endPosition.dx < 990 &&
              endPosition.dy > 30 &&
              endPosition.dy < 590) {
            bool result = false;
            for (BallItem b in ballItems) {
              if (b.id != ballItem.id) {
                if (b.collisionDetection(endPosition)) {
                  result = true;
                  break;
                }
              }
            }
            if (!result) {
              setState(() {
                ballItem.moveTo(endPosition);
              });
              break;
            }
          }
        }
      }
    });
  }

  void changeBallColor(Offset position) {
    for (BallItem ballItem in ballItems) {
      if ((ballItem.x - position.dx) * (ballItem.x - position.dx) +
              (ballItem.y - position.dy) * (ballItem.y - position.dy) <
          ballItem.radius * ballItem.radius) {
        if (answerNumber == 3) {
          if (ballItem.status == 1) {
            setState(() {
              ballItem.status = ballItem.status == 0 ? 1 : 0;
              if (ballItem.status == 1) {
                answerNumber++;
              } else {
                answerNumber--;
              }
            });
          } else {
            Fluttertoast.showToast(
                msg: "提交的答案红球数不应该不大于3个，请先点击取消错误选择的红球。",
                gravity: ToastGravity.TOP
            );
          }
        } else {
          setState(() {
            ballItem.status = ballItem.status == 0 ? 1 : 0;
            if (ballItem.status == 1) {
              answerNumber++;
            } else {
              answerNumber--;
            }
          });
        }
        break;
      }
    }
  }

  Widget showQuestion() {
    return GestureDetector(
      child: Container(
        width: 1000,
        height: 600,
        child: CustomPaint(
            painter: Painter(items: ballItems),
            child: Container(
                child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 20,
                      width: 900,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                        value: linearProgressValue,
                      ),
                    ),
                    SizedBox(
                        height: 20,
                        width: 100,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0))),
                          ),
                          onPressed: () {
                            int tempScore = 0;
                            for (BallItem ballItem in ballItems) {
                              if (ballItem.originalStatus == 1 &&
                                  ballItem.status == 1) {
                                tempScore++;
                              }
                            }
                            scores.add(tempScore);
                            questionStart();
                          },
                          child: Text("确定"),
                        ))
                  ],
                ),
                // SizedBox(
                //   height: 50,
                // ),
                // Text('开始测试', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),)
              ],
            ))),
      ),
      onTapDown: (TapDownDetails details) {
        if (canTouch) {
          changeBallColor(details.globalPosition);
        }
      },
    );
  }

  Widget showResult() {
    TextStyle titleStyle = TextStyle(
        fontSize: setSp(45), fontWeight: FontWeight.w900, color: Colors.white);
    TextStyle contentStyle =
        TextStyle(fontSize: setSp(40), fontWeight: FontWeight.bold);
    List<TableRow> table = [
      TableRow(decoration: BoxDecoration(color: Colors.black54), children: [
        Container(
            alignment: Alignment.center,
            height: setHeight(120),
            child: Text("关卡", textAlign: TextAlign.center, style: titleStyle)),
        Text("分数", textAlign: TextAlign.center, style: titleStyle),
      ])
    ];
    for (int i = 0; i < scores.length; i++) {
      List<Widget> tableRow = [];
      tableRow.add(Container(
        alignment: Alignment.center,
        height: setHeight(100),
        child: Text((i + 1).toString(),
            textAlign: TextAlign.center, style: contentStyle),
      ));
      tableRow.add(Container(
        alignment: Alignment.center,
        height: setHeight(100),
        child: Text(scores[i].toString(),
            textAlign: TextAlign.center, style: contentStyle),
      ));
      table.add(TableRow(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 50, 50, 50)))),
          children: tableRow));
    }
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("测试结果",
                style: TextStyle(
                    fontSize: setSp(70),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            SizedBox(height: setHeight(80)),
            Container(
              width: setWidth(1000),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: table,
              ),
            ),
            SizedBox(height: setHeight(180)),
            ElevatedButton(
              onPressed: () {
                // testFinishedList[questionIdPictureSequenceMemoryTest] = false;
                Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (route) => false);
              },
              child: Text(
                "结 束",
                style: TextStyle(color: Colors.black, fontSize: setSp(60)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showPage() {
    switch (questionStatus) {
      case 0:
        return showQuestion();
      case 1:
        return showResult();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
        child: Scaffold(
          body: showPage(),
        ),
        onWillPop: () => showExitDialog(context));
  }
}
