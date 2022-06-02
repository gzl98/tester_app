import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/Answers/AnswerPage.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';

import '../../questions.dart';

class ShowInfoPage extends StatefulWidget {
  static const routerName = "/ShowInfoPage";

  @override
  State<StatefulWidget> createState() {
    return _ShowInfoPageState();
  }
}

class _ShowInfoPageState extends State<ShowInfoPage> {
  String _username;
  String _sex;
  int _testCount;
  String _email;
  String _birthDate;

  //防止多次生成问卷
  bool createFlag = true;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    initUserInfo();
    getTestCount();
    super.initState();
  }

  void initUserInfo() async {
    String username = await StorageUtil.getStringItem("username");
    int sexCode = await StorageUtil.getIntItem("sex");
    String email = await StorageUtil.getStringItem("email");
    String birthDate = await StorageUtil.getStringItem("birthDate");
    setState(() {
      _username = username;
      if (sexCode == 0)
        _sex = "男";
      else if (sexCode == 1) _sex = "女";
      _email = email;
      _birthDate = birthDate;
    });
  }

  void getTestCount() async {
    String username = await StorageUtil.getStringItem("username");
    String token = await StorageUtil.getStringItem("token");
    Response response;
    Dio dio = Dio();
    try {
      response = await dio.get(baseUrl + "queryQN_username",
          queryParameters: {"username": username},
          options: getAuthorizationOptions(token));
      setState(() {
        _testCount = response.data.length;
      });
    } catch (e) {
      print(e);
    }
  }

  TextStyle fontStyle =
      TextStyle(fontSize: setSp(50), fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitDialog(context),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: setHeight(250),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(top: setHeight(30)),
                  width: setWidth(500),
                  height: setHeight(500),
                  // color: Colors.redAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "用户名：",
                        style: TextStyle(
                            fontSize: setSp(60), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "性别：",
                        style: TextStyle(
                            fontSize: setSp(60), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "邮箱：",
                        style: TextStyle(
                            fontSize: setSp(60), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "出生日期：",
                        style: TextStyle(
                            fontSize: setSp(60), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(top: setHeight(40)),
                  width: setWidth(800),
                  height: setHeight(490),
                  // color: Colors.redAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$_username",
                        style: TextStyle(
                            fontSize: setSp(60), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$_sex",
                        style: TextStyle(
                            fontSize: setSp(60), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$_email",
                        style: TextStyle(
                            fontSize: setSp(60), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$_birthDate",
                        style: TextStyle(
                            fontSize: setSp(60), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "当前总测试数：$_testCount",
                      style: TextStyle(
                          fontSize: setSp(48),
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: setWidth(800),
                      // height: setHeight(500),
                      child: FlatButton(
                        // color: Colors.red,
                        child: Text(
                          "历 史 记 录",
                          style: TextStyle(
                            fontSize: setSp(150),
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              AnswerPage.routerName, (router) => false);
                        },
                      ),
                    ),
                    SizedBox(
                      height: setHeight(50),
                    ),
                    Container(
                      width: setWidth(800),
                      // height: setHeight(500),
                      child: FlatButton(
                        // color: Colors.red,
                        child: Text(
                          "开 始 测 试",
                          style: TextStyle(
                            fontSize: setSp(150),
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        onPressed: () {
                          if (this.createFlag) {
                            _start(context); //开始答题
                            _initTestListFnished();
                          }
                          setState(() {
                            this.createFlag = false;
                          });
                          Navigator.pushNamedAndRemoveUntil(context,
                              TestNavPage.routerName, (router) => false);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: setWidth(120),
                ),
              ],
            ),
            SizedBox(
              height: setHeight(350),
            ),
            FlatButton(
                onPressed: () {
                  _logout(context);
                },
                child: Text(
                  "退出登录",
                  style: TextStyle(
                    color: Color.fromARGB(150, 0, 0, 0),
                    fontSize: setSp(60),
                    decoration: TextDecoration.underline,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _initTestListFnished() {
    List<bool> listFnished = [];
    for (int i = 0; i < testList.length; i++) {
      listFnished.add(false);
    }
    testFinishedList = listFnished;
  }

  void _start(BuildContext context) async {
    String token = await StorageUtil.getStringItem("token");
    Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(baseUrl + "addnewQN",
          options: getAuthorizationOptions(token));
      print("问卷号：" + response.data["id"].toString());
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
