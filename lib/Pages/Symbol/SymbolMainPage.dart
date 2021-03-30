import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/Pages/Symbol/SymbolTemp.dart';
import 'package:tester_app/questions.dart';

class SymbolMainPage extends StatefulWidget {
  static const routerName = "/SymbolMainPage";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SymbolMainPageState();
  }
}

class SymbolMainPageState extends State<SymbolMainPage> {

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  //初始化出题器
  SymbolQuestion _symbolQuestion=new SymbolQuestion();
  //熟悉操作界面是否隐去
  bool knowOperationHidden=false;
  //正式界面是否隐去
  bool checkOperationHidden=true;
  //熟悉界面延迟控制,-2不显示，0显示，2生命周期结束
  int knowDelayedShow=-2;
  //正式界面延迟控制
  int checkDelayedShow=-2;
  //熟悉+正式延时时间设置
  int knowDelayedTime=1;
  //对错延时时间设置
  int rorwDelayedTime=1;
  //正确答题数
  int correctNumber=0;
  //错误答题数
  int wrongNumber=0;
  //是否展示结果界面
  bool showResult=true;
  //正确率取整
  int correctPercent;
  //测试次数
  int testTimes=3;

  //记录总的测试点击次数
  int totalClickNumber=0;
  //记录总的对错记录，判断展示√还是×的图片
  List<bool> totalCorrect=new List();
  //每道题的延迟开始于结束标志(最多3+120道题)
  List totalDelayed = new List<bool>.generate(123, (int i) {
    return false;
  });

  //声明变量
  Timer _timer;
  //正式倒计时120s答题时间
  int _currentTime = 20;

  //上传数据
  sendData(){
    String answerMerge="";
    int answerLength=totalCorrect.length-testTimes;
    String correct_temp="";
    for(int i=testTimes;i<answerLength+testTimes;i++){
      if(totalCorrect[i]==true){
        correct_temp+="1";
      }else{
        correct_temp+="0";
      }
    }
    String basic_temp="";
    for(int m=testTimes;m<answerLength+testTimes;m++){
      for(int j=m*2;j<(m+1)*2;j++){
        if(j==(m+1)*2-1 && m==answerLength+testTimes-1){
          basic_temp+=_symbolQuestion.testBasicList[j].toString();
        }else{
          basic_temp+=_symbolQuestion.testBasicList[j].toString();
          basic_temp+=",";
        }
      }
    }
    String contrast_temp="";
    for(int n=testTimes;n<answerLength+testTimes;n++){
      for(int k=n*5;k<(n+1)*5;k++){
        if(k==(n+1)*5-1 && n==answerLength+testTimes-1){
          contrast_temp+=_symbolQuestion.testContrastList[k].toString();
        }else{
          contrast_temp+=_symbolQuestion.testContrastList[k].toString();
          contrast_temp+=",";
        }
      }
    }
    answerMerge=correct_temp+"&"+basic_temp+"*"+contrast_temp;
    print("正式答题长度："+answerLength.toString());
    print("正误情况："+correct_temp);
    print("基本组符号："+basic_temp);
    print("对照组符号："+contrast_temp);
    print("上传的字符串："+answerMerge);

    setAnswer(1,score:correctNumber,answerText:answerMerge);
  }

  //倒计时操作
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
      setState(() {
        if (_currentTime < 1) {
          //倒计时结束操作
          _timer.cancel();
          setState(() {
            showResult=false;
          });
          countRightOrWrongNumbers();
        } else {
          _currentTime = _currentTime - 1;
        }
      })
    };
    _timer = Timer.periodic(oneSec, callback);
  }

  //倒计时组件
  Widget buildTime() {
    return Text(
      '时间：' + _currentTime.toString() + 's',
      style: TextStyle(
          fontSize: setSp(60),
          fontWeight: FontWeight.w600,
          color: _currentTime > 10
              ? Colors.white
              : Color.fromARGB(255, 255, 0, 0)),
    );
  }

  //准备二字
  Widget prepare(){
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(""),
        ),
        Expanded(
          flex: 2,
          //准备框
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(""),
              ),
              //准备两个字
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "准备",
                    style: TextStyle(
                      fontSize: setSp(88),
                      fontWeight: FontWeight.w400,
                      color: Colors.red[300],
                    ),
                  ),
                  decoration: new BoxDecoration(
                    // border: new Border.all(color: Color.fromARGB(20, 0, 0, 0), width: 0.5),
                    border: Border(
                        top: BorderSide(
                            color: Color.fromARGB(20, 0, 0, 0),
                            width: 0.5), // 上边边框
                        right: BorderSide(
                            color: Colors.transparent), // 右侧边框
                        bottom: BorderSide(
                            color: Color.fromARGB(20, 0, 0, 0),
                            width: 5), // 底部边框
                        left: BorderSide(
                            color: Colors.transparent)), // 左侧边框
                    gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 235, 235, 235),
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 235, 235, 235),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(5, 0, 0, 0),
                          offset: Offset(0.0, 6.0), //阴影y轴偏移量
                          blurRadius: 0, //阴影模糊程度
                          spreadRadius: 0 //阴影扩散程度
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(""),
        ),
      ],
    );
  }

  //检索图片组件
  Widget symbolWidget(int number){
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/symbol/'+number.toString()+'.png'),
              fit: BoxFit.scaleDown,
              alignment: Alignment.center),
        ),
      ),
    );
  }

  //基础图片展示
  Widget basicPictureWidget(){
    List temp=_symbolQuestion.getBasicPictureNumber();
    List<Widget>picture=[];  //存放部件
    for(int i=0;i<temp.length;i++){
      picture.add(symbolWidget(temp[i]));
    }
    Widget content=Row(
      children: picture,
    );
    print("基础此时的列表："+_symbolQuestion.testBasicList.toString());
    if(knowDelayedShow<2){
      knowDelayedShow+=1;
    }
    return content;
  }

  //对照图片展示
  Widget contrastPictureWidget(){
    List temp=_symbolQuestion.getContrastPictureNumber();
    List<Widget>picture=[];  //存放部件
    for(int i=0;i<temp.length;i++){
      picture.add(symbolWidget(temp[i]));
    }
    Widget content=Row(
      children: picture,
    );
    print("对照此时的列表："+_symbolQuestion.testContrastList.toString());
    if(knowDelayedShow<2){
      knowDelayedShow+=1;
    }
    return content;
  }

  //计算正误次数
  countRightOrWrongNumbers(){
    for(int i=testTimes;i<totalCorrect.length;i++){
      if(totalCorrect[i]==true){
        correctNumber++;
      }else{
        wrongNumber++;
      }
    }
    print(totalCorrect);
    print("总正确数；"+correctNumber.toString());
    print("总错误数："+wrongNumber.toString());
    correctPercent=((correctNumber*100)/(correctNumber+wrongNumber)).truncate();
    print("正确率数值："+correctPercent.toString());
  }

  //判断对错,点击次数增加，具体对错记录在按键处实现
  judgeRightOrWrong(){
    bool testRightOrWrong=false;  //当前题目正误
    for(int i=_symbolQuestion.testBasicCount;i<_symbolQuestion.testBasicCount+2;i++){
      for(int j=_symbolQuestion.testContrastCount;j<_symbolQuestion.testContrastCount+5;j++){
        if(_symbolQuestion.testBasicList[i]==_symbolQuestion.testContrastList[j]){
          testRightOrWrong=true;
        }
      }
    }
    _symbolQuestion.testBasicCount+=2;
    _symbolQuestion.testContrastCount+=5;
    totalClickNumber++;
    _symbolQuestion.generateBasicRandom();
    _symbolQuestion.generateContrastRandom();
    print("testBasicCount："+_symbolQuestion.testBasicCount.toString());
    print("testContrastCount："+_symbolQuestion.testContrastCount.toString());
    print("totalClickNumber："+totalClickNumber.toString());
    return testRightOrWrong;
  }

  //对错图片组件
  Widget rorwWidget(){
    String temp="";
    if(totalCorrect[totalClickNumber-1]==true){
      temp="correct";
    }else{
      temp="wrong";
    }
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/v2.0/'+temp+'.png'),
            fit: BoxFit.scaleDown,
            alignment: Alignment.center),
      ),
    );
  }

  //*顶部背景*
  Widget buildTopWidget() {
    return Expanded(
      flex: 4,
      child: Container(
        color: Color.fromARGB(200, 0, 0, 0),
        child: Row(
          children: <Widget>[
            //缩放闹钟图片
            Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 3, child: Text("")),
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/v2.0/clock.png'),
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter),
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: Text("")),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Align(
                  child: buildTime(),
                  alignment: Alignment.centerLeft,
                )),
            Expanded(flex: 10, child: Text("")),
          ],
        ),
      ),
    );
  }

  //*图片区域*
  Widget buildMediumWidget() {
    return Expanded(
      flex: 6,
      child: Row(
        children: <Widget>[
          //共33
          //空白左
          Expanded(
            flex: 6,
            child: Text(""),
          ),
          //图片左
          Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(20, 0, 0, 0),
                    border: Border.all(color: Colors.blue, width: 3.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: (knowDelayedShow>-2?
                (knowDelayedShow<2?basicPictureWidget():
                (totalDelayed[totalClickNumber-1]==true?
                (totalClickNumber==testTimes?
                (checkDelayedShow>-2? basicPictureWidget() :Text(""))
                    :basicPictureWidget())
                    :Text(""))
                ) : Text("")),
              )
          ),
          //空白中
          Expanded(
            flex: 1,
            child: Text(""),
          ),
          //图片+文字右
          Expanded(
              flex: 15,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(20, 0, 0, 0),
                    border: Border.all(color: Colors.indigo[100], width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: (knowDelayedShow>-2?(knowDelayedShow<2?contrastPictureWidget():
                (totalCorrect[totalClickNumber-1]!=null?
                (totalDelayed[totalClickNumber-1]==false?rorwWidget():
                (totalClickNumber==testTimes?
                (checkDelayedShow>-2? contrastPictureWidget() :prepare())
                    :contrastPictureWidget())
                ) : Text(""))
                ):prepare()),
              )
          ),
          //空白右
          Expanded(
            flex: 5,
            child: Text(""),
          ),
        ],
      ),
    );
  }

  //*有无两个按键区域*
  Widget buildBottomWidget() {
    return Expanded(
      flex: 14,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 25,
            child: Text(""),
          ),
          Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                height: setHeight(520),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 235, 235, 235),
                  border: Border.all(color: Colors.indigo[100], width: 2.0),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(150, 0, 0, 0),
                        offset: Offset(5.0, 5.0), //阴影x轴偏移量
                        blurRadius: 10, //阴影模糊程度
                        spreadRadius: 0 //阴影扩散程度
                    )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                    Expanded(
                      flex: 10,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(""),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                //撑满组件维度
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 235, 235, 235),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromARGB(150, 0, 0, 0),
                                        offset: Offset(1.0, 1.0), //阴影x轴偏移量
                                        blurRadius: 1, //阴影模糊程度
                                        spreadRadius: 0 //阴影扩散程度
                                    )
                                  ],
                                ),
                                child: RaisedButton(
                                  color: Colors.white,
                                  splashColor: Colors.transparent,
                                  disabledColor: Colors.white,
                                  onPressed:(showResult)? () {
                                    bool temp=judgeRightOrWrong();
                                    //记录每道题的正误，进行√与×图片的展示
                                    setState(() {
                                      temp==true?totalCorrect.add(true):totalCorrect.add(false);
                                      print("本题正误："+totalCorrect[totalClickNumber-1].toString());
                                    });
                                    //正误图片延时效果设置
                                    Future.delayed(Duration(seconds: rorwDelayedTime), (){
                                      setState(() {
                                        totalDelayed[totalClickNumber-1]=true;
                                      });
                                    });
                                    //跳转正式准备界面，加延迟匹配对错图片展示
                                    if(totalClickNumber==testTimes){
                                      Future.delayed(Duration(seconds: rorwDelayedTime), (){
                                        setState(() {
                                          checkOperationHidden=false;
                                        });
                                      });
                                    }
                                  }:null,
                                  child: Text(
                                    "有",
                                    style: TextStyle(
                                        fontSize: setSp(60),
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(150, 0, 0, 0)),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Text(""),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                //撑满组件维度
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 235, 235, 235),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromARGB(150, 0, 0, 0),
                                        offset: Offset(1.0, 1.0), //阴影x轴偏移量
                                        blurRadius: 1, //阴影模糊程度
                                        spreadRadius: 0 //阴影扩散程度
                                    )
                                  ],
                                ),
                                child: RaisedButton(
                                  color: Colors.white,
                                  disabledColor: Colors.white,
                                  splashColor: Colors.transparent,
                                  onPressed:(showResult)? () {
                                    bool temp=judgeRightOrWrong();
                                    //记录每道题的正误，进行√与×图片的展示
                                    setState(() {
                                      temp==false?totalCorrect.add(true):totalCorrect.add(false);
                                      print("本题正误："+totalCorrect[totalClickNumber-1].toString());
                                    });
                                    //正误图片延时效果设置
                                    Future.delayed(Duration(seconds: rorwDelayedTime), (){
                                      setState(() {
                                        totalDelayed[totalClickNumber-1]=true;
                                      });
                                    });
                                    //跳转正式准备界面,加延迟匹配对错图片展示
                                    if(totalClickNumber==testTimes){
                                      Future.delayed(Duration(seconds: rorwDelayedTime), (){
                                        setState(() {
                                          checkOperationHidden=false;
                                        });
                                      });
                                    }
                                  }:null,
                                  child: Text(
                                    "无",
                                    style: TextStyle(
                                        fontSize: setSp(60),
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(150, 0, 0, 0)),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Text(""),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: Text(""),
          ),
        ],
      ),
    );
  }

  //*熟悉操作界面*
  Widget buildFloatWidget() {
    return Container(
      //确保占满屏幕宽度和高度
      width: maxWidth,
      height: maxHeight,
      color: Color.fromARGB(220, 150, 150, 150),
      child: Column(
        //主轴对齐位置
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //空间位置调整
          SizedBox(
            height: setHeight(100),
          ),
          Container(
            width: setWidth(700),
            height: setHeight(700),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.all(Radius.circular(setWidth(50))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      //数字越大越模糊。默认值是0，表示一点也不进行模糊
                      blurRadius: setWidth(10),
                      //阴影与容器的距离
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Text(
              "熟悉操作界面",
              style: TextStyle(fontSize: setSp(60)),
            ),
          ),
          SizedBox(
            height: setHeight(250),
          ),
          Container(
            width: setWidth(500),
            height: setHeight(120),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff418ffc), Color(0xff174cfc)],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(setWidth(1), setHeight(1)),
                    blurRadius: setWidth(5),
                  )
                ]),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                setState(() {
                  knowOperationHidden=true; //要隐藏
                });
                //熟悉延时函数
                Future.delayed(Duration(seconds: knowDelayedTime), (){
                  setState(() {
                    knowDelayedShow=0; //开始延迟显示
                  });
                });
                //初次要先产生一次
                _symbolQuestion.generateBasicRandom();
                _symbolQuestion.generateContrastRandom();
              },
              child: Text(
                "开始",
                style: TextStyle(color: Colors.white, fontSize: setSp(60)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //*正式测查*
  Widget buildCheckWidget() {
    return Container(
      //确保占满屏幕宽度和高度
      width: maxWidth,
      height: maxHeight,
      color: Color.fromARGB(220, 150, 150, 150),
      child: Column(
        //主轴对齐位置
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //空间位置调整
          SizedBox(
            height: setHeight(100),
          ),
          Container(
            width: setWidth(700),
            height: setHeight(700),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.all(Radius.circular(setWidth(50))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      //数字越大越模糊。默认值是0，表示一点也不进行模糊
                      blurRadius: setWidth(10),
                      //阴影与容器的距离
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Text(
              "正式测查",
              style: TextStyle(fontSize: setSp(60)),
            ),
          ),
          SizedBox(
            height: setHeight(250),
          ),
          Container(
            width: setWidth(500),
            height: setHeight(120),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff418ffc), Color(0xff174cfc)],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(setWidth(1), setHeight(1)),
                    blurRadius: setWidth(5),
                  )
                ]),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                setState(() {
                  checkOperationHidden=true;
                });
                //熟悉延时函数
                Future.delayed(Duration(seconds: knowDelayedTime), (){
                  setState(() {
                    checkDelayedShow=0;
                  });
                });
                startCountdownTimer();
              },
              child: Text(
                "开始",
                style: TextStyle(color: Colors.white, fontSize: setSp(60)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double floatWindowRadios = 30;
  TextStyle resultTextStyle = TextStyle(
      fontSize: setSp(50), fontWeight: FontWeight.bold, color: Colors.blueGrey);

  //显示结果部件
  Widget buildResultWidget() {
    return Container(
      width: maxWidth,
      height: maxHeight,
      color: Color.fromARGB(220, 45, 45, 45),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: setHeight(200)),
          Container(
            width: setWidth(800),
            height: setHeight(450),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.all(
                    Radius.circular(setWidth(floatWindowRadios))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      blurRadius: setWidth(10),
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Column(children: [
              Container(
                height: setHeight(100),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow()],
                  color: Color.fromARGB(255, 229, 229, 229),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(setWidth(floatWindowRadios)),
                      topRight: Radius.circular(setWidth(floatWindowRadios))),
                ),
                child: Text(
                  "测验结果",
                  style: TextStyle(
                      fontSize: setSp(50),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: setHeight(30)),
                height: setHeight(230),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 5,
                          child: Align(
                            child:Text(
                                "正确数：" +
                                    correctNumber.toString() +
                                    "      ",
                                style: resultTextStyle),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 5,
                          child:Align(
                            child:Text(
                                "错误数：" + wrongNumber.toString() + "      ",
                                style: resultTextStyle),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                        Expanded(
                            flex: 5,
                            child:Align(
                              child:Text(
                                  "准确率：" + correctPercent.toString() + " %",
                                  style: resultTextStyle),
                              alignment: Alignment.centerLeft,
                            )
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(""),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(height: setHeight(300)),
          Container(
            width: setWidth(500),
            height: setHeight(120),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.white,width: setWidth(1)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 253, 160, 60),
                  Color.fromARGB(255, 217, 127, 63)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(setWidth(1), setHeight(1)),
                  blurRadius: setWidth(5),
                )
              ],
            ),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (route) => false);
                sendData();
                //加入该题目结束标志
                testFinishedList[0]=true;
              },
              child: Text(
                "结 束",
                style: TextStyle(color: Colors.white, fontSize: setSp(60)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //主界面布局
  @override
  Widget buildPage(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        //第一个child被绘制在最底端，后面的依次在前一个child的上面
        // 主界面
        Column(
          children: <Widget>[
            buildTopWidget(),
            //分界线
            Divider(
              height: 3.0,
              color: Color.fromARGB(120, 255, 0, 0),
              thickness: 3.0,
            ),
            //上面空白间隔
            Expanded(
              flex: 7,
              child: Text(""),
            ),
            buildMediumWidget(),
            //中间空白间隔
            Expanded(
              flex: 1,
              child: Text(""),
            ),
            buildBottomWidget(),
            //下面空白间隔
            Expanded(
              flex: 1,
              child: Text(""),
            ),
          ],
        ),
        //结果界面
        Offstage(
          offstage: showResult,
          child: buildResultWidget(),
        ),
        //医生形象
        showResult==false?Positioned(
          //设置距离四个边的距离
            right:setWidth(400),
            bottom: 0,
            child: Image.asset("images/v2.0/doctor_result.png", width: setWidth(480),)
        ):Container(),
        // 正式界面
        Offstage(
          offstage: checkOperationHidden,
          child: buildCheckWidget(),
        ),
        //熟悉界面
        Offstage(
          offstage: knowOperationHidden,
          child: buildFloatWidget(),
        ),
      ],
    );
  }


  //解决显示黑黄屏的问题,Scaffold的问题导致的
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: buildPage(context),
      ),
    );
  }
}