import 'dart:math';

import 'package:flutter/cupertino.dart';
bool nextPermutation(List<int> nums){
  int j = nums.length -1;
  while(j>0&&nums[j]<=nums[j-1])
    j--;
  if(j>0){
    int i=nums.length-1;
    while(i>=0&&nums[i]<=nums[j-1]){
      i--;
    }
    //交换
    int temp;
    temp = nums[j-1];
    nums[j-1] = nums[i];
    nums[i] = temp;
  }
  //翻转列表
  reverseList(nums,j,nums.length-1);
  if(j==0)
    return false;
  else
    return true;

}
void reverseList(List list,int startIndex,int endIndex){
  List tempList= new List();
  for(int i=startIndex;i<=endIndex;i++){
    tempList.add(list[i]);
  }
  tempList = tempList.reversed.toList();
  for(int i = startIndex;i<=endIndex;i++){
    list[i] = tempList[i-startIndex];
  }
}

class SingleTestForShortMemory {
  //问题的序列 初始化全部为1
  List tempQuestion = new List<int>.generate(9, (int i) {
    return -1;
  });
  // 问题组合的集合
  List<List<int>> values=[];
  Random _random = Random();
  int checkPoint ;

  SingleTestForShortMemory(int checkpoint){
    this.checkPoint=checkpoint;
    //第一关
    if(checkPoint==1){
      getCheckFirstQuestion();
    }
    //第二关
    else if(checkPoint==2){
      // 1-3 代表出现次数
      List nums =new List<int>.generate(3, (int i) {
        return i+1;
      });
      bool flag=true;
      while(flag) {
        flag=nextPermutation(nums);
        List<int> tmpList = new List.from(nums);
        values.add(tmpList);
      }
      getCheckTwoQuestion();
    }
  }

  //产生第一关的随机题目
  void getCheckFirstQuestion() {
    // [0,1,2] 选择0-8不重复的位置
    for(int i=0;i<3;i++){
      int position = _random.nextInt(9);
      while(tempQuestion[position]!=-1){
        position = _random.nextInt(9);
      }
      tempQuestion[position] = i;
    }
    print(tempQuestion);
  }
  //产生第二关的随机题目
  void getCheckTwoQuestion() {
    int indexCombine = _random.nextInt(this.values.length);

    for(int i=0;i<3;i++){
      for(int j=0;j<this.values[indexCombine][i];j++){
        int position = _random.nextInt(9);
        while(tempQuestion[position]!=-1){
          position = _random.nextInt(9);
        }
        tempQuestion[position] = i;
      }
    }
    print(tempQuestion);
  }
  getTestList(){
    return this.tempQuestion;
  }
  //重载== 必须实现hashCode
  @override
  int get hashCode {
    return this.checkPoint.hashCode;
  }
  @override
  bool operator == (dynamic other) {
    if (other is SingleTestForShortMemory && other.hashCode==other.hashCode){
      bool result = true;
      for(int i =0 ;i<tempQuestion.length;i++){
        if(tempQuestion[i]!=other.tempQuestion[i]){
          result=false;
          break;
        }
      }
      return result;
    }
    else
      return false;
  }
  @override
  String toString(){
    return this.tempQuestion.toString();
  }
}


//出题器
class ShortTermTestQuestionFactory {
  List<SingleTestForShortMemory> getCheckTest(int checkPoint,int nums){
    Set<SingleTestForShortMemory> questionsSet = new Set();
    while(questionsSet.length<nums){
      questionsSet.add(new SingleTestForShortMemory(checkPoint));
    }
    List<SingleTestForShortMemory> resList = [];
    for(var x in questionsSet){
      resList.add(x);
    }
    return resList;
  }
}


void main() {
  ShortTermTestQuestionFactory fact = new ShortTermTestQuestionFactory();
  print("sa");
}
