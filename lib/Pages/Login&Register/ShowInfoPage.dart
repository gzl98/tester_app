import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/Utils.dart';

class ShowInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowInfoPageState();
  }
}

class _ShowInfoPageState extends State<ShowInfoPage> {
  String _username;
  String _sex;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    initUserInfo();
    super.initState();
  }

  void initUserInfo() async {
    _username = await StorageUtil.getStringItem("username");
    _sex = await StorageUtil.getStringItem("sex");
  }

  TextStyle fontStyle =
      TextStyle(fontSize: setSp(50), fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "$_username$_sex您好！",
                style:
                    TextStyle(fontSize: setSp(60), fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: setWidth(100),
              ),
              Text(
                "当前总测试数：6",
                style:
                    TextStyle(fontSize: setSp(60), fontWeight: FontWeight.bold),
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
                Navigator.pushNamed(context, "/TMT");
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
    );
  }

  void _logout(BuildContext context) async {
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
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false),
                ),
              ],
            ));
  }
}
