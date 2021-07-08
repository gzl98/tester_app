import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/GameEngine/GameEngine.dart';
import 'package:tester_app/Utils/Utils.dart';

class GooseFlyingSouthPage extends StatefulWidget {
  static const routerName = '/GooseFlyingSouthPage';

  @override
  State<StatefulWidget> createState() {
    return GooseFlyingSouthPageState();
  }
}

class GooseFlyingSouthPageState extends State<GooseFlyingSouthPage> {
  List<Item> itemList = [];
  bool start = false;
  int status = 0;

  Future<ui.Image> getAssetImage(String asset,{width,height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetWidth: width,targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void initState() {
    super.initState();
    gamePre();
    setState(() {
      start = true;
      status = 0;
    });
  }

  void gamePre() async {
    List<String> pictures = [
      'images/Goose/0.png', 'images/Goose/1.png', 'images/Goose/2.png',
      'images/Goose/3.png', 'images/Goose/4.png', 'images/Goose/5.png',
      'images/Goose/6.png', 'images/Goose/7.png',
    ];
    List<ui.Image> images = [];
    for (String picture in pictures) {
      ui.Image imageFrame = await getAssetImage(picture, width: 200, height: 200);
      images.add(imageFrame);
    }
    setState(() {
      itemList.add(Item(-100, 50, -100, 50, 1000, 50, 0.03, 200, () {}, images, 1));
      itemList.add(Item(-300, 300, -300, 300, 1000, 300, 0.03, 200, () {}, images, 1));
      itemList.add(Item(-750, 180, -750, 180, 1000, 180, 0.03, 200, () {}, images, 1));
      itemList.add(Item(-1300, 350, -1300, 350, 1000, 350, 0.03, 200, () {}, images, 1));
      itemList.add(Item(-1300, 80, -1300, 80, 1000, 80, 0.03, 200, () {}, images, 1));
    });
  }

  void gameEndCallback() {
    setState(() {
      start = false;
      status = 1;
    });
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
                              'demo end',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: setSp(70),
                                  fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(onPressed: () async {
                              List<String> pictures = [
                                'images/Goose/0.png', 'images/Goose/1.png', 'images/Goose/2.png',
                                'images/Goose/3.png', 'images/Goose/4.png', 'images/Goose/5.png',
                                'images/Goose/6.png', 'images/Goose/7.png',
                              ];
                              List<ui.Image> images = [];
                              for (String picture in pictures) {
                                ui.Image imageFrame = await getAssetImage(picture, width: 200, height: 200);
                                images.add(imageFrame);
                              }
                              setState(() {
                                itemList.clear();
                                itemList.add(Item(-100, 50, -100, 50, 1000, 50, 0.03, 200, () {}, images, 1));
                                itemList.add(Item(-300, 300, -300, 300, 1000, 300, 0.03, 200, () {}, images, 1));
                                itemList.add(Item(-750, 180, -750, 180, 1000, 180, 0.03, 200, () {}, images, 1));
                                itemList.add(Item(-1300, 350, -1300, 350, 1000, 350, 0.03, 200, () {}, images, 1));
                                itemList.add(Item(-1300, 80, -1300, 80, 1000, 80, 0.03, 200, () {}, images, 1));
                                start = true;
                                status = 0;
                              });
                            }, child: Text('重新开始'))
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: Stack(
          children: [
            GameEngine(itemList: itemList, start: start, gameEndCallback: gameEndCallback,),
            status == 1 ? buildFloatWidget() : Container(),
          ],
        )
      ),
    );
  }
}