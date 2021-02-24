import 'package:flutter/material.dart';

//有状态的部件
class CharacterPageTitle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CharacterPageTitleState();
  }
}

//标题栏组件
class CharacterPageTitleState extends State<CharacterPageTitle>{
  var personName="哈哈哈";
  var personId="666";
  var testId="01";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child:Align(
              child: Text("测试者姓名："+this.personName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
              alignment:Alignment.bottomLeft,
            ),

          ),
          Expanded(
            flex: 2,
            child:Align(
              child: Text("测试者编号："+this.personId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
              alignment:Alignment.bottomLeft,
            ),
          ),
          Expanded(
            flex: 6,
            child:Align(
              child: Text("编码测试-"+this.testId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0),),
              alignment:Alignment.center,
            ),
          ),
          Expanded( //保证位置的居中好看
            flex: 5,
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