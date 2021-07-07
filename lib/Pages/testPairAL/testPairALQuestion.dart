import 'dart:math';

//出题器
class PairALQuestion {
  //问题真值列表
  List _questions = [];
  Random _random = Random();

  //题目数量
  int _questionSize;

  PairALQuestion(int size) {
    _questionSize = size;
  }

  //产生随机的图片位置以及图片选择，将之对应为一维矩阵，六个位置从上到下分别为0-5，四个图片的选择
  List getQuestion() {
    List tempQuestion = new List<int>.generate(6, (int i) {
      return -1;
    });
    List manyNum = [];
    for (int m = 0; m < _questionSize; m++) {
      int x = _random.nextInt(6);
      int y = _random.nextInt(4);
      //避免重复+过多出现
      bool temp = true;
      if (tempQuestion[x] != -1) {
        temp = false;
        m -= 1;
      } else {
        int index = manyNum.indexOf(y);
        if (index != -1) {
          temp = false;
          m -= 1;
        }
      }
      //真实赋值
      if (tempQuestion[x]== -1 && temp) {
        tempQuestion[x]= y;
      }
      //避免一道题出现多次，统计每个数字出现的次数
      List tempPicNum = new List<int>.generate(4, (int i) {
        return 0;
      });
      for (int i = 0; i < 6; i++) {
        if (tempQuestion[i] != -1) {
          tempPicNum[tempQuestion[i]]++;
        }
      }
      for (int i = 0; i < 4; i++) {
        if (tempPicNum[i] >= ((_questionSize / 2).ceil())) {
          manyNum.add(i);
        }
      }
    }
    _questions = tempQuestion;
    return _questions;
  }

  //获取答案，便于比较
  List getAnswer() {
    return _questions[_questionSize - 1];
  }
}
