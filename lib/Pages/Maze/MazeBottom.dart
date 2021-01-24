import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';
import '../../Utils/EventBusType.dart';
//页面底端组件
// ignore: must_be_immutable
class MazePageBottom extends StatelessWidget{
  var _textStyle=TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.w600
  );
  Widget buildButtonNextQuestion(context,value) {
    return SizedBox(
      width: setWidth(260),
      height: setHeight(120),
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(30)))),
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.keyboard_arrow_right,size: setSp(80),),
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: setSp(58)),
              )
            ],
          ),
          onPressed: () {
            if(value=='上一题'){
              Navigator.pushNamedAndRemoveUntil(
                  context, "/SymbolEncoding", (route) => false);
            }
            else if(value=='下一题'){
              // Navigator.pushNamedAndRemoveUntil(
              //     context, "/BVMT", (route) => false);
              //触发下一题事件
              eventBus.fire(NextEvent(1));
              print('触发下一题！');
            }

          }),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButtonNextQuestion(context,"上一题"),
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: CheckScore(),
        ),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButtonNextQuestion(context,"下一题"),
              // Icon(Icons.keyboard_arrow_right,size: setSp(60),),
              // Text("下一题",style: _textStyle,)
            ],
          ),
        )

      ],
    );
  }
}
//评分单选按钮
class CheckScore extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ScoreRadiaState();
  }
}
//单选按钮状态
class _ScoreRadiaState extends State<CheckScore>{
  int _score=1;
  var _textStyle=TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.w400,
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("请选择该测试者分数：",style: _textStyle,),
          Radio(
            value: 1,
            groupValue: this._score,
            onChanged: (value) {
              setState(() {
                this._score = value;
              });
            },
          ),
          Text("0分",style: _textStyle,),
          SizedBox(width: 20),
          Radio(
            value: 2,
            groupValue: this._score,
            onChanged: (value) {
              setState(() {
                this._score = value;
              });
            },
          ),
          Text("1分",style: _textStyle,),
          SizedBox(width: 20),
          Radio(
            value: 3,
            groupValue: this._score,
            onChanged: (value) {
              setState(() {
                this._score = value;
              });
            },
          ),
          Text("2分",style: _textStyle,),
        ],
      ),
    );
  }
}



//页面底端工具栏
class ToolsBars extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: ButtonBar(
        children: [
          IconButton(
              icon: Icon(Icons.create),
              onPressed: null
          ),
          IconButton(
              icon: Icon(Icons.undo),
              onPressed: null
          ),
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: null
          ),
        ],
        mainAxisSize: MainAxisSize.max,
        alignment:MainAxisAlignment.center,
      ),
    );
  }
}