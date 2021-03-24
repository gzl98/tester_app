import 'dart:math';

class COTQuestion {
  List _questionList = [];
  int _questionState;
  int _answer;
  int _max;
  Random _random = Random();

  COTQuestion(int max, int state) {
    _max = max;
    _questionState = state;
  }

  int generateAnswer() {
    _answer = _random.nextInt(_max);
    return _answer;
  }

  int getAnswer() {
    return _answer;
  }

  int getNextQuestion() {
    int nextQuestion = _questionState == 0 ? 0 : _random.nextInt(_max);
    _questionList.add(nextQuestion);
    return nextQuestion;
  }

  void setQuestionState(int state) {
    _questionState = state;
  }
}
