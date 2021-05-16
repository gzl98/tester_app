import 'dart:math';

class MemoryMatrixQuestion {
  List questions = [];
  Random _random = Random();
  int questionSize;
  int questionNum;
  int maxQuestionNum;

  MemoryMatrixQuestion() {
    questionSize = 2;
    questionNum = 0;
    maxQuestionNum = 6;
  }

  List getQuestion() {
    List question = [];
    for (int i = 0; i < questionSize; i++) {
      List temp = [];
      for (int j = 0; j < questionSize; j++) {
        temp.add(0);
      }
      question.add(temp);
    }
    for (int i = 0; i < questionNum + 1; i++) {
      int x = _random.nextInt(questionSize);
      int y = _random.nextInt(questionSize);
      if (question[x][y] == 0) {
        question[x][y] = 1;
      } else {
        i -= 1;
      }
    }
    questions.add(question);
    List questionDeepCopy = [];
    for (int i = 0; i < questionSize; i++) {
      List temp = [];
      for (int j = 0; j < questionSize; j++) {
        temp.add(question[i][j]);
      }
      questionDeepCopy.add(temp);
    }
    questionNum += 1;
    questionSize = questionNum ~/ 2 + 2;
    return questionDeepCopy;
  }

  List getAnswer() {
    return questions[questionNum - 1];
  }
}

