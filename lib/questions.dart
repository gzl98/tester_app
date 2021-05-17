import 'package:flutter/cupertino.dart';
import 'package:tester_app/Componets/Stroop.dart';
import 'package:tester_app/Componets/WMS.dart';
import 'package:tester_app/Fragments/QuestionSecondFragment.dart';
import 'package:tester_app/Pages/COT/COTPage.dart';
import 'package:tester_app/Pages/NumberReasoning/NumberReasoningPage.dart';
import 'package:tester_app/Pages/STROOP/StroopColorWordPage.dart';
import 'package:tester_app/Pages/STROOP/StroopWordColorPage.dart';
import 'package:tester_app/Pages/STROOP/StroopWordPage.dart';
import 'package:tester_app/Pages/WMS/WMSDigitalPage.dart';
import 'package:tester_app/Pages/WMS/WMSSpacePage.dart';
import 'package:tester_app/config/config.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'Pages/MemoryMatrix/MemoryMatrix.dart';
import 'Pages/NewCharacter/NewCharacterMainPage.dart';
import 'Pages/NewTMT/TMTSpacePage.dart';
import 'Pages/Symbol/SymbolMainPage.dart';

//记忆矩阵
final Map<String, String> questionMemoryMatrix = {
  //导航页面
  "questionAbility": "工作记忆",
  "questionTitle": "记忆矩阵",
  "questionNavContent": "对方格中有色方块位置进行记忆。",
  "questionNavPurpose": "提高视觉记忆和视觉学习能力。",
  "benefitExample": "训练后，您的记忆力，尤其是短期记忆力会提高，能更好的记住您在购物时看到的物品的颜色、形状等细节。",
  "questionPurpose": "通过对方格中有色方块位置进行记忆，可以提高我们的空间和视觉记忆能力，如对物品的摆放位置的记忆比以前更准确，这将有助于我们在短的时间内找到需要的东西。",
  "questionImgPath": "images/v3.0/MemoryMatrix/MemoryMatrix.png",
  //第一个页面
  "backgroundImagePath1": "images/v3.0/MemoryMatrix/MMbackground1.png",
  //第二个页面
  "questionRules": "屏幕上会出现一个图案，快速记住方块出现的位置，然后一个一个地找出它们。",
  "nextPageRouter": MemoryMatrixPage.routerName,
  "backgroundImagePath2": "images/v3.0/MemoryMatrix/MMbackground2.png",
};
//数字推理
final Map<String, String> questionNumberReasoning = {
  //导航页面
  "questionAbility": "解决问题能力",
  "questionTitle": "数字推理",
  "questionNavContent": "找出屏幕中问号处的缺失数字。",
  "questionNavPurpose": "提高推理、计算等抽象思维能力。",
  "benefitExample": "经过训练您的推理能力会改善，如在打扑克时能更好地根据各方的出牌，推测对家或对手的持牌情况。",
  "questionImgPath": "images/v3.0/NumberReasoning/NumberReasoning.png",
  "questionPurpose":
      "通过找出屏幕中问号处的缺失数字，您可以发现这些数字的变化规律，从而提高您的逻辑思维能力，这样您就能更好、更多地发现生活中存在的各种规律，从而找到解决问题的方法.",
  //第一个页面
  "backgroundImagePath1": "images/v3.0/NumberReasoning/NumberReasoningBackground1.png",
  //第二个页面
  "questionRules": "观察几个数字，推理出它们之间的变化规律，找出缺失位置的数字。",
  "nextPageRouter": NumberReasoningPage.routerName,
  "backgroundImagePath2": "images/v3.0/NumberReasoning/NumberReasoningBackground2.jpg",
};

List testList = [
  QuestionInfo.fromMap(questionMemoryMatrix),
  QuestionInfo.fromMap(questionNumberReasoning),
];

//创建每道题是否完成的列表
List<bool> testFinishedList = [];
