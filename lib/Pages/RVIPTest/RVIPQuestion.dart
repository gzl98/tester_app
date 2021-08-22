import 'dart:math';

class RVIPSingleTest{
  List<String> _targets = ['357','246','468']; // 17 12 14
  String _sequence="";
  int _length;
  var rng = new Random();
  int _count =0;
  RVIPSingleTest(int length, int count){
    this._count =count;
    this._length=length;
  }
  // 一次出题类 但是没有判断目标序列一共出现指定次数
  String _generatorTest(int interval){
    String seq="";
    seq+=this.conditionRandom(0);
    while(seq.length<this._length){
      //出题函数 随机选择位置出题
      int flag=this.rng.nextInt(interval)+1;
      if(flag==interval && this._count>0 && (this._length-seq.length)>3){
        var targetIndex = this.rng.nextInt(3);
        //排除2 *468*
        while(targetIndex==2 && seq[seq.length-1]=='2'){
          targetIndex=this.rng.nextInt(3);
        }
        seq += this._targets[targetIndex];
        this._count--;
      }
      // 条件随机防止出现target序列
      var conditionNum =int.parse(seq.substring(seq.length-1));
      seq += this.conditionRandom(this.findConditionInTargets(conditionNum));
    }
    print(this._count);
    return seq;
  }
  // 最终使用的出题类
  String generatorTestByCount(int interval) {
    int count = this._count;
    // 确保目标出现count次数
    while(this._count != 0){
      this._count = count;
      this._sequence = this._generatorTest(interval);
    }
    return this._sequence;
  }
  int findConditionInTargets(int num){
    for(int i=0;i<this._targets.length;i++){
      var index = this._targets[i].indexOf(num.toString());
      if(index!=-1 && index!=this._targets[i].length-1)
        return int.parse(this._targets[i][index+1]);
    }
    return 0;
  }
  int getTargetCount() {
    return this._count;
  }
  String conditionRandom(int conditionNum){
    var num = this.rng.nextInt(8)+2;  //[2-9]
    while(num == conditionNum){
      num = this.rng.nextInt(9)+1;
    }
    return num.toString();
  }
  int getSequenceLength(){
    return this._sequence.length;
  }
  // 返回信息提供展示
  String getTargetListStr(){
    String res="";
    for(int i=0;i<this._targets.length;i++){
      String tmp = this._targets[i];
      res += tmp[0]+' * '+tmp[1]+' * '+tmp[2];
      res+='\n';
    }
    return res;
  }
  // 传入当前的index 判断this._sequence[index-2,index] or this._sequence[index-3,index-1] 是否为target
  bool judgeInTargets(int currentIndex){
    if(currentIndex>=3){
      String target1 = this._sequence.substring(currentIndex-2,currentIndex+1);
      String target2 = this._sequence.substring(currentIndex-3,currentIndex);
      return this._targets.contains(target1) || this._targets.contains(target1);
    }
    else if(currentIndex==2){
      String target1 = this._sequence.substring(currentIndex-2,currentIndex+1);
      return this._targets.contains(target1);
    }
    else{
      return false;
    }
  }


}
class RVIPtResultInfo {
  int _totalRect = 0;
  int _rightRect = 0;
  //记录每一个反应的标号
  List<int> rectIndexList=List<int>();
  //List记录每一个RectTime
  List<double> totalRectTime=List<double>();
  //记录每一个反应的结果
  List<bool> rectResult =List<bool>();

  int get totalRect => this._totalRect;
  int get rightRect => this._rightRect;

  //添加每一个反应的时间与结果
  void addSingleTimeResult(double rectTime,bool result,int index){
    // 每个坐标只允许反应一次
    if(this.rectIndexList.length>0 && this.rectIndexList[this.rectIndexList.length-1]==index){
      return;
    }
    // 如果在他的上个坐标进行了反应 判断是否对了 如果对了：则不计数  如果错了：进行本次添加
    if(this.rectIndexList.length>0 && this.rectIndexList[this.rectIndexList.length-1]==index-1){
      if(this.rectResult[this.rectIndexList.length-1]){
        return;
      }
    }
    this.rectIndexList.add(index);
    this.totalRectTime.add(rectTime);
    this.rectResult.add(result);
    if(result)  this._rightRect++;
    this._totalRect++;
  }
  //错误反应数
  String getErrorRectCount(){
    return (this._totalRect-this._rightRect).toString();
  }
  // 正确反应数
  String getRightCount(){
    return this._rightRect.toString();
  }
  // 错过数目
  String getMissingCount(int totalCount){
    return (totalCount-this._rightRect).toString();
  }
  //计算平均反应时间_正确反应的平均
  double getMeanRectTime(){
    double sum=0;
    for(int i=0;i<this.totalRect;i++){
      if(this.rectResult[i]==true){
        sum+=this.totalRectTime[i];
      }
    }
    //ms
    return (sum / this._rightRect)*100;
  }
}

void main() {
  var test = RVIPSingleTest(200,10);
  print(test.generatorTestByCount(15));
  print(test.getSequenceLength());
  print(test.getTargetListStr());
  final value = "XPTOXXSFXBAC".replaceAllMapped(RegExp(r".{4}"), (match) =>"${match.group(0)}");
  print("value: $value");
}