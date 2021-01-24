import 'package:flutter/material.dart';
class MazePageTitle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MazePageTitleState();
  }

}
//标题栏组件
class MazePageTitleState extends State<MazePageTitle>{
  var testName="月宣布";
  var testId="89008";
  var mazeId="01";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child:Align(
              child: Text("患者姓名："+this.testName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
              alignment:Alignment.bottomCenter,
            ),

          ),
          Expanded(
            flex: 1,
            child:Align(
              child: Text("患者编号："+this.testId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
              alignment:Alignment.bottomCenter,
            ),
          ),
          Expanded(
            flex: 5,
            child:Align(
              child: Text("迷宫-"+this.mazeId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0),),
              alignment:Alignment.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(""),
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //   border:Border(
      //     bottom: BorderSide(width: 2.0,color: Colors.grey),
      //   ),
      // ),
    );
  }

}