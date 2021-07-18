import 'dart:math';

bool debug = true; //是否处于调试阶段
// bool debug = false; //是否处于调试阶段

class FlashLightQuestion {
  List<int> _questionList = [];
  int _questionIndex;
  Random _random = Random();
  List<int> _questionLengthList = debug ? [2, 3] : [2, 4, 6, 8, 10, 12];

  int maxLength = 0; //记录最大长度位数
  int correctCounts = 0; //记录正确数
  int wrongCounts = 0; //记录错误数
  Map<String, List<int>> result = {};

  int _questionLengthIndex = 0;
  int max;

  FlashLightQuestion(int max) {
    this.max = max;
    //构造答案数组
    for (var l in _questionLengthList) result[l.toString()] = [];
    //初始化第一道题
    maxLength = _questionLengthList[0];
  }

  //生成题目
  void generateRandomQuestionList() {
    int len = _questionLengthList[_questionLengthIndex++];
    _questionIndex = len;
    _questionList.clear();
    _questionList.add(_random.nextInt(max));
    len--;
    bool isSame = false;
    while (len-- > 0) {
      int num = _random.nextInt(max);
      bool b = num == _questionList[_questionList.length - 1];
      if (isSame && b) num = (num + _random.nextInt(max - 1) + 1) % max;
      _questionList.add(num);
      isSame = b;
    }
  }

  //获取下一道题目
  int getNextQuestion({bool reverse = false}) {
    if (!currentQuestionIsDone())
      _questionIndex--;
    else
      throw Exception("题目不存在!");
    if (reverse) return _questionList[getCurrentLength() - 1 - _questionIndex];
    return _questionList[_questionIndex];
  }

  //获取当前题目的长度
  int getCurrentLength() {
    return _questionList.length == 0
        ? _questionLengthList.first
        : _questionList.length;
  }

  //判断当前题目是否完成
  bool currentQuestionIsDone() {
    return _questionIndex <= 0;
  }

  //判断所有题目是否完成
  bool questionAllDone() {
    return _questionLengthIndex >= _questionLengthList.length;
  }

  //重置当前问题索引，开始做题
  void resetIndex() {
    _questionIndex = _questionList.length;
  }

  void questionCorrect() {
    correctCounts++;
    maxLength = getCurrentLength();
    result[getCurrentLength().toString()].add(1);
  }

  void questionWrong() {
    wrongCounts++;
    result[getCurrentLength().toString()].add(0);
  }

  //获取题目信息，由于出题时是倒序出题，所以此处进行翻转
  List<int> getQuestionList({bool reverse = false}) {
    return reverse ? _questionList.toList() : _questionList.reversed.toList();
  }
}
