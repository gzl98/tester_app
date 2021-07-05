import 'dart:math';

//出题器
class PairALQuestion {
  //数字序号列表
  List<int> characterList = [];
  Random _random = Random();
  //记录测试的基本组评判序号
  int  characterCount=0;


  //产生随机的数字
  generateNumberRandom() {
    int tempNum = _random.nextInt(9) + 1;
    characterList.add(tempNum);
  }

  int getListLength() {
    return characterList.length;
  }

  //返回最新一个数字
  getNewRandomNumber(){
    int long=getListLength();
    return characterList[long-1];
  }

}