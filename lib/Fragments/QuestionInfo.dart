import 'package:flutter/cupertino.dart';

class QuestionInfo {
  //第一个页面
  String questionName; //题目名称
  String questionPurpose; //题目目的
  Widget questionShowWidget; //题目界面展示Widget
  String questionNotes; //注意事项

  //第二个页面
  String questionRules; //题目规则
  String questionRuleNotes; //规则注意事项
  Widget questionRulesWidget; //规则展示Widget

  //第三个页面
  String questionRules2; //题目规则2
  String questionRuleNotes2; //规则注意事项2
  Widget questionRules2Widget; //规则展示Widget2

  QuestionInfo(
    this.questionName,
    this.questionPurpose,
    this.questionShowWidget,
    this.questionRules,
    this.questionRulesWidget, {
    this.questionNotes,
    this.questionRuleNotes,
    this.questionRules2,
    this.questionRuleNotes2,
    this.questionRules2Widget,
  });

  QuestionInfo.fromMap(Map<String, String> data)
      : questionName = data["questionName"],
        questionPurpose = data["questionPurpose"],
        questionRules = data["questionRules"],
        questionNotes = data["questionNotes"],
        questionRuleNotes = data["questionRuleNotes"],
        questionRules2 = data["questionRules2"],
        questionRuleNotes2 = data["questionRuleNotes2"];
}
