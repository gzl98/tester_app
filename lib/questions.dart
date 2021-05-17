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

//COT
final Map<String, String> questionMemoryMatrix = {
  "questionRules": "屏幕上会出现一个图案，快速记住方块出现的位置，然后一个一个地找出它们。",
  "nextPageRouter": MemoryMatrixPage.routerName,
};
//WMS数字广度顺序
final Map<String, String> questionNumberReasoning = {
  "questionRules": "观察几个数字，推理出它们之间的变化规律，找出缺失位置的数字。",
  "nextPageRouter": NumberReasoningPage.routerName,
  "backgroundImagePath1": "images/v3.0/background1.png",
  "backgroundImagePath2": "images/v3.0/background2.jpg",
};

List testList = [
  QuestionInfo.fromMap(questionMemoryMatrix),
  QuestionInfo.fromMap(questionNumberReasoning),
];

//创建每道题是否完成的列表
List<bool> testFinishedList = [];
