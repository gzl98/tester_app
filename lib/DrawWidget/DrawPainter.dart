import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'WpPainter.dart';
import 'ColorPicker.dart';
import 'dart:ui' as ui;
import '../Utils/EventBusType.dart';
import 'package:path_provider/path_provider.dart';

//自定义画布画图组件
class SelfForePainter extends CustomPainter {
  ui.Image _imageFrame;

  SelfForePainter(this._imageFrame) : super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint selfPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 10.0;
    canvas.drawImage(_imageFrame, Offset(0, 0), selfPaint);
  }

  @override
  bool shouldRepaint(SelfForePainter oldDelegate) {
    return oldDelegate._imageFrame!=this._imageFrame;
  }
}

class _MyPainter extends CustomPainter {
  _MyPainter(this.points);

  final List<WPPainter> points;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()..strokeCap = StrokeCap.round;

    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        var wp = points[i];
        var nextWp = points[i + 1];
        paint.color = wp.color;
        paint.strokeWidth = wp.strokeWidth;
        canvas.drawLine(wp.point, nextWp.point, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_MyPainter oldDelegate) {
    return oldDelegate.points != this.points;
  }
}

class MyPainterPage extends StatefulWidget {
  final String imgPath;
  const MyPainterPage({
    Key key,
    this.imgPath
  }):super(key: key);
  @override
  _MyPainterPageState createState() => _MyPainterPageState();
}

class _MyPainterPageState extends State<MyPainterPage> {
  List<WPPainter> _points = <WPPainter>[];
  Color _paintColor = blackColor;
  double _paintStokeWidth = 1.0;
  double _bottomBarLeft = 44.0;
  ui.Image _assetImageFrame;
  //画图的Path
  String _imgPath;
  //截图获取的key
  GlobalKey rootWidgetKey = GlobalKey();

  //截图获取的图片
  List<Uint8List> images = List();

  @override
  void initState() {
    super.initState();
    this._imgPath=widget.imgPath;
    _getAssetImage();
    //监听到下一题事件时触发->截图
    eventBus.on<NextEvent>().listen((NextEvent data) => capturePng(data.value,data.answerTime));
  }

  //获取本地图片
  _getAssetImage() async {
    ui.Image imageFrame = await getAssetImage(this._imgPath,
        width: double.parse(setWidth(2000).toString()).toInt(),
        height: double.parse(setWidth(1000).toString()).toInt());

    setState(() {
      print(imageFrame);
      _assetImageFrame = imageFrame;
    });
  }

  //截图方法
  capturePng(index,time) async {
    try {
      print('监听到下一题信号！-执行截图方法');
      RenderRepaintBoundary boundary =
          rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      /*保存图片*/
      Directory appDocPath = await getApplicationDocumentsDirectory();
      String appDocPathString=appDocPath.path;
      final imageFile = File(appDocPathString+"/capture.png");
      images.add(pngBytes);
      print("appDocPath= " +
          appDocPathString +
          " imageFile= " +
          imageFile.path.toString());
      await imageFile.writeAsBytes(pngBytes);
      setAnswer(3, time, imagePath: imageFile.path.toString(),imageName: 'capture.png');
      //保存图片到相册的方法
      //saveToPictures(pngBytes);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            _bottomBarLeft = 16.0;
          } else {
            _bottomBarLeft = 44.0;
          }
          Color color3 = materialColors[0];
          if (_paintColor.value != blackColor.value &&
              _paintColor.value != redColor.value) {
            color3 = _paintColor;
          }
//          rotationPoints(orientation, size);
          return ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  child: RepaintBoundary(
                    key: rootWidgetKey,
                    child: CustomPaint(
                      painter: SelfForePainter(_assetImageFrame),
                      size: Size(setWidth(2000), setWidth(1000)),
                      foregroundPainter: _MyPainter(_points),
                      //child:Image.network("https://th.bing.com/th/id/R7ef1a6ba075098acb8075590a18337f7?rik=9e4NScfJ%2fTiFiA&riu=http%3a%2f%2fpic41.nipic.com%2f20140529%2f2531170_210244691000_2.jpg&ehk=a5ab0TIr49%2bQklED87xF63bD0yG7z4jxMx4%2fYkXYvgs%3d&risl=&pid=ImgRaw") ,
                    ),
                  ),
                  onPanUpdate: (detail) {
                    RenderBox referenceBox = context.findRenderObject();
                    Offset localPosition =
                        referenceBox.globalToLocal(detail.globalPosition);

                    setState(() {
                      _points = new List.from(_points)
                        ..add(WPPainter(
                            localPosition, _paintColor, _paintStokeWidth));
                    });
                  },
                  onPanEnd: (detail) => _points.add(null),
                ),
                //黑色按钮
                bottomCircleColorButton(whiteColor, 0),
                //红色按钮
                bottomCircleColorButton(redColor, 1),
                //白色按钮
                bottomCircleColorButton(blackColor, 2),
                //其他颜色
                //bottomCircleColorButton(color3, 2),
                //画笔大小
                bottomPencilWidthButton(0),
                bottomPencilWidthButton(1),
                bottomPencilWidthButton(2),
                bottomPencilWidthButton(3),
                bottomPencilWidthButton(4),
                bottomPencilWidthButton(5),
              ],
            ),
          );
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ///
  /// @param color 按钮颜色
  /// @param index 第一个黑色 第二个红色 第三个选择
  ///
  Widget bottomCircleColorButton(Color color, int index) {
    double left = _bottomBarLeft + index * 48 + 10 * index;
    return Positioned(
      bottom: 44,
      left: left,
      child: GestureDetector(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: color,
              boxShadow: _paintColor.value == color.value
                  ? [
                      BoxShadow(
                        color: Color(0xFF8E8E93),
                        spreadRadius: 2.0,
                      ),
                    ]
                  : [],
              borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
        onTap: () {
          if (index == 0) {
            _setPaintColor(whiteColor);
          } else if (index == 1) {
            _setPaintColor(redColor);
          } else {
            _pickerColor();
          }
        },
      ),
    );
  }

  ///
  /// 笔尖大小
  ///
  Widget bottomPencilWidthButton(int index) {
    double left = _bottomBarLeft + (3 + index) * 48 + 5 * (3 + index) + 20;
    double size = 12.0 + (index * 3);
    double bottom = 44.0 + (48.0 - size) / 2;
    bool isChecked = false;
    switch (index) {
      case 0:
        if (_paintStokeWidth == 1.0) {
          isChecked = true;
        }
        break;
      case 1:
        if (_paintStokeWidth == 2.0) {
          isChecked = true;
        }
        break;
      case 2:
        if (_paintStokeWidth == 3.0) {
          isChecked = true;
        }
        break;
      case 3:
        if (_paintStokeWidth == 6.0) {
          isChecked = true;
        }
        break;
      case 4:
        if (_paintStokeWidth == 9.0) {
          isChecked = true;
        }
        break;
      case 5:
        if (_paintStokeWidth == 12.0) {
          isChecked = true;
        }
        break;
    }
    return Positioned(
      bottom: bottom,
      left: left,
      child: GestureDetector(
        child: Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
              shape:
                  CircleBorder(side: BorderSide(width: isChecked ? 4.0 : 1.0))),
        ),
        onTap: () {
          switch (index) {
            case 0:
              _paintStokeWidth = 1.0;
              break;
            case 1:
              _paintStokeWidth = 2.0;
              break;
            case 2:
              _paintStokeWidth = 3.0;
              break;
            case 3:
              _paintStokeWidth = 6.0;
              break;
            case 4:
              _paintStokeWidth = 9.0;
              break;
            case 5:
              _paintStokeWidth = 12.0;
              break;
          }
          setState(() {});
        },
      ),
    );
  }

  ///打开颜色选择器
  void _pickerColor() {
    showColorPicker(context, _paintColor, (color) {
      _setPaintColor(color);
    });
  }

  ///设置颜色
  void _setPaintColor(color) {
    if (color != null) {
      setState(() {
        _paintColor = color;
      });
    }
  }
}
