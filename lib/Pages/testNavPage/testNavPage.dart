import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Fragments/QuestionFirstFragment.dart';
import 'package:tester_app/Pages/Login&Register/ShowInfoPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/Utils/bubble_widget.dart';
import 'package:tester_app/questions.dart';

class TestNavPage extends StatefulWidget {
  static const routerName = "/testNavPage";

  @override
  State<StatefulWidget> createState() {
    return TestNav();
  }
}

class TestNav extends State<TestNavPage> {
  String _username = "Yu";
  String _playImgPath = "images/v2.0/play.png";
  String _correctPath = "images/v2.0/correct.png";
  int _selectIndex = 0;
  List<bool> _testFinishList=[];
  @override
  Widget build(BuildContext context) {
    initFragmentWidget();
    return WillPopScope(
      onWillPop: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('确定结束当前测试?'),
                actions: [
                  FlatButton(
                    child: Text('暂不'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, ShowInfoPage.routerName, (route) => false),
                  ),
                ],
              )),
      child: Scaffold(
        body: buildPage(context),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        new Expanded(
          flex: 20,
          child: buildTitle(),
        ),
        new Spacer(
          flex: 1,
        ),
        new Expanded(
          flex: 200,
          child: buildContext(),
        ),
        new Spacer(
          flex: 1,
        ),
      ],
    );
  }

  Widget buildTitle() {
    Size size = MediaQuery.of(context).size;
    Gradient gradient =
        LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent]);
    Shader shader =
        gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    var gradienctColorStyle = TextStyle(
      fontSize: setSp(80),
      foreground: Paint()..shader = shader,
      fontWeight: FontWeight.w900,
    );
    var nameStyle = TextStyle(
      fontSize: setSp(50),
      fontWeight: FontWeight.bold,
    );
    return new Container(
      alignment: Alignment.bottomCenter,
      color: Color(0xFFDDF7FD),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                "  " + this._username + ",您好!",
                style: nameStyle,
              )),
          Expanded(
            flex: 1,
            child: Text(
              "欢迎使用心理测评系统",
              textAlign: TextAlign.right,
              style: gradienctColorStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContext() {
    var circleBoxDecoration = new BoxDecoration(
      border: new Border.all(color: Color(0xFF99A0A0), width: 1), // 边色与边宽度
      borderRadius: new BorderRadius.circular((5.0)), // 圆角度
      //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
    );
    return Row(
      children: [
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 25,
          child: Container(
            decoration: circleBoxDecoration,
            //高度自适应
            height: double.infinity,
            child: buildListViewWithTitle(),
          ),
        ),
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 100,
          child: Container(
            decoration: circleBoxDecoration,
            child: buildRightContext(),
          ),
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }

  Widget buildListViewWithTitle() {
    var listTitleStyle = TextStyle(
      fontSize: setSp(50),
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return Column(children: <Widget>[
      ListTile(
        title: Text(
          "测 试 内 容",
          textAlign: TextAlign.center,
          style: listTitleStyle,
        ),
        tileColor: Color(0xFF8B969A),
      ),
      Expanded(
        child: new ListView.separated(
          itemCount: testList.length,
          itemBuilder: (BuildContext context, int position) {
            return getTestListItem(position);
          },
          separatorBuilder: (context, index) => Divider(
            color: Color(0xFFD0E3E8),
            height: 1.0,
            thickness: 1.0,
          ),
        ),
      ),
    ]);
  }

  Widget getTestListItem(int index) {
    var titleStyle = TextStyle(
      fontSize: setSp(40),
      color: Colors.green,
    );
    var subStyle = TextStyle(
      fontSize: setSp(40),
    );
    return Container(
      decoration: index == this._selectIndex
          ? new BoxDecoration(color: Color(0xFFDFE3E6))
          : new BoxDecoration(color: Color(0xFFFFFFFF)),
      child: ListTile(
        title: Text(
          // "加工速度",
          testList[index].questionAbility,
          style: titleStyle,
        ),
        subtitle: Text(
          // "顺序连线",
          testList[index].questionTitle,
          style: subStyle,
        ),
        isThreeLine: false,
        dense: false,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        enabled: true,
        onTap: () {
          //点击列表item调用的方法
          //改变样式
          //change RightContext
          setState(() {
            this._selectIndex = index;
          });
        },
        leading: CircleAvatar(
          backgroundColor: index==this._selectIndex?Color(0xFFDFE3E6):Color(0xFFFFFFFF),
          backgroundImage: this._testFinishList[index]
            ?AssetImage(this._correctPath)
            :AssetImage(this._playImgPath)
        ),
      ),
    );
  }

  Widget buildTestContainer() {
    return Container(
        decoration: new BoxDecoration(
      color: Colors.grey,
    ));
  }

  Widget buildRightContext() {
    return Row(
      children: [
        Spacer(
          flex: 1,
        ),

        Expanded(
          flex: 35,
          child: buildTestInfo_start(),
        ),

        Spacer(
          flex: 1,
        ),
        //VerticalDivider(width: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 15,
          child: buildTestInfo_right(),
        ),
      ],
    );
  }

  Widget buildTestInfo_start() {
    var titleStyle = TextStyle(
      fontSize: setSp(65),
      color: Color(0xFFADCAAE),
      fontWeight: FontWeight.w900,
    );
    var subStyle = TextStyle(
      fontSize: setSp(65),
      color: Color(0xFF6D7478),
      fontWeight: FontWeight.w900,
    );
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(
                // "顺序连线",
                testList[this._selectIndex].questionTitle,
                style: subStyle,
              ),
              Text(
                // "加工速度",
                testList[this._selectIndex].questionAbility,
                style: titleStyle,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Divider(
          height: 1.0,
          indent: 0,
          color: Colors.grey,
        ),
        Expanded(
            flex: 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: setHeight(125),
                  left: setWidth(60),
                  width: setWidth(1100),
                  child: Container(
                    // width: setWidth(2000),
                    // height: setHeight(400),
                    child: Image.asset(
                      testList[this._selectIndex].questionImgPath,
                    ),
                  ),
                ),
                Positioned(
                  top: setHeight(500),
                  left: setWidth(700),
                  width: setWidth(1000),
                  height: setHeight(500),
                  child: Container(
                    // width: setWidth(2000),
                    // height: setHeight(400),
                    child: Image.asset(
                      "images/v2.0/doctor.png",
                    ),
                  ),
                ),
                Positioned(
                  top: setHeight(200),
                  left: setWidth(800),
                  width: setWidth(400),
                  height: setHeight(400),
                  child: BubbleWidget(
                    setWidth(500),
                    setHeight(300),
                    Color(0xFFD9D6D6),
                    BubbleArrowDirection.bottom,
                    length: 0,
                    arrAngle: 80,
                    arrHeight: 25,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "这项测验主要评估这项测验主要评估您的",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: setSp(25),
                              fontWeight: FontWeight.w800,
                            )),
                        TextSpan(
                            text: "视觉搜索和反应速度",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: setSp(25),
                              fontWeight: FontWeight.w800,
                            )),
                        TextSpan(
                            text: "注意仔细观察右侧框中",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: setSp(25),
                              fontWeight: FontWeight.w800,
                            )),
                      ])),
                    ),
                  ),
                ),
              ],
            )),
        Expanded(
          flex: 1,
          child: buildButtonNextQuestion(),
        ),
        Spacer(
          flex: 1,
        )
      ],
    );
  }

  Widget buildButtonNextQuestion() {
    return SizedBox(
      width: setWidth(500),
      height: setHeight(50),
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(30)))),
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.keyboard_arrow_right,size: setSp(80),),
              Text(
                "开始",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: setSp(58)),)
            ],
          ),
          onPressed: () {
            //_start();
            if(!this._testFinishList[this._selectIndex]){
              Navigator.pushNamed(context, QuestionFirstFragment.routerName,
                  arguments: testList[_selectIndex]);
            }
          }),
    );
  }

  Widget buildTitleContext(String title, String context) {
    var titleStyle = new TextStyle(
      fontSize: setSp(45),
      fontWeight: FontWeight.w900,
      color: Color(0xFF63676A),
    );
    var contextStyle = new TextStyle(
      fontSize: setSp(35),
      color: Color(0xFF8B939B),
      fontWeight: FontWeight.w700,
    );
    return Container(
      width: setWidth(450),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Text(
            context,
            style: contextStyle,
          ),
        ],
      ),
    );
  }

  Widget buildTestInfo_right() {
    var circleBoxDecoration = new BoxDecoration(
      border: new Border.all(color: Color(0xFF99A0A0), width: 1), // 边色与边宽度
      borderRadius: new BorderRadius.circular((8.0)), // 圆角度
      color: Color(0xFFBCC2CA),
      //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
    );
    return Stack(
      children: [
        Positioned(
          top: setHeight(40),
          left: setWidth(40),
          width: setWidth(500),
          height: setHeight(1300),
          child: Container(
            decoration: circleBoxDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 1,
                  child: buildTitleContext(
                      "测查内容", testList[this._selectIndex].questionNavContent),
                ),
                Expanded(
                  flex: 1,
                  child: buildTitleContext(
                      "测查目的", testList[this._selectIndex].questionNavPurpose),
                ),
                Expanded(
                  flex: 1,
                  child: buildTitleContext(
                      "受益举例", testList[this._selectIndex].benefitExample),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: setWidth(300),
                    height: setHeight(300),
                    child: Image.asset("images/v2.0/watchPhone.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    getTestFinishList();
    super.initState();

  }

  void getTestFinishList(){
    setState(() {
      for(int i=0;i<testList.length;i++){
        this._testFinishList.add(false);
      }
      this._testFinishList=testFinishedList;
    });
  }
  void _start() async {
    String token = await StorageUtil.getStringItem("token");
    Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(baseUrl + "addnewQN",
          options: getAuthorizationOptions(token));
      // print(response.data);
      await StorageUtil.setIntItem("QNid", response.data["id"]);
    } catch (e) {
      print(e);
    }
  }

  void _logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("确定退出登录?"),
              actions: [
                FlatButton(
                  child: Text('暂不'),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      StorageUtil.clear();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (route) => false);
                    }),
              ],
            ));
  }
}
