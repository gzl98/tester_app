import 'dart:math';

class WMSQuestion {
  WMSQuestion({test: true}) {
    _questionLengthList =
        test ? _questionLengthListTest : _questionLengthListFormal;
  }

  List _questionList = [];
  int _questionIndex;
  Random _random = Random();
  List _questionLengthList;
  List _questionLengthListTest = [3];

  // List _questionLengthListTest = [3, 3, 3];
  List _questionLengthListFormal = [3, 3];
  int maxLength = 0; //记录最大长度位数
  int correctCounts = 0; //记录正确数
  int wrongCounts = 0; //记录错误数

  // List _questionLengthListFormal = [
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

  void generateRandomQuestionList() {
    int len = _questionLengthList[_questionLengthIndex++];
    _questionIndex = len;
    _questionList.clear();
    while (len-- > 0) _questionList.add(_random.nextInt(10));
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
  }

  void questionWrong() => wrongCounts++;
}
