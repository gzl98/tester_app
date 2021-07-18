import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
// import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/ShortTermMemoryTest/ShortTermMemoryQuestion.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class ShortItemMemoryTestPage extends StatefulWidget {
  static const routerName = "/ShortItemMemory";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShortItemMemoryState();
  }
}

class ShortItemMemoryState extends State<ShortItemMemoryTestPage> {

  //当前关卡数
  int checkpoint=0;
  //当前关卡的题目Index
  int currentTestIndex =-1;
  //每一关测试的次数
  int defaultPositionNum=1;
  //每一关最多可以选择的图标个数
  final List<int> checkMaxSelectNum = [3,6];
  //序号对应图片名称
  List<String> numToPicture=['square','circular','triangle', 'delete'];
  //结果对应的错误正确图片
  List<String> numToRightAndWrong = ['','images/v2.0/correct.png','images/v2.0/wrong.png'];
  //当前关数延迟秒数/过关图片数(用同一个)
  final List<int> checkpointDelayed=[4500,9000];
  //出题器
  ShortTermTestQuestionFactory questionFactory;
  //当前状态（初始为等待）
  CurrentState currentState=CurrentState.waiting;
  //当前关卡正确次数(正确两次进入下一关)
  int currentSelectNum=0;
  //总答对次数
  int totalCorrectNum=0;
  //总关卡错误次数
  int totalWrongNum=0;
  //当前关卡错误次数
  int currentWrongNum=0;
  //记录每一关正确数
  List levelCorrectNum = new List<int>.generate(2, (int i) {
    return 0;
  });
  //记录每一关错误数
  List levelWrongNum = new List<int>.generate(4, (int i) {
    return 0;
  });
  //每次的答案矩阵，6个数组位置对应四张图片
  List question=[];
  //bool判断每张图片是否应该展示
  List showPicture = new List<bool>.generate(9, (int i) {
    return false;
  });
  //是否展示答案的图片
  List answerPicture = new List<bool>.generate(9, (int i) {
    return false;
  });
  //展示一个测试完成的对错
  List oneTestResult = new List<int>.generate(9, (index) => 0);
  //临时数字，记录初始要展示的图片编号
  int tempNum=1;
  //记录当前轮次用户选择的图片
  List tempUserList=new List<int>.generate(9, (int i) {
    return -1;
  });
  //临时记录用户选择的图片编号
  int tempPic;
  //到达上限数目，禁用点击
  bool disabledButton=false;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    questionFactory = new ShortTermTestQuestionFactory();
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
      oneTestResult = new List<int>.generate(9, (index) => 0);
      tempUserList=[-1,-1,-1,-1,-1,-1,-1,-1,-1];
      showPicture=[false,false,false,false,false,false,false,false,false];
      answerPicture=[false,false,false,false,false,false,false,false,false];
      disabledButton=false;
      if(this.currentTestIndex<this.defaultPositionNum-1)
        this.currentTestIndex++;
      else{
        this.levelCorrectNum[this.checkpoint] = this.totalCorrectNum;
        this.currentTestIndex =0;
        if(this.checkpoint == 0)
          this.checkpoint++;
        else{
          this.currentState=CurrentState.questionDone;
          return ;
        }
        this.question.clear();
      }
    });
    if(this.currentState!=CurrentState.questionDone){
      //延迟一秒后开始显示题目
      Future.delayed(Duration(seconds:1),(){
        setState(() {
          currentState=CurrentState.questionPrepare;
          if(question.length == 0){
            question=questionFactory.getCheckTest(this.checkpoint+1, this.defaultPositionNum);
          }
          //展示相应秒数后再次隐去
          Future.delayed(Duration(milliseconds: checkpointDelayed[checkpoint]),(){
            setState(() {
              currentState=CurrentState.doingQuestion;
            });
          });
        });
      });
    }

  }

  int judgeList(List a,List b){
    print("原题："+a.toString());
    print("用户答案:"+b.toString());
    int result=0;
    int wrong=0;
    for(int i=0;i<a.length;i++){
      if(b[i]!=-1 && a[i] == b[i] ){
        result++;
        setState(() {
          this.oneTestResult[i]=1;
        });
      }
      else if(b[i]!=-1 && a[i] != b[i] ){
        setState(() {
          wrong++;
          this.oneTestResult[i]=2;
        });
      }
    }
    return result;
  }
  //判断本次测验是否可以按下按钮 true不能操作 ，false可以操作
  bool judgePositionAble(int position){
    if(this.tempUserList[position]!=-1){
      return true;
    }
    //当选择橡皮的时候可以操作
    if(this.tempPic==3){
      return true;
    }
    int selectNum=0;
    for(var num in this.tempUserList){
      if(num != -1)
        selectNum++;
    }
    if(selectNum>=this.checkMaxSelectNum[this.checkpoint])
      return false;
    else
      return true;
  }

  //判断是否展示图片，并记录当前按下的数字
  void checkAnswer(int position){
    if(this.currentState==CurrentState.questionPrepare){
      if(question[this.currentTestIndex].tempQuestion[position]!=-1){
        setState(() {
          tempNum=question[this.currentTestIndex].tempQuestion[position];
          showPicture[position]=true;
        });
      }
    }
    else if(this.currentState == CurrentState.oneTestResult){
      setState(() {

      });
    }
  }
  Widget squareYellowBoxContext(CurrentState state, int position){
    if(state == CurrentState.waiting){
      return null;
    }
    else if(state==CurrentState.questionPrepare){
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
                              image:AssetImage('images/v4.0/PairAL/'+numToPicture[tempNum].toString()+'.png'),
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
    }
    else if(state==CurrentState.doingQuestion){
      return FlatButton(
        color:Colors.transparent,
        onPressed: judgePositionAble(position)?(){
          setState(() {
            //排除空点橘色方框的问题
            if(tempPic==-1){
              print("未选择图片，请重新选择~");
            }else{
              print("位置"+position.toString());
              if(tempPic==3){
                tempUserList[position] = -1;
                answerPicture[position] =false;
              }
              else{
                tempUserList[position] = tempPic;
                answerPicture[position] =true;
              }
              print("用户本轮选择："+tempUserList.toString());
            }
          });
        }:(){},
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
      );
    }
    else if(state == CurrentState.oneTestResult){
      checkAnswer(position);
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
                            image:AssetImage(this.numToRightAndWrong[this.oneTestResult[position]]),
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

    else{
      return null;
    }
  }
  //橘色框
  Widget squareYellowBox(int position){
    return Align(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 242, 204),
          border: Border.all(color: Colors.orangeAccent, width: 2.0),
        ),
        child: this.squareYellowBoxContext(this.currentState, position),
      ),
      alignment: Alignment.bottomCenter,
    );
  }



  //绿色框
  Widget squareGreenBox(int pictureNum){
    return Expanded(
        flex: 1,
        child:Align(
          child: Container(
            width: setWidth(300),
            height: setHeight(300),
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

  //确认本轮答案提交按钮
  Widget confirmButton(){
    return Expanded(
        flex: 2,
        child: Container(
          width: maxWidth,
          height: maxHeight,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color.fromARGB(255, 213, 232, 212),
            onPressed: (){
              if(currentState==CurrentState.doingQuestion){
                setState(() {
                  this.disabledButton = true;
                  this.totalCorrectNum =this.totalCorrectNum+this.judgeList(this.question[this.currentTestIndex].getTestList(), this.tempUserList);
                  print(totalCorrectNum);
                  this.currentState = CurrentState.oneTestResult;
                  //showRightPic=false;
                  Future.delayed(Duration(seconds: 1),(){
                    currentState=CurrentState.waiting;
                    startGame();
                  });
                });
              }else{
                print("还未进入答题状态，无效确认");
              }
            },
            child: Text("确认",style: TextStyle(fontSize: setSp(70), fontWeight: FontWeight.bold, color: Colors.blueGrey),),
          ),
        )
    );
  }
  Widget _buildTopWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(140)),
      alignment: Alignment.centerLeft,
      width: maxWidth,
      height: setHeight(150),
      color: Color.fromARGB(255, 48, 48, 48),
      child: Text(
        "短期记忆测试"+((index){
          return " — 第"+(this.checkpoint+1).toString()+"关";
        }(this.checkpoint)),
        style: TextStyle(color: Colors.white, fontSize: setSp(55)),
      ),
    );
  }
  // 默认一行三个
  Widget _buildTableRow(int rowNum){
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: squareYellowBox(rowNum*3),
          ),
          Expanded(
            flex: 1,
            child: squareYellowBox(rowNum*3+1),
          ),
          Expanded(
            flex: 1,
            child: squareYellowBox(rowNum*3+2),
          )
        ],
      ),
    );
  }
  //上面的六个框
  Widget _buildMainTable(){
    return Expanded(
        flex: 4,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Text(""),
              ),
              Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                        flex:1,
                        child: Text("")
                    ),
                    Expanded(
                        flex:1,
                        child: Column(
                          children: [
                            Expanded(
                              flex:1,
                              child: _buildTableRow(0)
                            ),
                            Expanded(
                                flex:1,
                                child: _buildTableRow(1)
                            ),
                            Expanded(
                                flex:1,
                                child: _buildTableRow(2)
                            ),
                          ],
                        ),
                    ),
                    Expanded(
                        flex:1,
                        child: Text("")
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
                        flex: 2,
                        child: Text(""),
                      ),
                      confirmButton(),
                      Expanded(
                        flex: 3,
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

  //准备开始背景
  Widget showPrepareBackground(){
    return Positioned(
      top: setHeight(630),
      right: setWidth(860),
      child: Container(
        margin: EdgeInsets.only(bottom: setHeight(80)),
        width: setWidth(820),
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

  //准备开始颜色
  Widget showPrepare(){
    return Positioned(
      top: setHeight(630),
      right: setWidth(860),
      child: Container(
        margin: EdgeInsets.only(bottom: setHeight(80)),
        alignment: Alignment.center,
        width: setWidth(850),
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
          "准 备 开 始",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: setSp(70), color: Colors.deepOrangeAccent),
        ),
      ),
    );
  }

  //构建结果列表列表
  Widget buildListWidget() {
    TextStyle titleStyle = TextStyle(fontSize: setSp(45), fontWeight: FontWeight.w900, color: Colors.white);
    TextStyle contentStyle = TextStyle(fontSize: setSp(40), fontWeight: FontWeight.bold);
    List<TableRow> table = [
      TableRow(
          decoration: BoxDecoration(color: Colors.black54),
          children: [
            Container(
                alignment: Alignment.center,
                height: setHeight(120),
                child: Text("关卡数", textAlign: TextAlign.center, style: titleStyle)
            ),
            Text("得分", textAlign: TextAlign.center, style: titleStyle),
          ]
      )
    ];

    for(int i=0;i<3;i++){
      List<Widget> tableRow = [];
      tableRow.add(Container(
        alignment: Alignment.center,
        height: setHeight(100),
        child: Text(i==2?"总得分":(i+1).toString(),
            textAlign: TextAlign.center, style: contentStyle),
      ));
      tableRow.add(Container(
        alignment: Alignment.center,
        height: setHeight(100),
        child: Text(i==2? this.totalCorrectNum.toString():this.levelCorrectNum[i].toString(), textAlign: TextAlign.center, style: contentStyle),
      ));
      table.add(TableRow(
          decoration: BoxDecoration(
              color: i % 2 == 0 ? Colors.white : Colors.grey[100],
              border: Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 50, 50, 50)))),
          children: tableRow));
    }

    return Container(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: table,
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
              buildListWidget(),
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
                testFinishedList[questionIdShortMemTest]=true;
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
              _buildTopWidget(),
              Container(
                width: maxWidth,
                height: setHeight(5),
                color: Colors.red,
              ),
              _buildMainTable(),
              buildBottomWidget(),
            ],
          ),
        ),
        currentState==CurrentState.waiting?showPrepareBackground():Container(),
        currentState==CurrentState.waiting?showPrepare():Container(),
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
  waiting,          //刚进入界面等待
  questionPrepare,  //题目闪烁
  doingQuestion,    //答题时间
  oneTestResult,    //答完一道显示结果
  questionDone,     //答题完毕
}