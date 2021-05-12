import 'dart:math';

class TMTQuestion {
  List<int> _questionList = [];
  int _questionIndex;
  Random _random = Random();
  List<int> _questionLengthList;
  //List<int> _questionLengthListTest = [3];

  List<int> _questionLengthListTest = [3,3];
  List<int> _questionLengthListFormal = [3, 3];
  int maxLength = 0; //记录最大长度位数
  int correctCounts = 0; //记录正确数
  int wrongCounts = 0; //记录错误数
  Map<String, List<int>> result = {};

  // List<int> _questionLengthListFormal = [
  //   3,
  //   3,
  //   4,
  //   4,
  //   5,
  //   5,
  //   6,
  //   6,
  //   7,
  //   7,
  //   8,
  //   8,
  //   9,
  //   9,
  //   10,
  //   10
  // ];
  int _questionLengthIndex = 0;

  TMTQuestion({test: true}) {
    _questionLengthList =
    test ? _questionLengthListTest : _questionLengthListFormal;
    for (var l in _questionLengthListFormal) result[l.toString()] = [];
    maxLength = _questionLengthListFormal[0];
  }

  void generateRandomQuestionList({bool needZero: true}) {
    int len = _questionLengthList[_questionLengthIndex++];
    _questionIndex = len;
    _questionList.clear();
    while (len-- > 0)
      _questionList
          .add(needZero ? _random.nextInt(10) : _random.nextInt(9) + 1);
  }

  int getNextQuestion({bool reverse = false}) {
    if (hasNextIndex())
      _questionIndex--;
    else
      throw Exception("题目不存在!");
    if (reverse) return _questionList[getCurrentLength() - 1 - _questionIndex];
    return _questionList[_questionIndex];
  }

  int getCurrentLength() {
    //由于之前生成题目时对索引进行了递增，所以此处需要减1
    return _questionLengthList[_questionLengthIndex - 1];
  }

  bool currentQuestionIsDone() {
    return _questionIndex <= 0;
  }

  bool questionAllDone() {
    return _questionLengthIndex >= _questionLengthList.length;
  }

  void resetIndex() {
    _questionIndex = _questionList.length;
  }

  bool hasNextIndex() {
    if (_questionIndex > 0) {
      // _questionIndex--;
      return true;
    }
    return false;
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
