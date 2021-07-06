import 'dart:async';
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

  //出题器
  PairALQuestion pairALQuestion;
  //当前状态
  CurrentState currentState;
  //应答题数目/出题数目
  int questionSize;
  //答题数目统计
  int questionNum;
  //当前关卡按键总数
  int currentKeyNum=0;
  //总的关卡按键总数
  int totalKeyNum=0;
  //当前关卡错误次数
  int currentWrongNum=0;
  //总关卡错误次数
  int totalWrongNum=0;
  //每次的答案矩阵，先4再6
  List question;
  //当前关卡数
  int checkpoint;
  //bool判断每张图片是否应该展示
  List showPicture = new List<bool>.generate(6, (int i) {
    return false;
  });
  //是否展示答案的图片
  List answerPicture = new List<bool>.generate(6, (int i) {
    return false;
  });
  //序号对应图片名称
  List<String> numToPicture=['square','circular','triangle','cross'];
  //当前关数延迟秒数
  List<int> checkpointDelayedSec=[2,3,4,6];
  //临时数字，记录初始要展示的图片编号
  int tempNum;
  //记录所按的图片
  List pictureList=new List<int>.generate(120, (int i) {
    return -1;
  });
  //记录所按的位置
  List positionList=new List<int>.generate(120, (int i) {
    return -1;
  });
  //记录答案所按图片
  List answerPictureList=[];
  //记录答案所按位置
  List answerPositionList=[];


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
    setState(() {
      checkpoint=1;
      questionSize=2;
      currentState = CurrentState.waiting;
    });
    //延迟一秒后开始显示题目
    Future.delayed(Duration(seconds:1),(){
      setState(() {
        currentState=CurrentState.questionPrepare;
        pairALQuestion=new PairALQuestion(questionSize);
        question=pairALQuestion.getQuestion();
        print(question);
        //展示相应秒数后再次隐去
        Future.delayed(Duration(seconds: checkpointDelayedSec[checkpoint]),(){
          setState(() {
            currentState=CurrentState.doingQuestion;
          });
        });
      });
    }
    );
  }

  //判断并记录标准答案
  void checkAnswer(int position){
    for(int i=0;i<4;i++){
      for(int j=0;j<6;j++){
        if(question[i][j]==1){
          if(j==position){
            tempNum=i;
            showPicture[position]=true;
            answerPictureList.add(i);
            answerPositionList.add(j);
          }
        }
      }
    }
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
            answerPicture[position]?
            Column(
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
                                  image: AssetImage('images/v4.0/PairAL/'+numToPicture[pictureList[currentKeyNum]].toString()+'.png'),
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
            ): FlatButton(
              color:Colors.transparent,
              onPressed: (){
                setState(() {
                  print("位置"+position.toString());
                  positionList[currentKeyNum]=position;
                  //避免先按了位置按钮
                  int temp1=0;
                  int temp2=0;
                  for(int i=0;i<120;i++){
                    if(pictureList[i]!=-1){
                      temp1++;
                    }
                    if(positionList[i]!=-1){
                      temp2++;
                    }
                  }
                  if(temp1==temp2){
                    currentKeyNum++;
                    int remainder=(currentKeyNum-totalKeyNum)%questionSize;
                    answerPicture[position]=true;
                    print(currentKeyNum);
                    print("图片列表："+pictureList.toString());
                    print("位置列表："+positionList.toString());
                  }else{
                    positionList[currentKeyNum]=-1;
                  }
                });
              },
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
              border: Border.all(color: Colors.teal, width: 2.0),
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
                                    pictureList[currentKeyNum]=pictureNum;
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

  // double floatWindowRadios = 30;
  // TextStyle resultTextStyle = TextStyle(
  //     fontSize: setSp(50), fontWeight: FontWeight.bold, color: Colors.blueGrey);

  //显示结果部件
  // Widget buildResultWidget() {
  //   return Container(
  //     width: maxWidth,
  //     height: maxHeight,
  //     color: Color.fromARGB(220, 45, 45, 45),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SizedBox(height: setHeight(200)),
  //         Container(
  //           width: setWidth(800),
  //           height: setHeight(450),
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //               color: Color.fromARGB(255, 229, 229, 229),
  //               borderRadius: BorderRadius.all(
  //                   Radius.circular(setWidth(floatWindowRadios))),
  //               boxShadow: [
  //                 BoxShadow(
  //                     color: Color.fromARGB(255, 100, 100, 100),
  //                     blurRadius: setWidth(10),
  //                     offset: Offset(setWidth(1), setHeight(2)))
  //               ]),
  //           child: Column(children: [
  //             Container(
  //               height: setHeight(100),
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 boxShadow: [BoxShadow()],
  //                 color: Color.fromARGB(255, 229, 229, 229),
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(setWidth(floatWindowRadios)),
  //                     topRight: Radius.circular(setWidth(floatWindowRadios))),
  //               ),
  //               child: Text(
  //                 "测验结果",
  //                 style: TextStyle(
  //                     fontSize: setSp(50),
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.blue),
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(top: setHeight(30)),
  //               height: setHeight(230),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                       Expanded(
  //                         flex: 5,
  //                         child: Align(
  //                           child:Text(
  //                               "正确数：" +
  //                                   correctNumber.toString() +
  //                                   "      ",
  //                               style: resultTextStyle),
  //                           alignment: Alignment.centerLeft,
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                       Expanded(
  //                         flex: 5,
  //                         child:Align(
  //                           child:Text(
  //                               "错误数：" + wrongNumber.toString() + "      ",
  //                               style: resultTextStyle),
  //                           alignment: Alignment.centerLeft,
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                       Expanded(
  //                           flex: 5,
  //                           child:Align(
  //                             child:Text(
  //                                 "准确率：" + correctPercent.toString() + " %",
  //                                 style: resultTextStyle),
  //                             alignment: Alignment.centerLeft,
  //                           )
  //                       ),
  //                       Expanded(
  //                         flex: 3,
  //                         child: Text(""),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ]),
  //         ),
  //         SizedBox(height: setHeight(300)),
  //         Container(
  //           width: setWidth(500),
  //           height: setHeight(120),
  //           decoration: BoxDecoration(
  //             // border: Border.all(color: Colors.white,width: setWidth(1)),
  //             gradient: LinearGradient(
  //               begin: Alignment.topCenter,
  //               end: Alignment.bottomCenter,
  //               colors: [
  //                 Color.fromARGB(255, 253, 160, 60),
  //                 Color.fromARGB(255, 217, 127, 63)
  //               ],
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black54,
  //                 offset: Offset(setWidth(1), setHeight(1)),
  //                 blurRadius: setWidth(5),
  //               )
  //             ],
  //           ),
  //           child: TextButton(
  //             style: ButtonStyle(
  //                 backgroundColor:
  //                 MaterialStateProperty.all(Colors.transparent)),
  //             onPressed: () {
  //               Navigator.pushNamedAndRemoveUntil(
  //                   context, TestNavPage.routerName, (route) => false);
  //               sendData();
  //               //加入该题目结束标志
  //               testFinishedList[questionIdNewCharacter]=true;
  //             },
  //             child: Text(
  //               "结 束",
  //               style: TextStyle(color: Colors.white, fontSize: setSp(60)),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  //主界面布局
  @override
  Widget buildPage(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Color.fromARGB(255, 218, 232, 252),
      width: maxWidth,
      height: maxHeight,
      child: Column(
        children: <Widget>[
          buildTopWidget(),
          Divider(height: 3.0, color: Color.fromARGB(120, 255, 0, 0), thickness: 3.0,),
          buildBottomWidget(),
        ],
      ),
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