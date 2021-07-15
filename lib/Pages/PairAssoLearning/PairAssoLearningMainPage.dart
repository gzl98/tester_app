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
  //总答对次数
  int totalCorrectNum=0;
  //总关卡错误次数
  int totalWrongNum=0;
  //当前关卡错误次数
  int currentWrongNum=0;
  //记录每一关正确数
  List levelCorrectNum = new List<int>.generate(4, (int i) {
    return 0;
  });
  //记录每一关错误数
  List levelWrongNum = new List<int>.generate(4, (int i) {
    return 0;
  });
  //每次的答案矩阵，6个数组位置对应四张图片
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
  //临时记录用户选择的图片编号
  int tempPic=-1;
  //对号图片隐藏
  bool showRightPic=true;
  //错号图片隐藏
  bool showWrongPic=true;
  //到达上限数目，禁用点击
  bool disabledButton=false;

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
      showPicture=[false,false,false,false,false,false];
      answerPicture=[false,false,false,false,false,false];
      disabledButton=false;
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
      disabledButton=false;
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

  //判断是否展示图片，并记录当前按下的数字
  void checkAnswer(int position){
    if(question[position]!=-1){
      tempNum=question[position];
      showPicture[position]=true;
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
          onPressed: disabledButton?(){}:(){
            setState(() {
              //排除空点橘色方框的问题
              if(tempPic==-1){
                print("未选择图片，请重新选择~");
              }else{
                print("位置"+position.toString());
                tempUserList[position]=tempPic;
                answerPicture[position]=true;
                print("用户本轮选择："+tempUserList.toString());
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
    );
  }

  //加删除按钮的橘色框
  Widget deleteYellowBox(int position){
    return Expanded(
      flex:1,
      child:Container(
        width: setWidth(300),
        height: setHeight(300),
        child: Column(
          children: <Widget>[
            Expanded(
              flex:2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Container(),
                  ),
                  Expanded(
                    flex:2,
                    child: Container(
                      height: maxHeight,
                      width: maxWidth,
                      child: RaisedButton(
                        padding: EdgeInsets.only(left: setWidth(0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Color.fromARGB(255, 213, 232, 212),
                        onPressed: (){
                          if(currentState==CurrentState.doingQuestion){
                            setState(() {
                              tempUserList[position]=-1;
                              answerPicture[position]=false;
                              print("用户本轮选择："+tempUserList.toString());
                            });
                          }else{
                            print("还未进入答题状态，无效删除");
                          }
                        },
                        child: Text("X",style: TextStyle(fontSize: setSp(40)),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex:9,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: squareYellowBox(position),
                  ),
                  Expanded(
                    flex:2,
                    child: Text(""),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                  disabledButton=true;
                  if(judgeList(question, tempUserList)){
                    currentCorrectNum++;
                    if(currentCorrectNum<2){
                      showRightPic=false;
                      print("当前关卡正确数："+currentCorrectNum.toString());
                      Future.delayed(Duration(seconds: 1),(){
                        showRightPic=true;
                        currentState=CurrentState.waiting;
                        startGame();
                      });
                    }else{
                      if(checkpoint==4){
                        totalCorrectNum+=currentCorrectNum;
                        totalWrongNum+=currentWrongNum;
                        levelCorrectNum[checkpoint-1]=currentCorrectNum;
                        levelWrongNum[checkpoint-1]=currentWrongNum;
                        print("关卡"+checkpoint.toString()+"错题数为："+levelWrongNum[checkpoint-1].toString()+
                            "，答题数为："+(levelCorrectNum[checkpoint-1]+levelWrongNum[checkpoint-1]).toString());
                        currentState=CurrentState.questionDone;
                        print("挑战成功，游戏结束");
                        print("总正确数"+totalCorrectNum.toString());
                        print("总错误数"+totalWrongNum.toString());
                      }else{
                        totalCorrectNum+=currentCorrectNum;
                        totalWrongNum+=currentWrongNum;
                        levelCorrectNum[checkpoint-1]=currentCorrectNum;
                        levelWrongNum[checkpoint-1]=currentWrongNum;
                        print("关卡"+checkpoint.toString()+"错题数为："+levelWrongNum[checkpoint-1].toString()+
                            "，答题数为："+(levelCorrectNum[checkpoint-1]+levelWrongNum[checkpoint-1]).toString());
                        currentWrongNum=0;
                        currentCorrectNum=0;
                        showRightPic=false;
                        //保证关卡数字同步更新
                        Future.delayed(Duration(seconds:1),(){
                          checkpoint++;
                          showRightPic=true;
                          currentState=CurrentState.waiting;
                        });
                        print("当前关卡数："+checkpoint.toString());
                        startGame();
                      }
                    }
                  }else{
                    currentWrongNum++;
                    print("当前关卡错误次数："+currentWrongNum.toString());
                    if(currentWrongNum==defaultNum){
                      totalCorrectNum+=currentCorrectNum;
                      totalWrongNum+=currentWrongNum;
                      levelCorrectNum[checkpoint-1]=currentCorrectNum;
                      levelWrongNum[checkpoint-1]=currentWrongNum;
                      print("关卡"+checkpoint.toString()+"错题数为："+levelWrongNum[checkpoint-1].toString()+
                          "，答题数为："+(levelCorrectNum[checkpoint-1]+levelWrongNum[checkpoint-1]).toString());
                      currentState=CurrentState.questionDone;
                      print("挑战失败，游戏结束");
                      print("总正确数"+totalCorrectNum.toString());
                      print("总错误数"+totalWrongNum.toString());
                    }else{
                      showWrongPic=false;
                      Future.delayed(Duration(seconds: 1),(){
                        showWrongPic=true;
                        currentState=CurrentState.waiting;
                        restartGame();
                      });
                    }
                  }
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
                      deleteYellowBox(0),
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
                      deleteYellowBox(1),
                      Expanded(
                          flex: 7,
                          child: Text("")
                      ),
                      deleteYellowBox(2),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Row(
                    children: <Widget>[
                      deleteYellowBox(3),
                      Expanded(
                          flex: 7,
                          child: Text("")
                      ),
                      deleteYellowBox(4),
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
                      deleteYellowBox(5),
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
            Text("错误率", textAlign: TextAlign.center, style: titleStyle),
          ]
      )
    ];

    for(int i=0;i<5;i++){
      List<Widget> tableRow = [];
      tableRow.add(Container(
        alignment: Alignment.center,
        height: setHeight(100),
        child: Text(i==4?"总错误率":(i+1).toString(),
            textAlign: TextAlign.center, style: contentStyle),
      ));
      tableRow.add(Container(
        alignment: Alignment.center,
        height: setHeight(100),
        child: Text(i==4?(totalWrongNum*100/(totalWrongNum+totalCorrectNum)).truncate().toString()+"%"
            :((levelCorrectNum[i]+levelWrongNum[i]==0)?"本关卡未测试":(levelWrongNum[i]*100/(levelCorrectNum[i]+levelWrongNum[i])).truncate().toString()+"%"),
            textAlign: TextAlign.center, style: contentStyle),
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
    //TODO: 定义主体布局，长宽分别为1960*1350像素
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
  waiting, //刚进入界面等待
  questionPrepare, //题目闪烁
  doingQuestion, //答题时间
  questionDone, //答题完毕
}