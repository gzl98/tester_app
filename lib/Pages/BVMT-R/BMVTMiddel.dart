import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Rules.dart';
import '../../DrawWidget/DrawPainter.dart';
//中间题目展示组件
class BMVTPageMiddel extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
            flex: 4,
            child:Container(
              child:MyPainterPage(imgPath: 'images/BMVT.jpeg',),
            ),
        ),
        VerticalDivider(width: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 1,
          child:Container(
            child: RightInfoColum(),
          ),
        ),
      ],
    );
  }
}

//右边信息栏
class RightInfoColum extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_TesterInfoState("XXX","200s",mazeRules,"未完成");

}
class _TesterInfoState extends State<RightInfoColum>{
  var testName="";
  var testTime="";
  var scoreRules="";
  var isFinish="未完成";
  var _titleStyle=TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.w600
  );
  var _subTitleStyle=TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600
  );
  var _normalStyle=TextStyle(
    fontSize: 20.0,
  );
  _TesterInfoState(this.testName,this.testTime,this.scoreRules,this.isFinish){
    print(this.scoreRules);
  }
  @override
  Widget build(BuildContext context) {
    var paddingEdage=EdgeInsets.all(6);
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.start ,
      children: <Widget>[
        Container(
            color: Colors.black12,
            child:Center(
              child: Text("题目说明",style: _titleStyle),
            ) ,
          ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness:1,),
        Container(
          padding: paddingEdage,
          child: Text(this.scoreRules,style: _normalStyle),
        ),
      ],
    );
  }
}
