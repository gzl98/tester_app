import 'dart:math';

bool debug = false; //是否处于调试阶段

class NumberReasoningQuestion {
  Random _random = Random();
  int _maxLength = 5;

  //定义产生的最大数字,最小数字，最大间隔和最小间隔
  int _maxNumber = 40, _minNumber = 1, _maxDistance = 5, _minDistance = 2;
  int _totalQuestionCount = debug ? 2 : 8;
  int _questionIndex;
  int _currentAnswer;

  WMSQuestion() {}

  //获取下一道题目
  List<int> getQuestion() {
    _totalQuestionCount--;
    //生成下一道题目的缺省索引
    _questionIndex = _random.nextInt(_maxLength);
    //生成下一道题目
    int distance = _random.nextInt(_maxDistance - _minDistance) + _minDistance;
    int initialNumber = _random.nextInt(_maxNumber - _minNumber) + _minNumber;
    List<int> question = [initialNumber];
    if (_random.nextBool()) {
      for (int i = 1; i < _maxLength; ++i)
        question.add(question.last + distance + i);
    } else {
      for (int i = 1; i < _maxLength; ++i)
        question.insert(0, question.first + distance + i);
    }
    _currentAnswer = question[_questionIndex];
    return question;
  }

  List<int> getChoiceList() {
    int i = _random.nextInt(4);
    int x = _currentAnswer - i;
    List<int> choiceList = [];
    for (int i = 0; i < 4; i++) choiceList.add(x + i);
    choiceList.shuffle();
    return choiceList;
  }

  bool isEnd() {
    return _totalQuestionCount <= 0;
  }

  int get questionIndex => _questionIndex;

  int get currentAnswer => _currentAnswer;
}
