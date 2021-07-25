import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/Utils.dart';

final int imageWidth = 100;
final int imageHeight = 60;

class PictureItem {
  double x;
  double y;
  double originalX;
  double originalY;
  int width;
  int height;
  int status;
  int position;
  List<ui.Image> pictures;

  PictureItem(this.originalX, this.originalY, this.x, this.y, this.height,
      this.width, this.status, this.pictures) {
    position = -1;
  }

  void move(double newX, double newY) {
    x = newX;
    y = newY;
  }

  void moveToOriginal() {
    x = originalX;
    y = originalY;
  }

  void setStatus() {
    if (status == 0) {
      width = imageWidth * 2;
      height = imageHeight * 2;
      status = 1;
    } else {
      width = imageWidth;
      height = imageHeight;
      status = 0;
    }
  }

  void paint(Canvas canvas, Size size) {
    canvas.drawImage(pictures[status], Offset(x, y), new Paint());
  }
}

class Painter extends CustomPainter {
  final List<PictureItem> items;
  final int number;

  Painter({this.items, this.number});

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    //左边
    for (int i = 0; i < number; i++) {
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(60, 100 + i * (400 / (number - 1))),
              width: imageWidth * 1.0,
              height: imageHeight * 1.0),
          _paint);
    }
    // canvas.drawRect(Rect.fromCenter(center: Offset(60, 100), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(60, 200), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(60, 300), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(60, 400), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(60, 500), width: 120, height: 80), _paint);

    //下面
    for (int i = 0; i < number; i++) {
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(220 + i * (560 / (number - 1)), 560),
              width: imageWidth * 1.0,
              height: imageHeight * 1.0),
          _paint);
    }
    // canvas.drawRect(Rect.fromCenter(center: Offset(220, 560), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(360, 560), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(500, 560), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(640, 560), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(780, 560), width: 120, height: 80), _paint);

    //右边
    for (int i = 0; i < number; i++) {
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(940, 100 + i * (400 / (number - 1))),
              width: imageWidth * 1.0,
              height: imageHeight * 1.0),
          _paint);
    }
    // canvas.drawRect(Rect.fromCenter(center: Offset(940, 100), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(940, 200), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(940, 300), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(940, 400), width: 120, height: 80), _paint);
    // canvas.drawRect(Rect.fromCenter(center: Offset(940, 500), width: 120, height: 80), _paint);

    //中间
    canvas.drawRect(
        Rect.fromCenter(center: Offset(500, 260), width: 700, height: 400),
        _paint);

    for (PictureItem item in items) {
      item.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class PictureSequenceMemoryTestPage extends StatefulWidget {
  static final routerName = "/pictureSequenceMemoryTest";

  @override
  State<StatefulWidget> createState() {
    return PictureSequenceMemoryTestPageState();
  }
}

class PictureSequenceMemoryTestPageState
    extends State<PictureSequenceMemoryTestPage> {
  List<PictureItem> pictureItems = [];
  int selectPictureItemIndex = -1;
  Offset imagePosition = Offset(0, 0);
  int number = 5;
  bool startGame = false;
  List<bool> isExist = [];
  List<Offset> startOffset = [];
  List<Offset> originalOffset = [];
  int ms = 0;
  int score = -1;
  int questionStatus = 0;
  Timer _timer;
  Timer _imageTimer;
  Timer _setToTimer;

  Future<ui.Image> getAssetImage(String asset, {width, height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void initState() {
    super.initState();
  }

  void questionStart(int n) {
    setState(() {
      questionStatus = 1;
      number = n;
      selectPictureItemIndex = -1;
      for (int i = 0; i < 15; i++) {
        originalOffset.add(Offset(160 + (i % 5) * 140.0, 100 + (i ~/ 5) * 130.0));
      }
      score = -1;
    });
    _imageTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      selectPictureItemIndex++;
      if (selectPictureItemIndex < 3 * number) {
        isExist.add(false);
        start();
      }
      if (selectPictureItemIndex == 3 * number) {
        _imageTimer.cancel();
        Future.delayed(Duration(milliseconds: 100), () {
          setToOriginal();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _setToTimer.cancel();
    _imageTimer.cancel();
  }

  void start() async {
    print("start: $selectPictureItemIndex");
    List<ui.Image> pictures = [
      await getAssetImage(
          'images/v4.0/PictureSequenceMemoryTest/数字' +
              (selectPictureItemIndex + 1).toString() +
              '.png',
          width: imageWidth * 3,
          height: imageHeight * 3),
      await getAssetImage(
          'images/v4.0/PictureSequenceMemoryTest/数字' +
              (selectPictureItemIndex + 1).toString() +
              '.png',
          width: imageWidth * 2,
          height: imageHeight * 2)
    ];
    setState(() {
      Random random = new Random();
      int idx = random.nextInt(originalOffset.length);
      Offset original = originalOffset[idx];
      originalOffset.removeAt(idx);
      pictureItems.add(PictureItem(
          original.dx,
          original.dy,
          500 - imageWidth * 1.5,
          300 - imageHeight * 1.5,
          imageWidth,
          imageHeight,
          0,
          pictures));
    });
    Future.delayed(Duration(seconds: 1), () {
      ms = 0;
      double x, y;
      if (selectPictureItemIndex < number) {
        x = 10;
        y = 70 + selectPictureItemIndex * (400 / (number - 1));
      } else if (selectPictureItemIndex >= number &&
          selectPictureItemIndex < 2 * number) {
        x = 170 + (selectPictureItemIndex - number) * (560 / (number - 1));
        y = 530;
      } else {
        x = 890;
        y = 70 +
            (number - 1 - (selectPictureItemIndex - 2 * number)) *
                (400 / (number - 1));
      }
      _timer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
        ms += 1;
        if (ms == 1500) {
          _timer.cancel();
        }
        pictureItems[selectPictureItemIndex].pictures[0] = await getAssetImage(
            'images/v4.0/PictureSequenceMemoryTest/数字' +
                (selectPictureItemIndex + 1).toString() +
                '.png',
            width: (3 * imageWidth - 2 * imageWidth * (ms / 1500)).floor(),
            height: (3 * imageHeight - 2 * imageHeight * (ms / 1500)).floor());
        setState(() {
          pictureItems[selectPictureItemIndex].move(
              500 -
                  imageWidth * 1.5 -
                  (500 - imageWidth * 1.5 - x) * (ms / 1500),
              300 -
                  imageHeight * 1.5 -
                  (300 - imageHeight * 1.5 - y) * (ms / 1500));
        });
      });
    });
  }

  void finishCheck() {
    print(isExist);
    for (int i = 0; i < 3 * number; i++) {
      print("$i, ${pictureItems[i].position}");
    }
    bool finish = true;
    for (bool r in isExist) {
      finish = finish && r;
    }
    if (finish) {
      for (int i = 0; i < 3 * number; i++) {
        print("$i, ${pictureItems[i].position}");
        if (i == pictureItems[i].position) {
          score++;
        } else {
          print(score);
          break;
        }
      }
    }
  }

  void setToOriginal() {
    ms = 0;
    for (PictureItem pictureItem in pictureItems) {
      startOffset.add(Offset(pictureItem.x, pictureItem.y));
    }
    _setToTimer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      ms += 1;
      if (ms == 1500) {
        _setToTimer.cancel();
        selectPictureItemIndex = -1;
        startGame = true;
      }
      setState(() {
        int i = 0;
        for (PictureItem pictureItem in pictureItems) {
          pictureItem.move(
              startOffset[i].dx -
                  (startOffset[i].dx - pictureItem.originalX) * (ms / 1500),
              startOffset[i].dy -
                  (startOffset[i].dy - pictureItem.originalY) * (ms / 1500));
          i++;
        }
      });
    });
  }

  bool inArea(double x, double y) {
    return x > pictureItems[selectPictureItemIndex].x &&
        x <
            pictureItems[selectPictureItemIndex].x +
                pictureItems[selectPictureItemIndex].width &&
        y > pictureItems[selectPictureItemIndex].y &&
        y <
            pictureItems[selectPictureItemIndex].y +
                pictureItems[selectPictureItemIndex].height;
  }

  void setImageTo() {
    double x, y;
    bool selected = false;
    int selectNumber = -1;
    for (int i = 0; i < 3 * number; i++) {
      if (i < number) {
        x = 10;
        y = 70 + i * (400 / (number - 1));
      } else if (i >= number && i < 2 * number) {
        x = 170 + (i - number) * (560 / (number - 1));
        y = 530;
      } else {
        x = 890;
        y = 70 + (number - 1 - (i - 2 * number)) * (400 / (number - 1));
      }
      if (inArea(x, y) &&
          inArea(x + 120, y) &&
          inArea(x, y + 80) &&
          inArea(x + 120, y + 80)) {
        selected = true;
        selectNumber = i;
        break;
      }
    }
    setState(() {
      if (selected && isExist[selectNumber] == false) {
        pictureItems[selectPictureItemIndex].move(x, y);
        pictureItems[selectPictureItemIndex].position = selectNumber;
        isExist[selectNumber] = true;
      } else {
        pictureItems[selectPictureItemIndex].moveToOriginal();
      }
    });
  }

  void checkExist() {
    setState(() {
      if (pictureItems[selectPictureItemIndex].position != -1) {
        isExist[pictureItems[selectPictureItemIndex].position] = false;
        pictureItems[selectPictureItemIndex].position = -1;
      }
    });
  }

  Widget showQuestion() {
    return GestureDetector(
      child: Container(
        width: 1000,
        height: 600,
        child: CustomPaint(
          painter: Painter(items: pictureItems, number: number),
        ),
      ),
      onPanStart: (DragStartDetails details) {
        if (startGame) {
          Offset offset = details.globalPosition;
          setState(() {
            int i = 0;
            for (PictureItem pictureItem in pictureItems) {
              if (offset.dx > pictureItem.x &&
                  offset.dx < pictureItem.x + pictureItem.width &&
                  offset.dy > pictureItem.y &&
                  offset.dy < pictureItem.y + pictureItem.height) {
                selectPictureItemIndex = i;
                imagePosition = Offset(
                    offset.dx - pictureItem.x, offset.dy - pictureItem.y);
                pictureItems[selectPictureItemIndex].setStatus();
                checkExist();
                break;
              } else {
                i++;
              }
            }
          });
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        if (startGame) {
          print(details.globalPosition);
          setState(() {
            if (selectPictureItemIndex != -1) {
              Offset offset = Offset(
                  max(-30, details.globalPosition.dx - imagePosition.dx),
                  max(0, details.globalPosition.dy - imagePosition.dy));
              pictureItems[selectPictureItemIndex].move(offset.dx, offset.dy);
            }
          });
        }
      },
      onPanEnd: (DragEndDetails details) {
        if (startGame) {
          setState(() {
            if (selectPictureItemIndex != -1) {
              setImageTo();
              pictureItems[selectPictureItemIndex].setStatus();
              selectPictureItemIndex = -1;
              finishCheck();
            }
          });
        }
      },
    );
  }

  Widget showSelect() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("难度选择", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: () { questionStart(2); }, child: Text("3-4", style: TextStyle(fontSize: 30.0))),
            ElevatedButton(onPressed: () { questionStart(3); }, child: Text("5-6", style: TextStyle(fontSize: 30.0))),
            ElevatedButton(onPressed: () { questionStart(4); }, child: Text("7-8", style: TextStyle(fontSize: 30.0))),
            ElevatedButton(onPressed: () { questionStart(5); }, child: Text("9+ ", style: TextStyle(fontSize: 30.0))),
          ],
        ),
      ),
    );
  }

  Widget showResult() {
    return Container();
  }

  Widget showPage() {
    switch(questionStatus) {
      case 0: return showSelect();
      case 1: return showQuestion();
      case 2: return showResult();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: questionStatus == 0 ? showSelect() : showQuestion(),
        ),
        onWillPop: () => showQuitDialog(context));
  }
}
