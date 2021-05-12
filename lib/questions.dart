import 'package:flutter/cupertino.dart';
import 'package:tester_app/Componets/Stroop.dart';
import 'package:tester_app/Componets/WMS.dart';
import 'package:tester_app/Fragments/QuestionSecondFragment.dart';
import 'package:tester_app/Pages/COT/COTPage.dart';
import 'package:tester_app/Pages/STROOP/StroopColorWordPage.dart';
import 'package:tester_app/Pages/STROOP/StroopWordColorPage.dart';
import 'package:tester_app/Pages/STROOP/StroopWordPage.dart';
import 'package:tester_app/Pages/WMS/WMSDigitalPage.dart';
import 'package:tester_app/Pages/WMS/WMSSpacePage.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'Pages/NewCharacter/NewCharacterMainPage.dart';
import 'Pages/NewTMT/TMTSpacePage.dart';
import 'Pages/Symbol/SymbolMainPage.dart';

//TMT
final Map<String, String> questionTMTSpace = {
  //导航页面
  "questionAbility": "加工速度",
  "questionTitle": "顺序连线",
  "questionNavContent": "从小到大顺序找出25个数字。",
  "questionNavPurpose": "主要评估大脑的加工速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的反应速度有显著提高。",
  "questionImgPath": "images/v2.0/TMTSpace.png",
  //第一个页面
  "questionName": "顺 序 连 线",
  "questionPurpose":
      "这项测验主要评估您的反应速度，请按照从小到大的顺序尽可能快地点击屏幕上的25个数字。",
  "questionNotes": "请您尽可能快,尽可能准确地完成这个测验,您用时越短,成绩越好。",
  "soundPath1": "sounds/TMTSpace1.wav",
  //第二个页面
  "questionRules": "请按照从小到大的顺序依次点击每个数字",
  "questionRuleNotes": null,
  "nextPageRouter2": TMTSpacePage.routerName,
  "soundPath2": "sounds/TMTSpace2.wav",
  //WMS页面特殊变量
  "reverse": "false",
};
//Symbol
final Map<String, String> questionSymbol = {
  "questionAbility": "加工速度",
  "questionTitle": "符号检索",
  "questionNavContent": "判断右边是否出现与左边完全一致的图形。",
  "questionNavPurpose": "主要评估大脑的视觉加工速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的视觉搜索和反应速度有显著提高。",
  "questionName": "符号检索",
  "questionImgPath": "images/v2.0/symbolmainback.png",
  "questionPurpose": "这项测验主要评估您的视觉搜索和反应速度，请在两分钟内尽可能多、尽可能正确地回答每个测试题。",
  "questionNotes": null,
  "questionRules": "屏幕中的符号图片会随机出现，请判断左边的两张图片是否存在于右边的五张图片中",
  "questionRuleNotes": "请在正式开始后快速答题",
  "soundPath1": "sounds/Symbol1.wav",
  //第二个页面
  "nextPageRouter2": SymbolMainPage.routerName,
  "questionRules2": null,
  "questionRuleNotes2": null,
  "soundPath2": "sounds/Symbol2.wav",
};
//Character
final Map<String, String> questionCharacter = {
  "questionAbility": "加工速度",
  "questionTitle": "译码测验",
  "questionNavContent": "尽可能多地写出每个符号对应的数字。",
  "questionNavPurpose": "主要评估大脑的知觉加工速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的视觉编码和反应速度有显著提高。",
  "questionName": "译码测验",
  "questionImgPath": "images/v2.0/charactermainback.png",
  "questionPurpose": "这项测验主要评估您的视觉编码和反应速度，请在两分钟内尽可能多地写出每个符号对应的数字。",
  "questionNotes": null,
  "questionRules": "屏幕中的符号图片会随机出现，请判断每个符号对应的数字",
  "questionRuleNotes": "请在正式开始后快速答题",
  "soundPath1": "sounds/Character1.wav",
  //第二个页面
  "nextPageRouter2": CharacterMainPage.routerName,
  "questionRules2": null,
  "questionRuleNotes2": null,
  "soundPath2": "sounds/Character2.wav",
};
//COT
final Map<String, String> questionCOT = {
  "questionAbility": "注意力检测",
  "questionTitle": "快速判断",
  "questionNavContent": "对你记住的图形迅速做出反应。",
  "questionNavPurpose": "主要评估反应速度和持续注意。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的反应速度和持续注意有显著提高。",
  "questionName": "持续操作测试",
  "questionImgPath": "images/v2.0/COT/COT.png",
  "questionPurpose":
      "这是一项检测持续注意力的测验。屏幕上会先出现一个图形您要记住它，之后屏幕中央会连续出现一系列的图形，每当出现您记住的图形时，请尽可能快地按下屏幕中的按钮。",
  "questionNotes": "总共约2分钟，您需要尽快、准确地对每个图形做出判断。",
  "questionRules": "2",
  "questionRuleNotes": "",
  "nextPageRouter": COTPage.routerName,
  "soundPath1": "sounds/COT1.wav",
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
  "questionImgPath": "images/v2.0/WMS/WMSDigital.png",
  //第一个页面
  "questionName": "数 字 正 背",
  "questionPurpose": "这项测验主要评估您的短时记忆能力，记住的数字越多，记忆力越好",
  "soundPath1": "sounds/WMSDigital1.wav",
  //第二个页面
  "questionRules": "屏幕上会连续出现一串数字，但每次只出现一个\n请按顺序记住出现的每一个数字",
  "nextPageRouter2": QuestionSecondFragment.routerName,
  "soundPath2": "sounds/WMSDigital2.wav",
  //第三个页面
  "questionRules2": "请点击右下角的小键盘写出您刚看到的数字",
  "questionRuleNotes2": "请您按照刚才的顺序依次点击数字键盘",
  "nextPageRouter3": WMSDigitalPage.routerName,
  "soundPath3": "sounds/WMSDigital3.wav",
  //WMS页面特殊变量
  "reverse": "false",
};
//WMS数字广度倒序
final Map<String, String> questionWMSDigitalReverse = {
  //导航页面
  "questionAbility": "言语工作记忆",
  "questionTitle": "数字倒背",
  "questionNavContent": "按倒序记住屏幕中出现的一连串数字。",
  "questionNavPurpose": "主要评估短时言语工作记忆水平。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的工作记忆能力有显著提高。",
  "questionImgPath": "images/v2.0/WMS/WMSDigitalReverse.png",
  //第一个页面
  "questionName": "数 字 倒 背",
  "questionPurpose": "这项测验主要评估您的工作记忆能力，记住的数字越多，记忆能力越强",
  "soundPath1": "sounds/WMSDigitalReverse1.wav",
  //第二个页面
  "questionRules": "屏幕上会连续出现一串数字，但每次只出现一个\n请按顺序记住出现的每一个数字",
  "nextPageRouter2": QuestionSecondFragment.routerName,
  "soundPath2": "sounds/WMSDigitalReverse2.wav",
  //第三个页面
  "questionRules2": "请按照相反的顺序，点击右下角的小键盘写出您刚看到的数字",
  "questionRuleNotes2": "请您按照与数字出现的次序相反的顺序依次点击数字键盘",
  "nextPageRouter3": WMSDigitalPage.routerName,
  "soundPath3": "sounds/WMSDigitalReverse3.wav",
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
  "questionImgPath": "images/v2.0/WMS/WMSSpace.png",
  //第一个页面
  "questionName": "空 间 广 度",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序，记得越多，记忆力越好。",
  "soundPath1": "sounds/WMSSpace1.wav",
  //第二个页面
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照刚才的顺序依次点击对应的方块",
  "questionRuleNotes": "请在闪烁停止后再按照顺序依次点击",
  "nextPageRouter2": WMSSpacePage.routerName,
  "soundPath2": "sounds/WMSSpace2.wav",
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
  "questionImgPath": "images/v2.0/WMS/WMSSpaceReverse.png",
  //第一个页面
  "questionName": "空 间 广 度 倒 背",
  "questionPurpose": "这项测验主要评估您的空间记忆能力，请记住方块闪烁的先后次序，记得越多，记忆力越好。",
  "soundPath1": "sounds/WMSSpaceReverse1.wav",
  //第二个页面
  "questionRules": "屏幕中的方块会按照一定的顺序依次闪烁，停止后请按照与刚才相反的顺序依次点击对应的方块",
  "questionRuleNotes": "请在闪烁停止后再按照相反的顺序依次点击",
  "nextPageRouter2": WMSSpacePage.routerName,
  "soundPath2": "sounds/WMSSpaceReverse2.wav",
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
  "questionImgPath": "images/v2.0/STROOP/stroopWord.png",
  //第一个页面
  "questionName": "Stroop词语",
  "questionPurpose": "这项测验主要评估您的言语反应速度,屏幕上会顺序出现一个个关于颜色的字,每个字出现时您都会同时听到一个声音，当出现的字和听到的声音一致的时候,请尽快按下空格键。",
  "questionNotes": "当听到的字和看到的字一致时,您需要尽快按下空格键如果不一致,请不要做任何反应，集中注意力等待下一个字的出现。",
  "soundPath1": "sounds/Stroop1.wav",
  //第二个页面
  "questionRules": "当屏幕上出现的字和您听到的字一致时请尽快按下空格键",
  "questionRuleNotes": "只有当看到的和听到的一致时，您才需要按键，不一致时无需做任何反应。",
  "nextPageRouter2": StroopPage.routerName,
  "soundPath2": "sounds/Stroop2.wav",
};
//Stroop色词
final Map<String, String> questionStroopColorWord = {
  "questionAbility": "执行抑制",
  "questionTitle": "Stroop色词",
  "questionNavContent": "分辨出现的字的意思和听到的声音一致的情况。",
  "questionNavPurpose": "主要评估言语反应能力和速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的言语反应能力和速度有显著提高。",
  "questionName": "Stroop色词",
  "questionImgPath": "images/v2.0/STROOP/stroopColorWord.png",
  "questionPurpose": "这项测验主要评估您的言语反应速度,屏幕上会顺序出现一个个关于颜色的字,每个字出现时您都会同时听到一个声音，当出现的字的意思和听到的声音一致的时候,请尽快按下空格键。",
  "questionNotes": "当听到的字的意思和看到的字一致时，您需要尽快按下空格键，如果不一致,请不要做任何反应，集中注意力等待下一个字的出现",
  "soundPath1": "sounds/StroopColorWord1.wav",
  "questionRules": "当屏幕上出现的字的意思和您听到的字一致时请尽快按下空格。",
  "questionRuleNotes": "只有当看到的和听到的一致时，您才需要按键，不一致时无需做任何反应。",
  "questionRules2": null,
  "questionRuleNotes2": null,
  "nextPageRouter2": StroopColorWordPage.routerName,
  "soundPath2": "sounds/StroopColorWord2.wav",
};
//Stroop词色
final Map<String, String> questionStroopWordColor = {
  "questionAbility": "执行抑制",
  "questionTitle": "Stroop词色",
  "questionNavContent": "分辨文字的颜色和播放的声音一致的情况。",
  "questionNavPurpose": "主要评估执行抑制能力和速度。",
  "benefitExample": "评估后，治疗师会根据您的评估结果，实施个性化治疗，让您的执行抑制能力和速度有显著提高。",
  "questionName": "Stroop词色",
  "questionImgPath": "images/v2.0/STROOP/stroopWordColor.png",
  "questionPurpose": "屏幕上不断出现文字同时会播放声音,当文字的颜色和播放的声音一致时,按空格键做出反应。",
  "questionNotes": "当听到的字的意思和看到的字的颜色一致时，您需要尽快按下空格键，如果不一致,请不要做任何反应，集中注意力等待下一个字的出现。",
  "soundPath1": "sounds/StroopWordColor1.wav",
  "questionRules": "当屏幕上出现的字的颜色和您听到的字的意思一致时请尽快按下空格键。",
  "questionRuleNotes": "请注意字的颜色,忽略字的意思。只有当看到的字的颜色和听到的一致时，您才需要按键，不一致时无需做任何反应",
  "questionRules2": null,
  "questionRuleNotes2": null,
  "nextPageRouter2": StroopWordColorPage.routerName,
  "soundPath2": "sounds/StroopWordColor2.wav",
};

List testList = [
  QuestionInfo.fromMap(questionTMTSpace),
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
//创建每道题是否完成的列表
List<bool> testFinishedList = [];

void initFragmentWidget() {
  initTMTWidget();
  initSymbolCharacterWidget();
  initWMSWidget();
  initStroopWidget();
}

//初始化TMT页面的控件
void initTMTWidget() {
  //TMT
  QuestionInfo questionTMT = testList[questionIdTMT];
  questionTMT.questionShowWidget = buildTMTFirstFragmentShowWidget();
  questionTMT.questionRulesWidget = buildTMTSecondFragmentShowWidget();
}

//初始化Symbol和Character界面的控件
void initSymbolCharacterWidget() {
  //Symbol
  QuestionInfo questionSymbol = testList[questionIdSymbol];
  questionSymbol.questionShowWidget = buildSymbolFirstFragmentShowWidget();
  questionSymbol.questionRulesWidget = buildSymbolSecondFragmentShowWidget();

  //Character
  QuestionInfo questionCharacter = testList[questionIdNewCharacter];
  questionCharacter.questionShowWidget =
      buildCharacterFirstFragmentShowWidget();
  questionCharacter.questionRulesWidget =
      buildCharacterSecondFragmentShowWidget();
}

//初始化WMS页面的控件
void initWMSWidget() {
  //WMSDigital
  QuestionInfo questionWMSDigital = testList[questionIdWMSDigital];
  questionWMSDigital.questionShowWidget =
      buildWMSDigitalFirstFragmentShowWidget();
  questionWMSDigital.questionRulesWidget =
      buildWMSDigitalSecondFragmentShowWidget();
  questionWMSDigital.questionRules2Widget =
      buildWMSDigitalThirdFragmentShowWidget();

  //WMSDigitalReverse
  QuestionInfo questionWMSDigitalReverse =
      testList[questionIdWMSDigitalReverse];
  questionWMSDigitalReverse.questionShowWidget =
      buildWMSDigitalFirstFragmentShowWidget();
  questionWMSDigitalReverse.questionRulesWidget =
      buildWMSDigitalSecondFragmentShowWidget();
  questionWMSDigitalReverse.questionRules2Widget =
      buildWMSDigitalThirdFragmentShowWidget();

  //WMSSpace
  QuestionInfo questionWMSSpace = testList[questionIdWMSSpace];
  questionWMSSpace.questionShowWidget = buildWMSSpaceFirstFragmentShowWidget();
  questionWMSSpace.questionRulesWidget =
      buildWMSSpaceSecondFragmentShowWidget();

  //WMSSpaceReverse
  QuestionInfo questionWMSSpaceReverse = testList[questionIdWMSSpaceReverse];
  questionWMSSpaceReverse.questionShowWidget =
      buildWMSSpaceFirstFragmentShowWidget();
  questionWMSSpaceReverse.questionRulesWidget =
      buildWMSSpaceSecondFragmentShowWidget();
}

void initStroopWidget() {
  //StroopWord
  QuestionInfo questionStroopWord = testList[stroopWordID];
  questionStroopWord.questionShowWidget = buildWordCard("绿", Color(0xFF000000));
  questionStroopWord.questionRulesWidget =
      buildSecondWordCard("绿", Color(0xFF000000));

  //StroopColorWord
  QuestionInfo questionStroopColorWord = testList[stroopColorWordID];
  questionStroopColorWord.questionShowWidget =
      buildWordCard("绿", Color(0xFF007CFF));
  questionStroopColorWord.questionRulesWidget =
      buildSecondWordCard("绿", Color(0xFF007CFF));

  //StroopWord
  QuestionInfo questionStroopWordColor = testList[stroopWordColorID];
  questionStroopWordColor.questionShowWidget =
      buildWordCard("绿", Color(0xFFE30505));
  questionStroopWordColor.questionRulesWidget =
      buildSecondWordCard("绿", Color(0xFFE30707));
}
