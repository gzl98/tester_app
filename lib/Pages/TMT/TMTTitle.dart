import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';
class TMTPageTitle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TMTPageTitleState();
  }

}
//标题栏组件
class TMTPageTitleState extends State<TMTPageTitle>{
  var _testName="月宣布";
  int _testId=7;
  var mazeId="01";
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }
  void getUserInfo() async {
    var username=await StorageUtil.getStringItem("username");
    int id=await StorageUtil.getIntItem("id");
    setState(() {
      _testName = username;
      _testId=id;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child:Align(
              child: Text("患者姓名："+this._testName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
              alignment:Alignment.bottomCenter,
            ),

          ),
          Expanded(
            flex: 1,
            child:Align(
              child: Text("患者编号："+this._testId.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
              alignment:Alignment.bottomCenter,
            ),
          ),
          Expanded(
            flex: 5,
            child:Align(
              child: Text("连点成线-"+this.mazeId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0),),
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