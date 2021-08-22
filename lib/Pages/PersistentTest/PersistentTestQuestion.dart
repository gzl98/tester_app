import 'dart:math';

//出题器
class PersistentTestQuestion {
  //出题列表
  List _questions = [];
  Random _random = Random();

  // 定义左上0，右上1，左下2，右下3
  List getQuestion() {
    List temp=[0,0,0,0];
    int num=_random.nextInt(4);
    temp[num]=1;

    _questions=temp;
    return _questions;
  }
}
