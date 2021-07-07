import 'package:tester_app/Pages/FlashLight/FlashLightPage.dart';
import 'package:tester_app/Pages/NumberReasoning/NumberReasoningPage.dart';

import 'package:tester_app/pojo/QuestionInfo.dart';
import 'Pages/MemoryMatrix/MemoryMatrix.dart';

//记忆矩阵
final Map<String, String> questionMemoryMatrix = {
  //导航页面
  "questionAbility": "工作记忆",
  "questionTitle": "记忆矩阵",
  "questionNavContent": "对方格中有色方块位置进行记忆。",
  "questionNavPurpose": "提高视觉记忆和视觉学习能力。",
  "benefitExample": "训练后，您的记忆力，尤其是短期记忆力会提高，能更好的记住您在购物时看到的物品的颜色、形状等细节。",
  "questionPurpose":
      "通过对方格中有色方块位置进行记忆，可以提高我们的空间和视觉记忆能力，如对物品的摆放位置的记忆比以前更准确，这将有助于我们在短的时间内找到需要的东西。",
  "questionImgPath": "images/v3.0/MemoryMatrix/MemoryMatrix.png",
  "nextPageRouter": MemoryMatrixPage.routerName,
  //第一个页面
  "backgroundImagePath1": "images/v3.0/MemoryMatrix/MMbackground1.png",
  //第二个页面
  "questionRules": "屏幕上会出现一个图案，快速记住方块出现的位置，然后一个一个地找出它们。",
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
  "nextPageRouter": NumberReasoningPage.routerName,
  //第一个页面
  "backgroundImagePath1":
      "images/v3.0/NumberReasoning/NumberReasoningBackground1.png",
  //第二个页面
  "questionRules": "观察几个数字，推理出它们之间的变化规律，找出缺失位置的数字。",
  "backgroundImagePath2":
      "images/v3.0/NumberReasoning/NumberReasoningBackground2.jpg",
};
//闪灯测试
final Map<String, String> questionFlashLight = {
  //导航页面
  "questionAbility": "空间记忆能力",
  "questionTitle": "闪灯测试",
  "questionNavContent": "记住灯光闪烁的先后顺序。",
  "questionNavPurpose": "主要评估短时空间记忆水平。。",
  "benefitExample": "经过训练您的短时空间记忆能力会得到提升。",
  "questionImgPath": "images/v4.0/FlashLight/FlashLight.png",
  "nextPageRouter": FlashLightPage.routerName,
  "questionPurpose":
  "这项测验主要评估您的短时空间记忆能力，请记住灯光闪烁的先后次序，记得越多，记忆力越好。",
  //第一个页面
  "backgroundImagePath1":
      "images/v4.0/FlashLight/FlashLight.png",
  //第二个页面
  "questionRules": "屏幕中的灯光会按照一定的顺序依次闪烁，停止后请按照刚才的顺序依次点击对应的按钮。",
  "backgroundImagePath2":
      "images/v4.0/FlashLight/FlashLight.png",
};

List testList = [
  QuestionInfo.fromMap(questionMemoryMatrix),
  QuestionInfo.fromMap(questionNumberReasoning),
  QuestionInfo.fromMap(questionFlashLight),
];

//创建每道题是否完成的列表
List<bool> testFinishedList = [];
