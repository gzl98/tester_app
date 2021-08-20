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
import 'package:tester_app/Pages/FlankerTest/FlankerTestQuestion.dart';
import 'package:tester_app/config/config.dart';

import '../../questions.dart';

class FlankerTestMainPage extends StatefulWidget {
  static const routerName = "/FlankerTestMainPage";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FlankerTestMainPageState();
  }
}

class FlankerTestMainPageState extends State<FlankerTestMainPage> {

  //图片序号与名称对应，0左箭头，1右箭头
  List<String> numToPicture=['long_left_arrow','long_right_arrow'];



  //出题器
  FlankerTestQuestion flankerTestQuestion;
  //当前状态（初始为等待）
  CurrentState currentState=CurrentState.waiting;
  //总答对次数
  int totalCorrectNum=0;
  //总错误次数
  int totalWrongNum=0;


  //每次的答案矩阵
  List question;
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
    //startGame();
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
      disabledButton=false;
    });
    //延迟一秒后开始显示题目
    Future.delayed(Duration(seconds:1),(){
      setState(() {
        showRightPic=true;
        showWrongPic=true;
        currentState=CurrentState.questionPrepare;
        question=flankerTestQuestion.getQuestion();
        print("question列表："+question.toString());
        //展示相应秒数后再次隐去
        Future.delayed(Duration(seconds: 2),(){
          setState(() {
            currentState=CurrentState.doingQuestion;
          });
        });
      });
    });
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

  //单个出题图片
  Widget arrowPicture(arrowNum){
    List temp=[];
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/v4.0/Flanker/'+numToPicture[arrowNum]+'.png'),
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
            )
        ),
      ),
    );
  }

  //一行五个出题页面
  //避免报错type 'List<dynamic>' is not a subtype of type 'List<Widget>'，要加一个content的widget
  Widget arrow_line(List index) {
    List<Widget> temp = [];
    for(int i=0;i<index.length;i++){
      temp.add(arrowPicture(index[i]));
    }
    Widget content;
    content = Expanded(
      flex: 4,
      child: Row(
        children: temp,
      )
    );
    return content;
  }

  //图片位置布局
  Widget buildTopWidget() {
    return Expanded(
      flex: 4,
      child: Container(
        width: maxWidth,
        height: maxHeight,
        child: Column(
          children: <Widget>[
            //文字区域
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text("If the MIDDLE arrow is pointing this way,choose this button.",
                      style:TextStyle(fontSize: setSp(65),color: Colors.black ) ,textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),
                ],
              ),
            ),
            //图片区域
            Expanded(
              flex: 3,
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
                          flex: 2,
                          child: Text(""),
                        ),
                        arrow_line([1,0,1,0,1]),
                        Expanded(
                          flex: 2,
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
            ),
          ],
        ),
      ),
    );
  }

  //按钮位置布局
  Widget buildBottomWidget() {
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
            )
          ],
        ),
      ),
    );
  }



  // //构建结果列表列表
  // Widget buildListWidget() {
  //   TextStyle titleStyle = TextStyle(fontSize: setSp(45), fontWeight: FontWeight.w900, color: Colors.white);
  //   TextStyle contentStyle = TextStyle(fontSize: setSp(40), fontWeight: FontWeight.bold);
  //   List<TableRow> table = [
  //     TableRow(
  //         decoration: BoxDecoration(color: Colors.black54),
  //         children: [
  //           Container(
  //               alignment: Alignment.center,
  //               height: setHeight(120),
  //               child: Text("关卡数", textAlign: TextAlign.center, style: titleStyle)
  //           ),
  //           Text("错误率", textAlign: TextAlign.center, style: titleStyle),
  //         ]
  //     )
  //   ];
  //
  //   for(int i=0;i<5;i++){
  //     List<Widget> tableRow = [];
  //     tableRow.add(Container(
  //       alignment: Alignment.center,
  //       height: setHeight(100),
  //       child: Text(i==4?"总错误率":(i+1).toString(),
  //           textAlign: TextAlign.center, style: contentStyle),
  //     ));
  //     tableRow.add(Container(
  //       alignment: Alignment.center,
  //       height: setHeight(100),
  //       child: Text(i==4?(totalWrongNum*100/(totalWrongNum+totalCorrectNum)).truncate().toString()+"%"
  //           :((levelCorrectNum[i]+levelWrongNum[i]==0)?"本关卡未测试":(levelWrongNum[i]*100/(levelCorrectNum[i]+levelWrongNum[i])).truncate().toString()+"%"),
  //           textAlign: TextAlign.center, style: contentStyle),
  //     ));
  //     table.add(TableRow(
  //         decoration: BoxDecoration(
  //             color: i % 2 == 0 ? Colors.white : Colors.grey[100],
  //             border: Border(
  //                 bottom: BorderSide(color: Color.fromARGB(255, 50, 50, 50)))),
  //         children: tableRow));
  //   }
  //
  //   return Container(
  //     child: Table(
  //       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //       children: table,
  //     ),
  //   );
  // }



  double floatWindowRadios = 30;
  TextStyle resultTextStyle = TextStyle(
      fontSize: setSp(50), fontWeight: FontWeight.bold, color: Colors.blueGrey);

  // //显示结果部件
  // Widget buildResultWidget() {
  //   return Container(
  //     width: maxWidth,
  //     height: maxHeight,
  //     color: Color.fromARGB(220, 45, 45, 45),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SizedBox(height: setHeight(100)),
  //         Container(
  //           width: setWidth(800),
  //           height: setHeight(800),
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
  //             buildListWidget(),
  //           ]),
  //         ),
  //         SizedBox(height: setHeight(200)),
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
  //               //上传数据
  //               // Map map = {
  //               //   "关卡正确数": levelCorrectNum,
  //               //   "关卡错误数": levelWrongNum,
  //               // };
  //               // String text = json.encode(map);
  //               // setAnswer(questionIdPairAssoLearning,
  //               //     score: totalCorrectNum, answerText: text);
  //               Navigator.pushNamedAndRemoveUntil(
  //                   context, TestNavPage.routerName, (route) => false);
  //               //加入该题目结束标志
  //               testFinishedList[questionIdPairAssoLearning]=true;
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
        // showRightPic==false?Positioned(
        //   top: setHeight(450),
        //   right: setWidth(1020),
        //   child: Image.asset("images/v2.0/correct.png", width: setWidth(480)),
        // ):Container(),
        // showWrongPic==false?Positioned(
        //   top: setHeight(450),
        //   right: setWidth(1035),
        //   child: Image.asset("images/v2.0/wrong.png", width: setWidth(480)),
        // ):Container(),
        // currentState==CurrentState.waiting?showPrepareBackground():Container(),
        // currentState==CurrentState.waiting?showPrepare():Container(),
        // currentState==CurrentState.questionDone?buildResultWidget():Container(),
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