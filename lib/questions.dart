import 'package:tester_app/Pages/COT/COTPage.dart';
import 'package:tester_app/Pages/WMS/WMSPage.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';

//WMS顺序
final Map<String, String> questionWMS = {
  "questionAbility": "工作记忆",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionName": "空 间 广 度",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序，记得越多，记忆力越好。",
  "questionNotes": null,
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照刚才的顺序依次点击对应的方块",
  "questionRuleNotes": "请在闪烁停止后再按照顺序依次点击",
  "questionRules2": null,
  "questionRuleNotes2": null,
  "nextPageRouter2": WMSPage.routerName,
  "reverse": "false",
};
//WMS逆序
final Map<String, String> questionWMSReverse = {
  "questionAbility": "工作记忆",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionName": "空 间 广 度 倒 背",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序，记得越多，记忆力越好。",
  "questionNotes": null,
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照与刚才相反的顺序依次点击对应的方块",
  "questionRuleNotes": "请在闪烁停止后再按照相反的顺序依次点击",
  "questionRules2": null,
  "questionRuleNotes2": null,
  "nextPageRouter2": WMSPage.routerName,
  "reverse": "true",
};
//COT
final Map<String, String> questionCOT = {
  "questionAbility": "注意力检测",
  "questionName": "持续操作测试",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionPurpose": "这是一项检测持续注意力的测验。屏幕上会先出现一个图形您要记住它，之后屏幕中央会连续出现一系列的图形，每当出现您记住的图形时，请尽可能地按下屏幕中的按钮。",
  "questionNotes": "总共约2分钟，您需要尽快、准确地对每个图形做出判断。",
  "questionRules": "2",
  "questionRuleNotes": "",
  "nextPageRouter": COTPage.routerName,
  "questionRules2": null,
  "questionRuleNotes2": null,
};
//Stroop词语
final Map<String, String> questionStroop = {
  "questionAbility": "执行抑制",
  "questionName": "Stroop词语",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序。",
  "questionNotes": null,
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照刚才的顺序",
  "questionRuleNotes": "请在闪烁停止后再按照顺",
  "questionRules2": null,
  "questionRuleNotes2": null,
};
//Symbol
final Map<String, String> questionSymbol = {
  "questionAbility": "加工速度",
  "questionName": "符号检索",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionPurpose": "这项测验主要评估您的视觉搜索和反应速度，请在两分钟内尽可能多、尽可能正确地回答每个测试题。",
  "questionNotes": null,
  "questionRules": "屏幕中的符号图片会随机出现，请判断左边的两张图片是否存在于右边的五张图片中",
  "questionRuleNotes": "请在正式开始后快速答题",
  "questionRules2": null,
  "questionRuleNotes2": null,
};
//Character
final Map<String, String> questionCharacter = {
  "questionAbility": "加工速度",
  "questionName": "译码测验",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionPurpose": "这项测验主要评估您的视觉编码和反应速度，请在两分钟内尽可能多地写出每个符号对应的数字。",
  "questionNotes": null,
  "questionRules": "屏幕中的符号图片会随机出现，请判断每个符号对应的数字",
  "questionRuleNotes": "请在正式开始后快速答题",
  "questionRules2": null,
  "questionRuleNotes2": null,
};
//Stroop色词
final Map<String, String> questionStroopColorWord = {
  "questionAbility": "执行抑制",
  "questionName": "Stroop色词",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序。",
  "questionNotes": null,
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照刚才的顺序",
  "questionRuleNotes": "请在闪烁停止后再按照顺",
  "questionRules2": null,
  "questionRuleNotes2": null,
};
//Stroop词色
final Map<String, String> questionStroopWordColor = {
  "questionAbility": "执行抑制",
  "questionName": "Stroop词色",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序。",
  "questionNotes": null,
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照刚才的顺序",
  "questionRuleNotes": "请在闪烁停止后再按照顺",
  "questionRules2": null,
  "questionRuleNotes2": null,
};
List testList = [
  QuestionInfo.fromMap(questionWMS),
  QuestionInfo.fromMap(questionWMSReverse),
  QuestionInfo.fromMap(questionCOT),
  QuestionInfo.fromMap(questionStroop),
  QuestionInfo.fromMap(questionSymbol),
  QuestionInfo.fromMap(questionCharacter),
  QuestionInfo.fromMap(questionStroopColorWord),
  QuestionInfo.fromMap(questionStroopWordColor),
];
