import 'dart:math';

import 'package:flutter/cupertino.dart';
Map wordColorMap =
{
  "红":Color(0xFFFF0000),
  "绿":Color(0xFF46A315),
  "蓝":Color(0xFF00A5FF),
  "黑":Color(0xFF000000)
};
class SingleStroopCard {
  String word;
  //向前端显示的颜色
  Color color=Color(0xFF000000);
  String sound;
  //记录文字颜色的字符串
  String colorDisplay;

  SingleStroopCard(this.word, this.colorDisplay, this.sound){
    this.color=wordColorMap[this.colorDisplay];
  }
  //判断文字颜色与语音是否符合
  bool checkSoundAndColor(){
    return this.sound==this.colorDisplay;
  }
  //判断文字意思与语音是否符合
  bool checkSoundAndWord(){
    return this.word == this.sound;
  }
  //JSONDecode方法会调用该方法
  Map<String, String> toJson() =>
  {
    'word': word,
    'sound': sound,
    'color':colorDisplay,
  };
}

class CreateStroopTest {
  //产生word 声音 颜色
  List<String> wordList = ["红","绿","蓝"];

  var _random = new Random();

  //出文字测验的题目，文字全部为黑色
  SingleStroopCard getSingleStroopWordTest(){
    int randWordIndex = this._random.nextInt(this.wordList.length);
    int randSoundIndex = this._random.nextInt(this.wordList.length);
    return SingleStroopCard(wordList[randWordIndex], "黑", wordList[randSoundIndex]);
  }
  //出带颜色的文字的测试题目，文字不为黑色
  SingleStroopCard getSingleStroopColorWordTest(){
    int randWordIndex = this._random.nextInt(this.wordList.length);
    int randSoundIndex = this._random.nextInt(this.wordList.length);
    return SingleStroopCard(wordList[randWordIndex], "蓝", wordList[randSoundIndex]);
  }
  //出色词测验的题目，文字颜色随机，字随机,语音随机
  SingleStroopCard getSingleStroopWordColorTest(){
    int randWordIndex = this._random.nextInt(this.wordList.length);
    int randSoundIndex = this._random.nextInt(this.wordList.length);
    int randColoeIndex =this._random.nextInt(this.wordList.length);
    return SingleStroopCard(wordList[randWordIndex], wordList[randColoeIndex], wordList[randSoundIndex]);
  }
  //获得文字测验的题目列表
  List<SingleStroopCard> getListStroopWordTest(int len){
    List<SingleStroopCard> tmpList= List();
    for(int i = 0; i<len;i++){
      tmpList.add(getSingleStroopWordTest());
    }
    return tmpList;
  }
  //获得色词测验列表
  List<SingleStroopCard> getListStroopColorWordTest(int len){
    List<SingleStroopCard> tmpList= List();
    for(int i = 0; i<len;i++){
      tmpList.add(getSingleStroopColorWordTest());
    }
    return tmpList;
  }
  //获得词色测验列表
  List<SingleStroopCard> getListStroopWordColorTest(int len){
    List<SingleStroopCard> tmpList= List();
    for(int i = 0; i<len;i++){
      tmpList.add(getSingleStroopWordColorTest());
    }
    return tmpList;
  }

}

class StroopTestResultInfo {
  int _totalRect = 0;
  int _rightRect = 0;
  //记录每一个反应的标号
  List<int> rectIndexList=List<int>();
  //List记录每一个RectTime
  List<double> totalRectTime=List<double>();
  //记录每一个反应的结果
  List<bool> rectResult =List<bool>();

  int get totalRect => this._totalRect;
  int get rightRect => this._rightRect;

  //添加每一个反应的时间与结果
  void addSingleTimeResult(double rectTime,bool result,int index){
    this.rectIndexList.add(index);
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
