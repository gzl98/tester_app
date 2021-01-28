import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';

class ShowInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowInfoPageState();
  }
}

class _ShowInfoPageState extends State<ShowInfoPage> {
  String _username;
  String _sex;
  int _testCount;

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
    setState(() {
      _username = username;
      if (sexCode == 0)
        _sex = "先生";
      else if (sexCode == 1) _sex = "女士";
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
      onWillPop: () => showQuitProgramDialog(context),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: setHeight(300),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$_username $_sex，您好！",
                  style: TextStyle(
                      fontSize: setSp(60), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: setWidth(100),
                ),
                Text(
                  "当前总测试数：$_testCount",
                  style: TextStyle(
                      fontSize: setSp(60), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              width: setWidth(2000),
              height: setHeight(400),
              margin: EdgeInsets.only(top: setHeight(30)),
              child: FlatButton(
                // color: Colors.red,
                child: Text(
                  "开 始 测 试",
                  style: TextStyle(
                    fontSize: setSp(180),
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onPressed: () {
                  _start(context); //开始答题
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/TMT", (router) => false);
                },
              ),
            ),
            SizedBox(
              height: setHeight(380),
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

  void _start(BuildContext context) async {
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
