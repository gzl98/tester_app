import 'dart:math';

//出题器
class PairALQuestion {
  //问题真值列表
  List questions = [];
  Random _random = Random();
  //题目数量
  int questionSize;

  PairALQuestion(int size){
    questionSize=size;
  }

  //产生随机的图片位置以及图片选择，将之对应为矩阵，第一维度：□，○，△，十字对应0-3；第二维度：六个位置从上到下分别为0-5
  List getQuestion(){
    List tempQuestion=[];
    for (int i = 0; i < 4; i++) {
      List temp = [];
      for (int j = 0; j < 6; j++) {
        temp.add(0);
      }
      tempQuestion.add(temp);
    }
    for(int m=0;m<questionSize;m++){
      int x=_random.nextInt(4);
      int y=_random.nextInt(6);
      //避免重复
      bool temp=true;
      for(int i=0;i<4;i++){
        if(tempQuestion[i][y]==1){
          temp=false;
          m-=1;
        }
      }
      if(tempQuestion[x][y]==0 && temp){
        tempQuestion[x][y]=1;
      }
    }
    questions=tempQuestion;
    return questions;
  }

  //获取答案，便于比较
  List getAnswer() {
    return questions[questionSize - 1];
  }
}