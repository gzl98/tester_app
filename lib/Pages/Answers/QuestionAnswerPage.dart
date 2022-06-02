import 'package:flutter/material.dart';
import 'package:tester_app/Pages/Answers/AnswerPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/DrawWidget/DrawPainter.dart';
import 'package:tester_app/Fragments/MainFragment.dart';
import 'package:tester_app/Fragments/QuestionInfoFragment.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/EventBusType.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';
import 'package:tester_app/config/config.dart';


class QuestionAnswerPage extends StatefulWidget {
  static const String routerName = "/questionAnswerPage";

  @override
  State<StatefulWidget> createState() {
    return QuestionAnswerPageState();
  }
}

class QuestionAnswerPageState extends State<QuestionAnswerPage> {
  List<double> data = [];
  List<String> questionTitles = [
    // TODO: 需要修改题目顺序
    "顺序连线",
    "符号检索测试",
    "译码测验",
    "持续操作测试",
    "数字广度顺序",
    "数字广度倒序",
    "空间广度顺序",
    "空间广度倒序",
    "Stroop文字",
    "Stroop色词",
    "Stroop词色"
  ];
  bool dataReady = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 11; i++) {
      data.add(-1);
    }
    getQuestionResult();
  }

  getQuestionResult() async {
    var results = await getAnswerQuestionDetail();
    setState(() {
      for (var result in results) {
        print(result);
        data[result["type"]] = result["score"];
      }
      dataReady = true;
    });
  }

  Widget buildMainWidget() {
    TextStyle titleStyle = TextStyle(
        fontSize: setSp(45), fontWeight: FontWeight.w900, color: Colors.white);
    TextStyle contentStyle =
    TextStyle(fontSize: setSp(40), fontWeight: FontWeight.bold);
    List<TableRow> table = [
      TableRow(decoration: BoxDecoration(color: Colors.black54), children: [
        Container(
            alignment: Alignment.center,
            height: setHeight(120),
            child: Text("题目", textAlign: TextAlign.center, style: titleStyle)),
        Text("得分", textAlign: TextAlign.center, style: titleStyle),
        Text("操作", textAlign: TextAlign.center, style: titleStyle),
      ])
    ];
    int i = 0;
    for (var row in data) {
      int count = i;
      List<Widget> tableRow = [];
      tableRow.add(Container(
        alignment: Alignment.center,
        height: setHeight(100),
        child: Text(questionTitles[i],
            textAlign: TextAlign.center, style: contentStyle),
      ));
      tableRow.add(Container(
        alignment: Alignment.center,
        height: setHeight(100),
        child: Text(row == -1 ? "此题未答" : row.toString(),
            textAlign: TextAlign.center, style: contentStyle),
      ));
      tableRow.add(
        RaisedButton(
          onPressed: row == -1
              ? null
              : () async {
            await StorageUtil.setIntItem("id", count);
            print(i);
            print(count);
            //试卷详情的跳转路由
            // switch (count) {
            //   case 0:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(TMTPage.routerName);
            //     }
            //     break;
            //   case 1:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(SymbolPage.routerName);
            //     }
            //     break;
            //   case 2:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(NewCharacterPage.routerName);
            //     }
            //     break;
            //   case 3:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(COTPage.routerName);
            //     }
            //     break;
            //   case 4:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(WMSPage.routerName);
            //     }
            //     break;
            //   case 5:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(WMSPage.routerName);
            //     }
            //     break;
            //   case 6:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(WMSPage.routerName);
            //     }
            //     break;
            //   case 7:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(WMSPage.routerName);
            //     }
            //     break;
            //   case 8:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(StroopPage.routerName);
            //     }
            //     break;
            //   case 9:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(StroopPage.routerName);
            //     }
            //     break;
            //   case 10:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(StroopPage.routerName);
            //     }
            //     break;
            //   default:
            //     {
            //       await MyRouter.navigatorKey.currentState
            //           .pushNamed(AnswerPage.routerName);
            //     }
            //     break;
            // }
          },
          child: Text("查看"),
          color: Colors.blue,
        ),
      );
      table.add(TableRow(
          decoration: BoxDecoration(
              color: i % 2 == 0 ? Colors.white : Colors.grey[100],
              border: Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 50, 50, 50)))),
          children: tableRow));
      i++;
    }
    return SingleChildScrollView(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: table,
      ),
    );
  }
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
                  context, AnswerPage.routerName, (route) => false),
            ),
          ],
        ));
  }
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text("答题详情"),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () async => {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AnswerPage.routerName, (route) => false)
                  }
              ),
            ),
            body: dataReady ? buildMainWidget() : null,
          ),
          onWillPop: () => showExitDialog(context),);
  }
}
