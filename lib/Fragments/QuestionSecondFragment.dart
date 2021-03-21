import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/Fragments/QuestionInfo.dart';
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
        onPressed: () {},
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
    questionInfo = ModalRoute.of(context).settings.arguments;
    print("questionName:" + questionInfo.questionName);
    return Scaffold(
      body: Container(
        width: maxWidth,
        height: maxHeight,
        color: Color.fromARGB(255, 239, 239, 239),
        child: Column(
          children: [
            //上部布局
            Container(
              color: Colors.amber,
              width: maxWidth,
              height: setHeight(1100),
            ),
            Container(
              width: maxWidth,
              height: setHeight(300),
              child: Column(
                children: [
                  Text(
                    questionInfo.questionRules,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: setHeight(3.5),
                      fontSize: setSp(40),
                      color: Color.fromARGB(255, 100, 100, 100),
                    ),
                  ),
                  questionInfo.questionRuleNotes == null
                      ? Container()
                      : Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: "注意：",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: questionInfo.questionRuleNotes),
                          ]),
                          style: TextStyle(
                            height: setHeight(3.5),
                            fontSize: setSp(40),
                            color: Color.fromARGB(255, 253, 121, 111),
                          ),
                        ),
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
