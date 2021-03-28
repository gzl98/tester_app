import 'package:tester_app/Fragments/QuestionSecondFragment.dart';
import 'package:tester_app/Pages/STROOP/StroopWordPage.dart';
import 'package:tester_app/Pages/WMS/WMSDigitalPage.dart';
import 'package:tester_app/Pages/WMS/WMSSpacePage.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';

List testList = [
  QuestionInfo.fromMap(questionSymbol),
  QuestionInfo.fromMap(questionCharacter),
  QuestionInfo.fromMap(questionWMSDigital),
  QuestionInfo.fromMap(questionWMSSpace),
  QuestionInfo.fromMap(questionWMSSpaceReverse),
  QuestionInfo.fromMap(questionStroop),
  QuestionInfo.fromMap(questionStroopColorWord),
  QuestionInfo.fromMap(questionStroopWordColor),
];

//WMS数字广度顺序
final Map<String, String> questionWMSDigital = {
  //导航页面
  "questionAbility": "言语工作记忆",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  //第一个页面
  "questionName": "数 字 正 背",
  "questionPurpose": "这项测验主要评估您的短时记忆能力，记住的数字越多，记忆力越好",
  //第二个页面
  "questionRules": "屏幕上会连续出现一串数字，但每次只出现一个\n请按顺序记住出现的每一个数字",
  "nextPageRouter2": QuestionSecondFragment.routerName,
  //第三个页面
  "questionRules2": "请点击右下角的小键盘写出您刚看到的数字",
  "questionRuleNotes2": "请您按照刚才的顺序依次点击数字键盘",
  "nextPageRouter3": WMSDigitalPage.routerName,
  //WMS页面特殊变量
  "reverse": "false",
};
//WMS空间广度顺序
final Map<String, String> questionWMSSpace = {
  //导航页面
  "questionAbility": "视觉记忆",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  //第一个页面
  "questionName": "空 间 广 度",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序，记得越多，记忆力越好。",
  //第二个页面
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照刚才的顺序依次点击对应的方块",
  "questionRuleNotes": "请在闪烁停止后再按照顺序依次点击",
  "nextPageRouter2": WMSSpacePage.routerName,
  //WMS页面特殊变量
  "reverse": "false",
};
//WMS空间广度逆序
final Map<String, String> questionWMSSpaceReverse = {
  //导航页面
  "questionAbility": "视觉记忆",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  //第一个页面
  "questionName": "空 间 广 度 倒 背",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序，记得越多，记忆力越好。",
  //第二个页面
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照与刚才相反的顺序依次点击对应的方块",
  "questionRuleNotes": "请在闪烁停止后再按照相反的顺序依次点击",
  "nextPageRouter2": WMSSpacePage.routerName,
  //WMS页面特殊变量
  "reverse": "true",
};
//Stroop词语
final Map<String, String> questionStroop = {
  //导航页面
  "questionAbility": "执行抑制",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  //第一个页面
  "questionName": "Stroop词语",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序。",
  //第二个页面
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照刚才的顺序",
  "questionRuleNotes": "请在闪烁停止后再按照顺",
  "nextPageRouter2": StroopPage.routerName,
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
