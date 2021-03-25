import 'dart:math';

//出题器
class SymbolQuestion {
  //基本的两张图片序号列表
  List<int> testBasicList = [];
  //对照的五章图片序号列表
  List<int> testContrastList = [];
  Random _random = Random();
  //记录测试的基本组评判序号
  int testBasicCount=0;
  //记录测试的对照组评判序号
  int testContrastCount=0;

  //产生基本的图片列表
  generateBasicRandom() {
    int count = 0; //统计获取的图片数量
    int long = getBasicLength(); //记录初始列表长度
    while (count < 2) {
      int tempNum = _random.nextInt(36) + 1;
      bool allow = true; //是否加入列表
      //去除重复图案出现
      for (int i = long; i < getBasicLength(); i++) {
        if (testBasicList[i] == tempNum) {
          allow = false;
        }
      }
      if (allow == true) {
        testBasicList.add(tempNum);
        count++;
      }
    }
  }

  //产生对照的图片列表
  generateContrastRandom() {
    int count = 0; //统计获取的图片数量
    int long = getContarstLength(); //记录初始列表长度
    while (count < 5) {
      int tempNum = _random.nextInt(36) + 1;
      bool allow = true; //是否加入列表
      //去除重复图案出现
      for (int i = long; i < testContrastList.length; i++) {
        if (testContrastList[i] == tempNum) {
          allow = false;
        }
      }
      if (allow == true) {
        testContrastList.add(tempNum);
        count++;
      }
    }
  }

  int getBasicLength() {
    return testBasicList.length;
  }

  int getContarstLength() {
    return testContrastList.length;
  }

  //返回两个数字的列表
  getBasicPictureNumber(){
    List temp=[];
    int long=getBasicLength();
    for(int i=long-2;i<long;i++){
      temp.add(testBasicList[i]);
    }
    return temp;
  }

  //返回五个数字的列表
  getContrastPictureNumber(){
    List temp=[];
    int long=getContarstLength();
    for(int i=long-5;i<long;i++){
      temp.add(testContrastList[i]);
    }
    return temp;
  }

}