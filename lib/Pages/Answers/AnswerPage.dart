import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tester_app/Pages/Answers/AnswerData.dart';
import 'package:tester_app/Pages/Login&Register/CompleteInfoPage.dart';
import 'package:tester_app/Pages/Login&Register/ShowInfoPage.dart';

class _AnswerPageState extends State<AnswerPage> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  Future<bool> showExitDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('确定返回吗?'),
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
        ));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          key: _globalKey,
          appBar: AppBar(
            title: Text("我的试卷"),
            automaticallyImplyLeading: false,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, ShowInfoPage.routerName, (route) => false),
            ),
          ),
          body: new Container(
            width: double.infinity,
            child: new PaginatedAnswerTable(),
          )),
      onWillPop: () => showExitDialog(context),);
  }
}

class AnswerPage extends StatefulWidget {
  static const String routerName = "/UserAnswers";
  AnswerPage({Key key}) : super(key: key);

  @override
  _AnswerPageState createState() => new _AnswerPageState();
}
