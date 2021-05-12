import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';

class QuestionInfoFragment extends StatelessWidget {
  QuestionInfoFragment({
    this.questionTitle,
    this.questionContent,
    this.remainingTime,
    this.score,
  });

  final String questionTitle;
  final String questionContent;
  final int remainingTime;
  final int score;

  final TextStyle scoreFontStyle = TextStyle(
    fontSize: setSp(60),
    fontWeight: FontWeight.w900,
    color: Color.fromARGB(255, 224, 98, 98),
    shadows: [
      Shadow(
          color: Colors.grey,
          offset: Offset(setWidth(1), setHeight(1)),
          blurRadius: setWidth(5)),
    ],
  );
  final TextStyle questionTitleFontStyle = TextStyle(
      fontSize: setSp(70),
      fontWeight: FontWeight.bold,
      color: Colors.lightBlue,
      shadows: [
        Shadow(
            // color: Color.fromARGB(100, 0, 0, 0),
            color: Colors.grey,
            offset: Offset(setWidth(2), setHeight(2)),
            blurRadius: setWidth(8)),
      ]);
  final TextStyle questionContentFontStyle =
      TextStyle(fontSize: setSp(45), height: setHeight(4));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: setHeight(160),
          child: Center(
            child: Text(
              // "空间广度",
              questionTitle,
              style: questionTitleFontStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: setWidth(33)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "题目规则：",
              style: questionContentFontStyle,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: setWidth(33)),
            child: Text(
              // "\t\t\t\t本题目主要考察空间记忆能力，当测试开始时，您需要记住方块亮起的顺序，之后按照相同或相反的顺序依次点击，点击顺序完全正确得一分，否则不得分，共32组测试，预计用时20分钟。",
              questionContent,
              style: questionContentFontStyle,
            ),
          ),
        ),
        score != null
            ? Container(
                // color: Colors.amber,
                height: setHeight(200),
                child: Center(
                  child: Text(
                    "得分：$score",
                    style: scoreFontStyle,
                  ),
                ),
              )
            : Container(),
        remainingTime != null
            ? Container(
                // color: Colors.amber,
                height: setHeight(160),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "剩余时间：$remainingTime秒",
                    style: TextStyle(
                      color: (remainingTime > 30) ? Colors.black : Colors.red,
                      fontSize: setSp(60),
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                            color: Colors.grey,
                            offset: Offset(setWidth(1), setHeight(1)),
                            blurRadius: setWidth(5)),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
