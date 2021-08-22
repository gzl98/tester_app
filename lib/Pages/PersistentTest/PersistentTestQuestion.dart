import 'dart:math';

//出题器
class FlankerTestQuestion {
  //出题列表
  List _questions = [];
  Random _random = Random();
  // 出题候选列表
  List _candidateList = [
    [0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1],
    [0, 0, 1, 0, 0],
    [1, 1, 0, 1, 1]
  ];

  List getQuestion() {

    return _questions;
  }
}
