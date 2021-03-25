import 'dart:math';

import 'package:flutter/cupertino.dart';

class SingleStroopCard {
  String word;
  Color color;
  String sound;
  SingleStroopCard(this.word, this.color, this.sound);
  //判断文字颜色与语音是否符合
  bool checkSoundAndColor(){
    return true;
  }
  //判断文字意思与语音是否符合
  bool checkSoundAndWord(){
    print(this.word == this.sound);
    return this.word == this.sound;
  }
}

class CreateStroopTest {

  List<String> colorList = ["R","G","B"];
  List<String> wordList = ["红","绿","蓝"];
  List<Color> colorsList =
  [
    Color(0xFFFF0000),
    Color(0xFF46A315),
    Color(0xFF00A5FF),
    Color(0xFF000000)
  ];
  var _random = new Random();

  //出文字测验的题目，文字全部为黑色
  SingleStroopCard getSingleStroopWordTest(){
    int randWordIndex = this._random.nextInt(this.colorList.length);
    int randSoundIndex = this._random.nextInt(this.colorList.length);
    return SingleStroopCard(wordList[randWordIndex], colorsList[3], wordList[randSoundIndex]);
  }

  //获得文字测验的题目列表
  List<SingleStroopCard> getListStroopWordTest(int len){
    List<SingleStroopCard> tmpList= List();
    for(int i = 0; i<len;i++){
      tmpList.add(getSingleStroopWordTest());
    }
    return tmpList;
  }

}
