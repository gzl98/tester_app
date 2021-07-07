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
    });
    // Future.delayed(Duration(seconds: 10), () {
    //   setState(() {
    //     start = false;
    //   });
    // });
  }

  void gamePre() async {
    List<String> pictures = [
      'images/Goose/11.png', 'images/Goose/12.png', 'images/Goose/13.png',
      'images/Goose/14.png', 'images/Goose/15.png', 'images/Goose/16.png',
      'images/Goose/17.png', 'images/Goose/18.png', 'images/Goose/19.png',
    ];
    List<ui.Image> images = [];
    for (String picture in pictures) {
      ui.Image imageFrame = await getAssetImage(picture, width: 200, height: 200);
      images.add(imageFrame);
    }
    setState(() {
      itemList.add(Item(-100, 100, -100, 100, 2000, 100, 0.1, 190, () {}, images, 1));
      itemList.add(Item(-300, 500, -300, 500, 2000, 500, 0.1, 190, () {}, images, 1));
      itemList.add(Item(-750, 300, -750, 500, 2000, 500, 0.1, 190, () {}, images, 1));
    });
  }

  void gameEndCallback() {

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: GameEngine(itemList: itemList, start: start,),
      ),
    );
  }
}