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
import 'package:tester_app/Pages/PairAssoLearning/PairAssoLearningQuestion.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class PairALMainPage extends StatefulWidget {
  static const routerName = "/PairALMainPage";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PairALMainPageState();
  }
}

class PairALMainPageState extends State<PairALMainPage> {

  //当前关卡数
  int checkpoint=1;
  //测试失败次数
  int defaultNum=3;
  //序号对应图片名称
  List<String> numToPicture=['square','circular','triangle','cross'];
  //当前关数延迟秒数/过关图片数(用同一个)
  List<int> checkpointDelayed=[2,3,4,6];
  //出题器
  PairALQuestion pairALQuestion;
  //当前状态（初始为等待）
  CurrentState currentState=CurrentState.waiting;
  //当前关卡正确次数(正确两次进入下一关)
  int currentCorrectNum=0;
  //总关卡错误次数
  int totalWrongNum=0;
  //是否闯关成功
  int successful=0;
  //每次的答案矩阵，先4再6
  List question;
  //bool判断每张图片是否应该展示
  List showPicture = new List<bool>.generate(6, (int i) {
    return false;
  });
  //是否展示答案的图片
  List answerPicture = new List<bool>.generate(6, (int i) {
    return false;
  });
  //临时数字，记录初始要展示的图片编号
  int tempNum;
  //记录当前轮次用户选择的图片
  List tempUserList=new List<int>.generate(6, (int i) {
    return -1;
  });
  //记录答案数组，只有六个位置
  List tempAnswerList=new List<int>.generate(6, (int i) {
    return -1;
  });
  //临时记录用户选择的图片编号
  int tempPic=-1;
  //对号图片隐藏
  bool showRightPic=true;
  //错号图片隐藏
  bool showWrongPic=true;

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
    // if (_timer != null && _timer.isActive) _timer.cancel();
  }

  //初始化参数
  void startGame(){
    //循环初始化
    setState(() {
      tempUserList=[-1,-1,-1,-1,-1,-1];
      tempAnswerList=[-1,-1,-1,-1,-1,-1];
      showPicture=[false,false,false,false,false,false];
      answerPicture=[false,false,false,false,false,false];
    });
    //延迟一秒后开始显示题目
    Future.delayed(Duration(seconds:1),(){
      setState(() {
        showRightPic=true;
        showWrongPic=true;
        currentState=CurrentState.questionPrepare;
        pairALQuestion=new PairALQuestion(checkpointDelayed[checkpoint-1]);
        question=pairALQuestion.getQuestion();
        print("question列表："+question.toString());
        //展示相应秒数后再次隐去
        Future.delayed(Duration(seconds: checkpointDelayed[checkpoint-1]),(){
          setState(() {
            currentState=CurrentState.doingQuestion;
          });
        });
      });
    });
  }

  //错误时重启游戏
  void restartGame(){
    //循环初始化
    setState(() {
      tempUserList=[-1,-1,-1,-1,-1,-1];
      answerPicture=[false,false,false,false,false,false];
    });
    //延迟一秒后开始显示题目
    Future.delayed(Duration(seconds:1),(){
      setState(() {
        showRightPic=true;
        showWrongPic=true;
        currentState=CurrentState.questionPrepare;
        print("question列表："+question.toString());
        //展示相应秒数后再次隐去
        Future.delayed(Duration(seconds: checkpointDelayed[checkpoint-1]),(){
          setState(() {
            currentState=CurrentState.doingQuestion;
          });
        });
      });
    });
  }

  bool judgeList(List a,List b){
    int templength=a.length;
    bool tempcorrect=true;
    for(int i=0;i<templength;i++){
      if(a[i]!=b[i]){
        tempcorrect=false;
      }
    }
    return tempcorrect;
  }

  //判断并记录标准答案,将question二维矩阵转换为一维矩阵
  void checkAnswer(int position){
    for(int i=0;i<4;i++){
      for(int j=0;j<6;j++){
        if(question[i][j]==1){
          if(j==position){
            tempNum=i;
            showPicture[position]=true;
            tempAnswerList[j]=i;
          }
        }
      }
    }
  }

  //获取用户当前图片选择数量
  int getNum(List a){
    int temp=0;
    for(int i=0;i<6;i++){
      if(a[i]!=-1){
        temp++;
      }
    }
    return temp;
  }

  //橘色框
  Widget squareYellowBox(int position){
    return Expanded(
        flex: 1,
        child:Align(
          child: Container(
            width: setWidth(270),
            height: setHeight(270),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 242, 204),
                border: Border.all(color: Colors.orangeAccent, width: 2.0),
            ),
            child: currentState==CurrentState.waiting?null:
              currentState==CurrentState.questionPrepare?(){
                checkAnswer(position);
                if(showPicture[position]){
                  return Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(""),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/v4.0/PairAL/'+numToPicture[tempNum].toString()+'.png'),
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.center,
                                      )
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(""),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      )
                    ],
                  );
                }
              }():
            currentState==CurrentState.doingQuestion?
            FlatButton(
              color:Colors.transparent,
              onPressed: (){
                setState(() {
                  //排除空点橘色方框的问题
                  if(tempPic==-1){
                    print("未选择图片，请重新选择~");
                  }else{
                    print("位置"+position.toString());
                    tempUserList[position]=tempPic;
                    answerPicture[position]=true;
                    print("用户本轮选择："+tempUserList.toString());
                    int temp=getNum(tempUserList);
                    //达到最多图片选择，进行判断
                    if(temp==checkpointDelayed[checkpoint-1]){
                      //让结果图片同时显示1s在进行判断
                      Future.delayed(Duration(seconds:1),(){
                        setState(() {
                          if(judgeList(tempAnswerList, tempUserList)){
                            if(currentCorrectNum<1){
                              currentCorrectNum++;
                              showRightPic=false;
                              print("当前关卡正确数："+currentCorrectNum.toString());
                              currentState=CurrentState.waiting;
                              startGame();
                            }else{
                              if(checkpoint==4){
                                successful=1;
                                currentState=CurrentState.questionDone;
                                print("挑战成功，游戏结束");
                              }else{
                                currentCorrectNum=0;
                                showRightPic=false;
                                //保证关卡数字同步更新
                                Future.delayed(Duration(seconds:1),(){
                                  checkpoint++;
                                });
                                print("当前关卡数："+checkpoint.toString());
                                currentState=CurrentState.waiting;
                                startGame();
                              }
                            }
                          }else{
                            totalWrongNum++;
                            print("累计错误次数："+totalWrongNum.toString());
                            if(totalWrongNum==defaultNum){
                              currentState=CurrentState.questionDone;
                              print("挑战失败，游戏结束");
                            }else{
                              showWrongPic=false;
                              currentState=CurrentState.waiting;
                              restartGame();
                            }
                          }
                        });
                      });
                    }
                  }
                });
              },
              child: answerPicture[position]?Container(
                width: maxWidth,
                height: maxHeight,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(""),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/v4.0/PairAL/'+numToPicture[tempUserList[position]].toString()+'.png'),
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.center,
                                    )
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(""),
                            ),
                          ],
                        )
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    )
                  ],
                ),
              ):Container(),
            ) :null,
          ),
          alignment: Alignment.bottomCenter,
        )
    );
  }

  //绿色框
  Widget squareGreenBox(int pictureNum){
    return Expanded(
        flex: 1,
        child:Align(
          child: Container(
            width: maxWidth,
            height: maxHeight,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 213, 232, 212),
              border: (tempPic==pictureNum)?Border.all(color: Colors.orange, width: 2.0):Border.all(color: Colors.teal, width: 2.0),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text(""),
                ),
                Expanded(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/v4.0/PairAL/'+numToPicture[pictureNum]+'.png'),
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                  )
                              ),
                              child: FlatButton(
                                color:Colors.transparent,
                                onPressed: currentState==CurrentState.doingQuestion?(){
                                  setState(() {
                                    print("图片"+pictureNum.toString());
                                    tempPic=pictureNum;
                                  });
                                }:null,
                              ),
                            ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                      ],
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Text(""),
                )
              ],
            ),
          ),
          alignment: Alignment.bottomCenter,
        )
    );
  }

  //上面的六个框
  Widget buildTopWidget(){
    return Expanded(
        flex: 4,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Align(
                            child: Container(
                              width: maxWidth,
                              height: setHeight(160),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 3.0),
                              ),
                              child: Align(
                                child: Text('第'+checkpoint.toString()+'关',
                                  style: TextStyle(
                                    fontSize: setSp(60),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            alignment: Alignment.topCenter,
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(""),
                      ),
                      squareYellowBox(0),
                      Expanded(
                        flex: 4,
                        child: Text(""),
                      ),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Row(
                    children: <Widget>[
                      squareYellowBox(1),
                      Expanded(
                          flex: 7,
                          child: Text("")
                      ),
                      squareYellowBox(2),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Row(
                    children: <Widget>[
                      squareYellowBox(3),
                      Expanded(
                          flex: 7,
                          child: Text("")
                      ),
                      squareYellowBox(4),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(""),
                      ),
                      squareYellowBox(5),
                      Expanded(
                        flex: 4,
                        child: Text(""),
                      ),
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }

  //下面的四个图案
  Widget buildBottomWidget(){
    return Expanded(
        flex: 1,
        child: Container(
          width: maxWidth,
          height: maxHeight,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Text(""),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Text(""),
                      ),
                      squareGreenBox(0),
                      squareGreenBox(1),
                      squareGreenBox(2),
                      squareGreenBox(3),
                      Expanded(
                        flex: 7,
                        child: Text(""),
                      ),
                    ],
                  )
              ),
            ],
          ),
        )
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
                                    successful.toString() +
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
                                "错误数：" + totalWrongNum.toString() + "      ",
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
                                  "成功率：" + ((successful*100)/(successful+totalWrongNum)).truncate().toString() + " %",
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
                //上传数据
                Map map = {
                  "正确数": successful,
                  "错误数": totalWrongNum,
                };
                String text = json.encode(map);
                setAnswer(questionIdPairAssoLearning,
                    score: successful, answerText: text);
                Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (route) => false);
                //加入该题目结束标志
                testFinishedList[questionIdPairAssoLearning]=true;
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
        Container(
          color: Color.fromARGB(255, 218, 232, 252),
          width: maxWidth,
          height: maxHeight,
          child: Column(
            children: <Widget>[
              buildTopWidget(),
              buildBottomWidget(),
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
  waiting, //刚进入界面等待
  questionPrepare, //题目闪烁
  doingQuestion, //答题时间
  questionDone, //答题完毕
}