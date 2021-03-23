import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/Utils.dart';

class SymbolMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SymbolMainPageState();
  }
}

class SymbolMainPageState extends State<SymbolMainPage> {

  //熟悉操作界面是否隐去
  bool knowOperationHidden=false;
  //是否开始延迟显示
  bool delayedShow=false;
  //图片延时时间设置
  int pictureDelayedTime=1;
  //符号检索图片数
  int symbolPictureNumber=36;
  //是否开始新一轮答题展示
  bool newAnswerRound=false;

  //尝试的两张图片的基本组
  List<int> testBasic=new List();
  //尝试的五张图片的对照组
  List<int> testContrast=new List();
  //记录测试的基本组评判序号
  int testBasicCount=0;
  //记录测试的对照组评判序号
  int testContrastCount=0;
  //测试时的对错记录
  List<bool> testCorrect=new List();


  //获取随机图片编号
  getRandomNumber(List<int> temp,int num){
    int count=0;  //统计获取的图片数量
    int long=temp.length; //记录初始列表长度
    while(count<num){
      int tempNum=Random().nextInt(36)+1;
      bool allow=true;  //是否加入列表
      //去除重复图案出现
      for(int i=long;i<temp.length;i++){
        if(temp[i]==tempNum){
          allow=false;
        }
      }
      if(allow==true){
        temp.add(tempNum);
        count++;
      }
    }
  }

  //检索图片组件
  Widget symbolWidget(int number){
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/symbol/'+number.toString()+'.png'),
              fit: BoxFit.scaleDown,
              alignment: Alignment.center),
        ),
      ),
    );
  }

  //一系列图片展示
  Widget pictureWidget(List<int> temp,int num){
    int long=temp.length; //记录初始长度
    getRandomNumber(temp, num);
    List<Widget>picture=[];  //存放部件
    for(int i=long;i<temp.length;i++){
      picture.add(symbolWidget(temp[i]));
    }
    Widget content=Row(
      children: picture,
    );
    print("此时的列表："+temp.toString());
    return content;
  }

  //判断对错
  judgeRightOrWrong(List<int> temp1,List<int> temp2){
    bool testRightOrWrong=false;  //当前题目正误
    for(int i=testBasicCount;i<testBasicCount+2;i++){
      for(int j=testContrastCount;i<testContrastCount+5;j++){
        if(temp1[i]==temp2[j]){
          testRightOrWrong=true;
        }
      }
    }
    testBasicCount+=2;
    testContrastCount+=5;
    return testRightOrWrong;
  }


  //*顶部背景*
  Widget buildTopWidget() {
    return Expanded(
      flex: 4,
      child: Container(
        color: Color.fromARGB(200, 0, 0, 0),
        child: Row(
          children: <Widget>[
            //缩放闹钟图片
            Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 3, child: Text("")),
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/clock.png'),
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter),
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: Text("")),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Align(
                  child: Text(
                    "时间：120",
                    style: TextStyle(
                        fontSize: setSp(60),
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  alignment: Alignment.centerLeft,
                )),
            Expanded(flex: 10, child: Text("")),
          ],
        ),
      ),
    );
  }

  //*图片区域*
  Widget buildMediumWidget() {
    return Expanded(
      flex: 6,
      child: Row(
        children: <Widget>[
          //共33
          //空白左
          Expanded(
            flex: 6,
            child: Text(""),
          ),
          //图片左
          Expanded(
              flex: 6,
              child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(20, 0, 0, 0),
                      border: Border.all(color: Colors.blue, width: 3.0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: delayedShow? pictureWidget(testBasic, 2): Text(""),
              )
          ),
          //空白中
          Expanded(
            flex: 1,
            child: Text(""),
          ),
          //图片+文字右
          Expanded(
              flex: 15,
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                    color: Color.fromARGB(20, 0, 0, 0),
                    border: Border.all(color: Colors.indigo[100], width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: delayedShow?pictureWidget(testContrast, 5):
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                    Expanded(
                      flex: 2,
                      //准备框
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(""),
                          ),
                          //准备两个字
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "准备",
                                style: TextStyle(
                                  fontSize: setSp(88),
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red[300],
                                ),
                              ),
                              decoration: new BoxDecoration(
                                // border: new Border.all(color: Color.fromARGB(20, 0, 0, 0), width: 0.5),
                                border: Border(
                                    top: BorderSide(
                                        color: Color.fromARGB(20, 0, 0, 0),
                                        width: 0.5), // 上边边框
                                    right: BorderSide(
                                        color: Colors.transparent), // 右侧边框
                                    bottom: BorderSide(
                                        color: Color.fromARGB(20, 0, 0, 0),
                                        width: 5), // 底部边框
                                    left: BorderSide(
                                        color: Colors.transparent)), // 左侧边框
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 235, 235, 235),
                                      Color.fromARGB(255, 255, 255, 255),
                                      Color.fromARGB(255, 235, 235, 235),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(5, 0, 0, 0),
                                      offset: Offset(0.0, 6.0), //阴影y轴偏移量
                                      blurRadius: 0, //阴影模糊程度
                                      spreadRadius: 0 //阴影扩散程度
                                      )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(""),
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
              )),
          //空白右
          Expanded(
            flex: 5,
            child: Text(""),
          ),
        ],
      ),
    );
  }

  //*有无两个按键区域*
  Widget buildBottomWidget() {
    return Expanded(
      flex: 14,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 25,
            child: Text(""),
          ),
          Expanded(
              flex: 6,
              child: Container(
                width: 250.0,
                height: 260.0,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 235, 235, 235),
                  border: Border.all(color: Colors.indigo[100], width: 2.0),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(150, 0, 0, 0),
                        offset: Offset(5.0, 5.0), //阴影x轴偏移量
                        blurRadius: 10, //阴影模糊程度
                        spreadRadius: 0 //阴影扩散程度
                        )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                    Expanded(
                      flex: 10,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(""),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                //撑满组件维度
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 235, 235, 235),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromARGB(150, 0, 0, 0),
                                        offset: Offset(1.0, 1.0), //阴影x轴偏移量
                                        blurRadius: 1, //阴影模糊程度
                                        spreadRadius: 0 //阴影扩散程度
                                    )
                                  ],
                                ),
                                child: RaisedButton(
                                  color: Colors.white,
                                  splashColor: Colors.pinkAccent,
                                  onPressed: () {},
                                  child: Text(
                                    "有",
                                    style: TextStyle(
                                        fontSize: setSp(60),
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(150, 0, 0, 0)),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Text(""),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                //撑满组件维度
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 235, 235, 235),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromARGB(150, 0, 0, 0),
                                        offset: Offset(1.0, 1.0), //阴影x轴偏移量
                                        blurRadius: 1, //阴影模糊程度
                                        spreadRadius: 0 //阴影扩散程度
                                    )
                                  ],
                                ),
                                child: RaisedButton(
                                  color: Colors.white,
                                  splashColor: Colors.pinkAccent,
                                  onPressed: () {},
                                  child: Text(
                                    "无",
                                    style: TextStyle(
                                        fontSize: setSp(60),
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(150, 0, 0, 0)),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Text(""),
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
              )),
          Expanded(
            flex: 1,
            child: Text(""),
          ),
        ],
      ),
    );
  }

  //*熟悉操作界面*
  Widget buildFloatWidget() {
    return Container(
      //确保占满屏幕宽度和高度
      width: maxWidth,
      height: maxHeight,
      color: Color.fromARGB(220, 150, 150, 150),
      child: Column(
        //主轴对齐位置
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //空间位置调整
          SizedBox(
            height: setHeight(100),
          ),
          Container(
            width: setWidth(700),
            height: setHeight(700),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 229, 229),
                borderRadius: BorderRadius.all(Radius.circular(setWidth(50))),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 100, 100, 100),
                      //数字越大越模糊。默认值是0，表示一点也不进行模糊
                      blurRadius: setWidth(10),
                      //阴影与容器的距离
                      offset: Offset(setWidth(1), setHeight(2)))
                ]),
            child: Text(
              "熟悉操作方法",
              style: TextStyle(fontSize: setSp(60)),
            ),
          ),
          SizedBox(
            height: setHeight(250),
          ),
          Container(
            width: setWidth(500),
            height: setHeight(120),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff418ffc), Color(0xff174cfc)],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(setWidth(1), setHeight(1)),
                    blurRadius: setWidth(5),
                  )
                ]),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                setState(() {
                  knowOperationHidden=true; //要隐藏
                });
                //延时1s函数
                Future.delayed(Duration(seconds: pictureDelayedTime), (){
                  setState(() {
                    delayedShow=true; //开始延迟显示
                  });
                });
              },
              child: Text(
                "开始",
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
    // TODO: implement build
    return Stack(
      children: <Widget>[
        //第一个child被绘制在最底端，后面的依次在前一个child的上面
        //主界面
        Column(
          children: <Widget>[
            buildTopWidget(),
            //分界线
            Divider(
              height: 3.0,
              color: Color.fromARGB(120, 255, 0, 0),
              thickness: 3.0,
            ),
            //上面空白间隔
            Expanded(
              flex: 7,
              child: Text(""),
            ),
            buildMediumWidget(),
            //中间空白间隔
            Expanded(
              flex: 1,
              child: Text(""),
            ),
            buildBottomWidget(),
            //下面空白间隔
            Expanded(
              flex: 1,
              child: Text(""),
            ),
          ],
        ),
        // 浮窗界面
        Offstage(
          offstage: knowOperationHidden,
          child: buildFloatWidget(),
        )
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
