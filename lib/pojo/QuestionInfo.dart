import 'package:flutter/cupertino.dart';

class QuestionInfo {
  //导航页面
  String questionAbility = ""; //测查的能力
  String questionTitle = ""; //题目名称
  String questionNavContent = ""; //测查内容
  String questionNavPurpose = ""; //测查目的
  String benefitExample = ""; //收益举例
  String questionImgPath; //中央显示图片

  //第一个页面
  String questionName; //题目名称
  String questionPurpose; //题目目的
  Widget questionShowWidget; //题目界面展示Widget
  String questionNotes; //注意事项
  String nextPageRouter; //下一个页面的路由

  //第二个页面
  String questionRules; //题目规则
  String questionRuleNotes; //规则注意事项
  Widget questionRulesWidget; //规则展示Widget
  String nextPageRouter2; //下一个页面的路由

  //第三个页面
  String questionRules2; //题目规则2
  String questionRuleNotes2; //规则注意事项2
  Widget questionRules2Widget; //规则展示Widget2
  String nextPageRouter3; //下一个页面的路由

  //WMS页面特殊变量
  bool reverse;

  QuestionInfo.fromMap(Map<String, String> data)
      : questionAbility = data["questionAbility"],
        questionTitle = data["questionTitle"],
        questionNavContent = data["questionNavContent"],
        questionNavPurpose = data["questionNavPurpose"],
        benefitExample = data["benefitExample"],
        questionImgPath = data["questionImgPath"],
        //第一个页面
        questionName = data["questionName"],
        questionPurpose = data["questionPurpose"],
        questionNotes = data["questionNotes"],
        nextPageRouter = data["nextPageRouter"],
        //第二个页面
        questionRules = data["questionRules"],
        questionRuleNotes = data["questionRuleNotes"],
        nextPageRouter2 = data["nextPageRouter2"],
        //第三个页面
        questionRules2 = data["questionRules2"],
        questionRuleNotes2 = data["questionRuleNotes2"],
        nextPageRouter3 = data["nextPageRouter3"],
        //WMS页面特殊变量
        reverse = data["reverse"] == "true";
}
