import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/Pages/PersistentTest/PersistentTestQuestion.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class PersistentTestMainPage extends StatefulWidget {
  static const routerName = "/PersistentTestMainPage";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PersistentTestMainPageState();
  }
}

class PersistentTestMainPageState extends State<PersistentTestMainPage> {

  //出题器
  PersistentTestQuestion persistentTestQuestion=new PersistentTestQuestion();
  //当前状态（初始为测试题目）
  CurrentState currentState=CurrentState.testQuestionPrepare;
  //每次的答案列表
  List question;
  //展示对号错号期间，题目图片隐去
  bool showQuestionPicture=true;
  //记录总的答题次数，前四次测试，后面二十次正式
  int totalAnswerNum=0;
  //当前点击按钮编号
  int buttonNum=-1;
  //对号图片隐藏
  bool showRightPic=true;
  //错号图片隐藏
  bool showWrongPic=true;
  //总答对次数
  int totalCorrectNum=0;
  //初始化计时器
  Timer _timer;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    startGame();
  }

  //强制退出
  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  //初始化参数
  void startGame(){
    //循环初始化
    setState(() {
      question=[0,0,0,0];
      buttonNum=-1;
      showRightPic=true;
      showWrongPic=true;
      if(totalAnswerNum==0){
        currentState=CurrentState.testQuestionPrepare;
      }else if(totalAnswerNum==2){
        currentState=CurrentState.mainQuestionPrepare;
      }else{
        currentState=CurrentState.nextQuestion;
      }
      // 文字展示时间
      Future.delayed(Duration(seconds: 1),(){
        setState(() {
          currentState=CurrentState.redWaiting;
          //随机间隔2-7秒期间，保持红色圆圈
          int interval=Random().nextInt(6)+2;
          print("间隔显示时间"+interval.toString()+"s");
          Future.delayed(Duration(seconds: interval),(){
            setState(() {
              question=persistentTestQuestion.getQuestion();
              print("第"+(totalAnswerNum+1).toString()+"个question列表："+question.toString());
              currentState=CurrentState.doingQuestion;
              checkButtonUnpressed();
            });
          });
        });
      });
    });
  }

  //未在规定时间点击按钮
  checkButtonUnpressed(){
    _timer=Timer.periodic(Duration(milliseconds: 600), (callback){
      //0.6s时进行判断
      setState((){
        if(buttonNum==-1){
          print("未点击按钮");
          currentState=CurrentState.showAnswer;
          showWrongPic=false;
          Future.delayed(Duration(seconds: 1),(){
            totalAnswerNum++;
            print("正式测试总正确数为："+totalCorrectNum.toString());
            if(totalAnswerNum==10){
              setState(() {
                showRightPic=true;
                showWrongPic=true;
                currentState=CurrentState.questionDone;
              });
            }else{
              startGame();
            }
          });
        }
        _timer.cancel();
      });
    });
  }

  //2560*1600
  //文字层次感背景
  Widget showTextBackground(){
    return Positioned(
      top: setHeight(630),
      right: setWidth(630),
      child: Container(
        margin: EdgeInsets.only(bottom: setHeight(80)),
        width: setWidth(1300),
        height: setHeight(120),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.35),
              blurRadius: setWidth(5),
              offset: Offset(setWidth(0), setHeight(3)),
            )
          ],
        ),
      ),
    );
  }

  //中间显示的文字
  Map stateText = {
    CurrentState.testQuestionPrepare: "模 拟 测 试 开 始",
    CurrentState.mainQuestionPrepare: "正 式 测 试 开 始",
    CurrentState.nextQuestion: "下 一 题",
  };

  //文字颜色
  Widget showText(){
    return Positioned(
      top: setHeight(630),
      right: setWidth(630),
      child: Container(
        margin: EdgeInsets.only(bottom: setHeight(80)),
        alignment: Alignment.center,
        width: setWidth(1300),
        height: setHeight(120),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 236, 239, 238),
              Color.fromARGB(255, 250, 250, 250),
              Color.fromARGB(255, 236, 239, 238),
            ],
          ),
        ),
        child: Text(
          stateText[currentState],
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: setSp(70), color: Colors.deepOrangeAccent),
        ),
      ),
    );
  }

  //圆形按钮组件
  Widget circleButton(int position){
    return Expanded(
      flex: 2,
      child: Container(
        width: maxWidth,
        height: maxHeight,
        child:  RaisedButton(
          color:question[position]==1?Colors.lightGreenAccent:Color.fromARGB(255, 238, 72, 99),
          onPressed: currentState==CurrentState.doingQuestion?(){
            setState(() {
              buttonNum=position;
              if(buttonNum!=-1){
                // 关闭另一个计时器
                if(_timer != null && _timer.isActive){
                  _timer.cancel();
                }
                if(question[buttonNum]==1){
                  print("correct");
                  currentState=CurrentState.showAnswer;
                  showRightPic=false;
                  if(totalAnswerNum>=2){
                    totalCorrectNum++;
                    print("正式测试总共正确数为："+totalCorrectNum.toString());
                  }
                  Future.delayed(Duration(seconds: 1),(){
                    totalAnswerNum++;
                    if(totalAnswerNum==10){
                      setState(() {
                        currentState=CurrentState.questionDone;
                      });
                    }else{
                      startGame();
                    }
                  });
                }else{
                  print("wrong");
                  currentState=CurrentState.showAnswer;
                  showWrongPic=false;
                  Future.delayed(Duration(seconds: 1),(){
                    totalAnswerNum++;
                    print("正式测试总共正确数为："+totalCorrectNum.toString());
                    if(totalAnswerNum==10){
                      setState(() {
                        showRightPic=true;
                        showWrongPic=true;
                        currentState=CurrentState.questionDone;
                      });
                    }else{
                      startGame();
                    }
                  });
                }
              }
            });
          }:(currentState==CurrentState.redWaiting?(){}:null),
          shape: CircleBorder(side: BorderSide(color: Colors.white)),
        ),
      )
    );
  }

  //圆圈位置
  Widget buildCirclePosition(){
    return Container(
      height: maxHeight,
      width: maxWidth,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(""),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text(""),
                ),
                circleButton(0),
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                circleButton(1),
                Expanded(
                  flex: 3,
                  child: Text(""),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(""),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text(""),
                ),
                circleButton(2),
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                circleButton(3),
                Expanded(
                  flex: 3,
                  child: Text(""),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(""),
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
          SizedBox(height: setHeight(100)),
          Container(
            width: setWidth(800),
            height: setHeight(800),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: setHeight(30)),
                    Text(
                        "    正确率：" +
                  (totalCorrectNum*100/8).truncate().toString() +"%"+
                            "    ",
                        style: resultTextStyle),
                    // SizedBox(height: setHeight(15)),
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(height: setHeight(200)),
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
                //上传数据
                // Map map = {
                //   "关卡正确数": levelCorrectNum,
                //   "关卡错误数": levelWrongNum,
                // };
                // String text = json.encode(map);
                // setAnswer(questionIdPairAssoLearning,
                //     score: totalCorrectNum, answerText: text);
                Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (route) => false);
                //加入该题目结束标志
                // testFinishedList[questionIdPairAssoLearning]=true;
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
    //TODO: 定义主体布局，长宽分别为1960*1350像素
    return Stack(
      children: <Widget>[
        Container(
          color: Color.fromARGB(255, 218, 232, 252),
          width: maxWidth,
          height: maxHeight,
          child: Column(
            children: <Widget>[
              (currentState==CurrentState.doingQuestion)||(currentState==CurrentState.questionDone)
                  ||(currentState==CurrentState.redWaiting)?buildCirclePosition():Container(),
            ],
          ),
        ),
        showRightPic==false?Positioned(
          top: setHeight(450),
          right: setWidth(1020),
          child: Image.asset("images/v2.0/correct.png", width: setWidth(480)),
        ):Container(),
        showWrongPic==false?Positioned(
          top: setHeight(450),
          right: setWidth(1035),
          child: Image.asset("images/v2.0/wrong.png", width: setWidth(480)),
        ):Container(),
        (currentState==CurrentState.testQuestionPrepare)||(currentState==CurrentState.mainQuestionPrepare)
            ||(currentState==CurrentState.nextQuestion)?showTextBackground():Container(),
        (currentState==CurrentState.testQuestionPrepare)||(currentState==CurrentState.mainQuestionPrepare)
            ||(currentState==CurrentState.nextQuestion)?showText():Container(),
        currentState==CurrentState.questionDone?buildResultWidget():Container(),
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

//多个状态
enum CurrentState {
  testQuestionPrepare, //模拟测试
  mainQuestionPrepare, //正式测试
  redWaiting, //展示红色圆圈的等待时间
  doingQuestion, //答题时间
  showAnswer, //展示正误图片
  nextQuestion, //下一题图标
  questionDone, //所有答题完毕
}