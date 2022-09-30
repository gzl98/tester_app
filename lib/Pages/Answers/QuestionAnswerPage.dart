import 'package:flutter/material.dart';
import 'package:tester_app/Pages/Answers/AnswerPage.dart';
import 'package:tester_app/Pages/Login&Register/ShowInfoPage.dart';
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
  List<int> data = [];
  List<int> dataTime = [];
  List<String> dataState = [];    // 1. 医生已经评分 则显示分数， 2. 医生未评分，但是已答了：显示（等待医生评分）3. 没做则显示此题未做
  List<int> specialQType = [0, 2, 3];
  List<String> questionTitles = [
    "TMT连线测试",
    "SDMT符号编码测试",
    "视觉空间记忆测验（BVMT-R）",
    "迷宫导航测试",
    "空间广度测试1",
    "顺序连线测试",
    "符号检索测试",
    "译码测验",
    "快速判断测试",
    "数字正背测试",
    "数字倒背测试",
    "空间广度测试2",
    "空间广度倒背测试",
    "Stroop词语测试",
    "Stroop色词测试",
    "Stroop词色测试"
  ];
  bool dataReady = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 16; i++) {
      data.add(-1);
      dataTime.add(0);
      dataState.add("此题未做");
    }
    getQuestionResult();
  }

  getQuestionResult() async {
    var results = await getAnswerQuestionDetail();
    setState(() {
      for (var result in results) {
        print(result);
        int QType = result["type"];
        double score = result["score"];
        int time = result["answer_timedelta"];
        if (specialQType.contains(QType)) {
            // 未做状态
            if(score == -1 && time == 0) {
              dataState[QType] = "此题未做";
            }
            // 已做等待医生评分
            else if (score == -1 && time > 0) {
              dataState[QType] = "已做等待医生评分";
            } else {
              // 评分完成
              dataState[QType] = score.toString();
            }
        } else {
            if(score == -1) {
              dataState[QType] = "此题未做";
            } else {
              // 评分完成
              dataState[QType] = score.toString();
            }
        }
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
        // Text("操作", textAlign: TextAlign.center, style: titleStyle),
      ])
    ];
    int i = 0;
    for (var row in dataState) {
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
        child: Text(row,
            textAlign: TextAlign.center, style: contentStyle),
      ));

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
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text("答题详情"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, AnswerPage.routerName, (route) => false),
            ),
      ),
      body: dataReady ? buildMainWidget() : null,
    ), onWillPop: () => showExitDialog(context),);
  }
}