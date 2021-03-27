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

class StroopTestResultInfo {
  int _totalRect = 0;
  int _rightRect = 0;

  //List记录每一个RectTime
  List<double> totalRectTime=List<double>();
  //记录每一个反应的结果
  List<bool> rectResult =List<bool>();

  int get totalRect => this._totalRect;
  int get rightRect => this._rightRect;

  //添加每一个反应的时间与结果
  void addSingleTimeResult(double rectTime,bool result){
    print(rectTime);
    this.totalRectTime.add(rectTime);
    this.rectResult.add(result);
    if(result)  this._rightRect++;
    this._totalRect++;
  }
  //错误反应数
  int getErrorRectCount(){
    return this._totalRect-this._rightRect;
  }
  //计算
  //算平均反应时间_正确反应的平均
  double getMeanRectTime(){
    double sum=0;
    for(int i=0;i<this.totalRect;i++){
      if(this.rectResult[i]==true){
        sum+=this.totalRectTime[i];
      }
    }
    //ms
    return (sum / this._rightRect)*100;
  }
}
