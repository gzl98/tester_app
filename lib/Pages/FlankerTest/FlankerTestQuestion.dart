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
  //总出题次数
  int _answerNum = 0;
  //测试
  int _test_consistent = 0;
  int _test_inconsistent = 0;
  //正式
  int _main_consistent = 0;
  int _main_inconsistent = 0;

  //模拟测试为2次全等，2次不一致
  //正式测试前2次为全等测试。正式测试后18次为随机出现的全等or不一致测试（8次全等，10次不一致随机出现）
  List getQuestion() {
    //测试
    if(_answerNum<4) {
      int temp=_random.nextInt(4);
      if(temp<2){
        _test_consistent++;
      }else{
        _test_inconsistent++;
      }
      //测试时一致或者不一致达到限定数量
      if(_test_consistent>2){
        temp=_random.nextInt(2)+2;
      }
      if(_test_inconsistent>2){
        temp=_random.nextInt(2);
      }
      _questions=_candidateList[temp];
      _answerNum++;
    }else if(_answerNum<24 && _answerNum>=4)
    //正式
    {
      //前两次是一致的
      if(_answerNum<6){
        int temp=_random.nextInt(2);
        _questions=_candidateList[temp];
        _answerNum++;
      }else{
        int temp=_random.nextInt(4);
        if(temp<2){
          _main_consistent++;
        }else{
          _main_inconsistent++;
        }
        //正式时一致或者不一致达到限定数量
        if(_main_consistent>8){
          temp=_random.nextInt(2)+2;
        }
        //注意考虑要是连续11个不一致，第12个一致，就会出现Not in inclusive range 0..3: -2，不能temp-=2
        if(_main_inconsistent>10){
          temp=_random.nextInt(2);
        }
        _questions=_candidateList[temp];
        _answerNum++;
      }
    }

    return _questions;
  }
}
