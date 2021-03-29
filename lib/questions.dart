import 'package:tester_app/Componets/WMS.dart';
import 'package:tester_app/Fragments/QuestionSecondFragment.dart';
import 'package:tester_app/Pages/COT/COTPage.dart';
import 'package:tester_app/Pages/STROOP/StroopWordPage.dart';
import 'package:tester_app/Pages/WMS/WMSDigitalPage.dart';
import 'package:tester_app/Pages/WMS/WMSSpacePage.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';

//Symbol
final Map<String, String> questionSymbol = {
  "questionAbility": "加工速度",
  "questionTitle": "符号检索",
  "questionNavContent": "判断右边是否出现与左边完全一致的图形。",
  "questionNavPurpose": "主要评估大脑的视觉加工速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的视觉搜索和反应速度有显著提高。",
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
  "questionTitle": "译码测验",
  "questionNavContent": "尽可能多地写出每个符号对应的数字。",
  "questionNavPurpose": "主要评估大脑的知觉加工速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的视觉编码和反应速度有显著提高。",
  "questionName": "译码测验",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionPurpose": "这项测验主要评估您的视觉编码和反应速度，请在两分钟内尽可能多地写出每个符号对应的数字。",
  "questionNotes": null,
  "questionRules": "屏幕中的符号图片会随机出现，请判断每个符号对应的数字",
  "questionRuleNotes": "请在正式开始后快速答题",
  "questionRules2": null,
  "questionRuleNotes2": null,
};
//COT
final Map<String, String> questionCOT = {
  "questionAbility": "注意力检测",
  "questionTitle": "快速判断",
  "questionNavContent": "对你记住的图形迅速做出反应。",
  "questionNavPurpose": "主要评估反应速度和持续注意。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的反应速度和持续注意有显著提高。",
  "questionName": "持续操作测试",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  "questionPurpose":
      "这是一项检测持续注意力的测验。屏幕上会先出现一个图形您要记住它，之后屏幕中央会连续出现一系列的图形，每当出现您记住的图形时，请尽可能快地按下屏幕中的按钮。",
  "questionNotes": "总共约2分钟，您需要尽快、准确地对每个图形做出判断。",
  "questionRules": "2",
  "questionRuleNotes": "",
  "nextPageRouter": COTPage.routerName,
  "questionRules2": null,
  "questionRuleNotes2": null,
};
//WMS数字广度顺序
final Map<String, String> questionWMSDigital = {
  //导航页面
  "questionAbility": "言语工作记忆",
  "questionTitle": "数字正背",
  "questionNavContent": "按顺序记住屏幕中出现的一连串数字。",
  "questionNavPurpose": "主要评估短时言语记忆水平。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的短时记忆能力有显著提高。",
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
//WMS数字广度顺序
final Map<String, String> questionWMSDigitalReverse = {
  //导航页面
  "questionAbility": "言语工作记忆",
  "questionTitle": "数字倒背",
  "questionNavContent": "按倒序记住屏幕中出现的一连串数字。",
  "questionNavPurpose": "主要评估短时言语工作记忆水平。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的工作记忆能力有显著提高。",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  //第一个页面
  "questionName": "数 字 倒 背",
  "questionPurpose": "这项测验主要评估您的工作记忆能力，记住的数字越多，记忆能力越强",
  //第二个页面
  "questionRules": "屏幕上会连续出现一串数字，但每次只出现一个\n请按顺序记住出现的每一个数字",
  "nextPageRouter2": QuestionSecondFragment.routerName,
  //第三个页面
  "questionRules2": "请按照相反的顺序，点击右下角的小键盘写出您刚看到的数字",
  "questionRuleNotes2": "请您按照与数字出现的次序相反的顺序依次点击数字键盘",
  "nextPageRouter3": WMSDigitalPage.routerName,
  //WMS页面特殊变量
  "reverse": "true",
};
//WMS空间广度顺序
final Map<String, String> questionWMSSpace = {
  //导航页面
  "questionAbility": "视觉记忆",
  "questionTitle": "空间广度",
  "questionNavContent": "记住方块闪烁的先后次序。",
  "questionNavPurpose": "主要评估短时空间记忆水平。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的短时空间记忆水平有显著提高。",
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
  "questionTitle": "空间广度倒背",
  "questionNavContent": "该评估包含熟悉操作，连续作对3次熟悉操作，才可以进入测查阶段。",
  "questionNavPurpose": "主要评估短时空间记忆水平。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的短时空间记忆水平有显著提高。",
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
  "questionTitle": "Stroop词语",
  "questionNavContent": "分辨出现的字和听到的声音一致的情况。",
  "questionNavPurpose": "主要评估言语反应能力和速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的言语反应能力和速度有显著提高。",
  "questionImgPath": "images/v2.0/testPicture.jpg",
  //第一个页面
  "questionName": "Stroop词语",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序。",
  //第二个页面
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照刚才的顺序",
  "questionRuleNotes": "请在闪烁停止后再按照顺",
  "nextPageRouter2": StroopPage.routerName,
};
//Stroop色词
final Map<String, String> questionStroopColorWord = {
  "questionAbility": "执行抑制",
  "questionTitle": "Stroop色词",
  "questionNavContent": "分辨出现的字的意思和听到的声音一致的情况。",
  "questionNavPurpose": "主要评估言语反应能力和速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的言语反应能力和速度有显著提高。",
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
  "questionTitle": "Stroop词色",
  "questionNavContent": "分辨文字的颜色和播放的声音一致的情况。",
  "questionNavPurpose": "主要评估执行抑制能力和速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的执行抑制能力和速度有显著提高。",
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
  QuestionInfo.fromMap(questionSymbol),
  QuestionInfo.fromMap(questionCharacter),
  QuestionInfo.fromMap(questionCOT),
  QuestionInfo.fromMap(questionWMSDigital),
  QuestionInfo.fromMap(questionWMSDigitalReverse),
  QuestionInfo.fromMap(questionWMSSpace),
  QuestionInfo.fromMap(questionWMSSpaceReverse),
  QuestionInfo.fromMap(questionStroop),
  QuestionInfo.fromMap(questionStroopColorWord),
  QuestionInfo.fromMap(questionStroopWordColor),
];

void initFragmentWidget() {
  initWMSWidget();
}

//初始化WMS页面的控件
void initWMSWidget() {
  //WMSDigital
  QuestionInfo questionWMSDigital = testList[questionIdWMSDigital - 1];
  questionWMSDigital.questionShowWidget =
      buildWMSDigitalFirstFragmentShowWidget();
  questionWMSDigital.questionRulesWidget =
      buildWMSDigitalSecondFragmentShowWidget();
  questionWMSDigital.questionRules2Widget =
      buildWMSDigitalThirdFragmentShowWidget();

  //WMSDigitalReverse
  QuestionInfo questionWMSDigitalReverse =
      testList[questionIdWMSDigitalReverse - 1];
  questionWMSDigitalReverse.questionShowWidget =
      buildWMSDigitalFirstFragmentShowWidget();
  questionWMSDigitalReverse.questionRulesWidget =
      buildWMSDigitalSecondFragmentShowWidget();
  questionWMSDigitalReverse.questionRules2Widget =
      buildWMSDigitalThirdFragmentShowWidget();

  //WMSSpace
  QuestionInfo questionWMSSpace = testList[questionIdWMSSpace - 1];
  questionWMSSpace.questionShowWidget = buildWMSSpaceFirstFragmentShowWidget();
  questionWMSSpace.questionRulesWidget =
      buildWMSSpaceSecondFragmentShowWidget();

  //WMSSpaceReverse
  QuestionInfo questionWMSSpaceReverse =
      testList[questionIdWMSSpaceReverse - 1];
  questionWMSSpaceReverse.questionShowWidget =
      buildWMSSpaceFirstFragmentShowWidget();
  questionWMSSpaceReverse.questionRulesWidget =
      buildWMSSpaceSecondFragmentShowWidget();
}
