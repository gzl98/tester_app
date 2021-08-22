import 'dart:math';

class NbackTest{
  final int _targetNum = 5;
  int _targetDisplayCount;
  int _testLenght;
  List<int> _sequence=[];
  int _subSequenceLength;
  var rng = new Random();

  NbackTest(int lenght,int count ){
    this._targetDisplayCount = count;
    this._testLenght = lenght;
    this._subSequenceLength = lenght~/count -3;
    this._generatorTest();
  }
  void _generatorTest(){
    List<int> targetOrder = List.generate(this._targetNum, (index) => index);
    targetOrder.shuffle();
    // 初始化
    for(int i=0;i<this._targetDisplayCount;i++){
      int index = i % this._targetNum;
      int randomNum = this.rng.nextInt(this._targetNum);
      if(i>0){
        int currentLength = this._sequence.length;
        List<int> subSeq = this.generatorSubSeqCondition([this._sequence[currentLength-2]
          ,this._sequence[currentLength-1],-1,targetOrder[index],randomNum]);
        this._sequence.addAll(subSeq);
      }
      else{
        List<int> subSeq = this.generatorSubSeqCondition([-1
          ,-1,-1,targetOrder[index],randomNum]);
        this._sequence.addAll(subSeq);
      }
      this._sequence.addAll([targetOrder[index],randomNum,targetOrder[index]]);
    }
  }
  // 生成向序列中添加的12345的排序片段
  // 传入的 List Condition为_subSequenceLength长度
  // 每一位上数字对应改位置上不能取的数字 若为-1 则无限制
  List<int> generatorSubSeqCondition(List condition){
    List<int> supportList = List.generate(this._targetNum, (index) => index);
    List<int> subSequence = [];
    List<int> tempFlag = []; // 记录还未选择的位数
    assert (this._targetNum == this._subSequenceLength);
    for(int i =0;i<this._subSequenceLength;i++){
      // 先为有限制的选择 否则会出现无解的情况
      if(condition[i] != -1){
        int newIndex = this.rng.nextInt(supportList.length);
        if(supportList[newIndex]==condition[i]){
          newIndex = (newIndex + (this.rng.nextInt(supportList.length-1)+1))%supportList.length;
        }
        subSequence.add(supportList[newIndex]);
        supportList.removeAt(newIndex);
      }
      else{
        tempFlag.add(subSequence.length);
        subSequence.add(condition[i]);
      }
    }
    int supportPointer=0 ;
    // 未未选择的赋值
    for(int i=0;i<tempFlag.length;i++){
      subSequence[tempFlag[i]] =supportList[supportPointer];
      supportPointer++;
    }
    return subSequence;
  }

  List<int> getTest(){
    return this._sequence;
  }
  //判断函数
  bool judgeInTargets(int index){
    if(index>=2){
      return this._sequence[index] == this._sequence[index-2];
    }
    else{
      return false;
    }
  }
}
void main(){
  print("hahah");
}