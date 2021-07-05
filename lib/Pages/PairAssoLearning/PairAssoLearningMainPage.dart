import 'dart:async';
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

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  //强制退出
  @override
  void dispose() {
    super.dispose();
    // if (_timer != null && _timer.isActive) _timer.cancel();
  }

  //初始化出题器
  PairALQuestion _pairALQuestion=new PairALQuestion();




  //*图片竖直放置*
  Widget singlePicture(int number){
    return Expanded(
        flex: 12,
        child:Align(
          child: Container(
            width: setWidth(200),
            height: setHeight(200),
            decoration: BoxDecoration(
                color: Color.fromARGB(20, 0, 0, 0),
                border: Border.all(color: Colors.indigo[100], width: 2.0),
                borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),topRight:Radius.circular(20.0))
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/character/'+number.toString()+'.png'),
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center),
              ),
            ),
          ),
          alignment: Alignment.bottomCenter,
        )

    );
  }

  //*九连图片*
  Widget ninePictureUnion(){
    List<Widget> temp = [];
    for(int i=0;i<8;i++){
      temp.add(singlePicture(i+1));
      temp.add(Expanded(
        flex: 1,
        child: Text(""),
      ));
    }
    temp.add(singlePicture(9));

    return Row(
      children: temp,
    );
  }











  double floatWindowRadios = 30;
  TextStyle resultTextStyle = TextStyle(
      fontSize: setSp(50), fontWeight: FontWeight.bold, color: Colors.blueGrey);

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
      child: Text(""),
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