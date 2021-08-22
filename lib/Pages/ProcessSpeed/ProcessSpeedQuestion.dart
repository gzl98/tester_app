import 'dart:math';

bool debug = true; //是否处于调试阶段
// bool debug = false; //是否处于调试阶段

class ProcessSpeedQuestion {
  List<List> _questionList = [];
  Random _random = Random();

  int _maxIndex = debug ? 3 : 15; //记录最大长度位数
  int _currentIndex = -1;
  List<int> _spentTime; //记录所用时间，单位毫秒
  int _imageCount;

  ProcessSpeedQuestion({imageCount = 5}) {
    _imageCount = imageCount;
    _spentTime = List.generate(_maxIndex, (index) => 0);
    generateRandomQuestionList();
  }

  //生成题目
  void generateRandomQuestionList() {
    for (int i = 0; i < _maxIndex; i++) {
      List<int> question = List.generate(_imageCount, (index) => index);
      question.shuffle();
      question.insert(
          _random.nextInt(_imageCount), _random.nextInt(_imageCount));
      _questionList.add(question);
    }
  }

  //获取下一道题目
  List<int> getNextQuestion() {
    //index被初始化为-1，每次获取下一道题目时先加一，方便后续的操作
    _currentIndex++;
    return _questionList[_currentIndex];
  }

  //判断所有题目是否完成
  bool questionAllDone() {
    return _currentIndex >= _maxIndex - 1;
  }

  void setSpentTime(int time) {
    _spentTime[_currentIndex] = time;
  }
}
