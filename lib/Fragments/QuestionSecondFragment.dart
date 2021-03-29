import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/Utils/Utils.dart';

class QuestionSecondFragment extends StatefulWidget {
  static const routerName = "/QuestionSecond";

  @override
  State<StatefulWidget> createState() {
    return _QuestionSecondFragmentState();
  }
}

class _QuestionSecondFragmentState extends State<QuestionSecondFragment> {
  QuestionInfo questionInfo;
  int currentPage;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  Widget buildNextStepButton(context) {
    return Container(
      width: setWidth(450),
      height: setHeight(100),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(setWidth(2)),
        ),
        onPressed: () {
          if (currentPage == 2) {
            Navigator.pushNamed(context, questionInfo.nextPageRouter2,
                arguments: {"questionInfo": questionInfo, "currentPage": 3});
          } else if (currentPage == 3) {
            Navigator.pushNamed(context, questionInfo.nextPageRouter3,
                arguments: {"questionInfo": questionInfo});
          }
        },
        child: Text(
          "下一步",
          style: TextStyle(fontSize: setSp(55), fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xff418ffc), Color(0xff174cfc)],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = Map.from(ModalRoute.of(context).settings.arguments);
    questionInfo = arguments["questionInfo"];
    currentPage = arguments["currentPage"];
    return Scaffold(
      body: Container(
        width: maxWidth,
        height: maxHeight,
        color: Color.fromARGB(255, 239, 239, 239),
        child: Column(
          children: [
            //上部布局
            Container(
              alignment: Alignment.center,
              // color: Color.fromARGB(255, 227, 230, 229),
              width: maxWidth,
              // height: setHeight(1100),
              child: () {
                if (currentPage == 2) {
                  if (questionInfo.questionRulesWidget != null)
                    return questionInfo.questionRulesWidget;
                }
                if (currentPage == 3) {
                  if (questionInfo.questionRules2Widget != null)
                    return questionInfo.questionRules2Widget;
                }
              }(),
            ),
            Container(
              width: maxWidth,
              height: setHeight(300),
              child: Column(
                children: [
                  Text(
                    currentPage == 2
                        ? questionInfo.questionRules
                        : questionInfo.questionRules2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: setHeight(3.5),
                      fontSize: setSp(44),
                      color: Color.fromARGB(255, 100, 100, 100),
                    ),
                  ),
                  currentPage == 2 && questionInfo.questionRuleNotes != null
                      ? Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: "注意：",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: questionInfo.questionRuleNotes),
                          ]),
                          style: TextStyle(
                            height: setHeight(3.5),
                            fontSize: setSp(44),
                            color: Color.fromARGB(255, 253, 121, 111),
                          ),
                        )
                      : Container(),
                  currentPage == 3 && questionInfo.questionRuleNotes2 != null
                      ? Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: "注意：",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: questionInfo.questionRuleNotes2),
                          ]),
                          style: TextStyle(
                            height: setHeight(3.5),
                            fontSize: setSp(44),
                            color: Color.fromARGB(255, 253, 121, 111),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(child: Container()),
            //下一步按钮,height:100
            buildNextStepButton(context),
            SizedBox(height: setHeight(100))
          ],
        ),
      ),
    );
  }
}
