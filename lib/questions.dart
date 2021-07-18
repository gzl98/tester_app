import 'package:tester_app/Pages/FlashLight/FlashLightPage.dart';
import 'package:tester_app/Pages/GooseFlyingSouth/GooseFlyingSouth.dart';
import 'package:tester_app/Pages/NumberReasoning/NumberReasoningPage.dart';

import 'package:tester_app/pojo/QuestionInfo.dart';
import 'Pages/ClockDrawTest/ClockDrawTestView.dart';
import 'Pages/MemoryMatrix/MemoryMatrix.dart';
import 'Pages/PairAssoLearning/PairAssoLearningMainPage.dart';

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
  "questionNavPurpose": "主要评估短时空间记忆水平。",
  "benefitExample": "经过训练您的短时空间记忆能力会得到提升。",
  "questionImgPath": "images/v4.0/FlashLight/FlashLight.png",
  "nextPageRouter": FlashLightPage.routerName,
  "questionPurpose":
  "这项测验主要评估您的短时空间记忆能力，请记住灯光闪烁的先后次序，记得越多，记忆力越好。",
  //第一个页面
  "backgroundImagePath1":
      "images/v4.0/FlashLight/FlashLight1.jpg",
  //第二个页面
  "questionRules": "屏幕中的六个橙色方框回同时闪烁绿色框中的四种图片一段时间，消失后请按照刚才的位置，选择四张图片出现的位置。",
  "backgroundImagePath2":
      "images/v4.0/FlashLight/FlashLight2.jpg",
};
//配对学习测试
final Map<String, String> questionPairAssoLearning = {
  //导航页面
  "questionAbility": "短期记忆能力",
  "questionTitle": "配对学习测试",
  "questionNavContent": "记住不同图案的出现位置。",
  "questionNavPurpose": "主要评估短时间的记忆能力。。",
  "benefitExample": "经过训练您的短期记忆力可以得到评估与提升。",
  "questionImgPath": "images/v4.0/PairAL/newPairAL.png",
  "nextPageRouter": PairALMainPage.routerName,
  "questionPurpose":
  "这项测验主要评估您的短期记忆能力，请记住不同图案出现的位置，需要以最少的错误次数完成四关测试。",
  //第一个页面
  "backgroundImagePath1":
  "images/v4.0/PairAL/newPairAL.png",
  //第二个页面
  "questionRules": "屏幕中的灯光会按照一定的顺序依次闪烁，停止后请按照刚才的顺序依次点击对应的按钮。",
  "backgroundImagePath2":
  "images/v4.0/PairAL/newPairAL.png",
};
//钟表测试
final Map<String, String> drawClockTest = {
  //导航页面
  "questionAbility": "认知功能",
  "questionTitle": "时钟绘图测试",
  "questionNavContent": "画出时钟轮廓。",
  "questionNavPurpose": "认知问题的临床筛查和认知功能的监测 。",
  "benefitExample": "经过训练您的认知能力能力会得到提升。",
  "questionImgPath": "images/v4.0/ClockDraw/drawClock.png",
  "nextPageRouter": ClockDrawPage.routerName,
  "questionPurpose":
  "这项测验主要评估您的认知能力，请您清晰地画出钟表轮廓，以及分针时针位置等。",
  //第一个页面
  "backgroundImagePath1":
  "images/v4.0/ClockDraw/drawClock.png",
  //第二个页面
  "questionRules": "本实验分为三关，第一关画出指定时间的分支和时针，第二关画出表针和数字，第三关画出全部的时钟。",
  "backgroundImagePath2":
  "images/v4.0/ClockDraw/drawClock.png",
};
//雁南飞demo
final Map<String, String> gooseFlyingSouth = {
  //导航页面
  "questionAbility": "工作记忆",
  "questionTitle": "雁南飞demo",
  "questionNavContent": "对两种不同颜色的大雁进行分别计数。",
  "questionNavPurpose": "提高工作记忆能力和持续注意力水平 。",
  "benefitExample": "训练后您的记忆力、注意力会提高，如在与人交流时会更容易集中精力，能同时记住两个人或多个人的谈话。",
  "questionImgPath": "images/Goose/GooseFlySouth.png",
  "nextPageRouter": GooseFlyingSouthPage.routerName,
  "questionPurpose": "这项练习通过对两种不同颜色的大雁进行分别计数，可以不断提高您的工作记忆能力，使您在实际生活中能够更轻松地应对一些事情吗，如在打电话的同时记录下主要谈话内容。",
  //第一个页面
  "backgroundImagePath1":
  "images/Goose/GooseFlySouth.png",
  //第二个页面
  "questionRules": "全部飞过后，请选择两种大雁分别有多少只。注意不要被其它的大雁干扰。",
  "backgroundImagePath2":
  "images/Goose/GooseFlySouth.png",
};
List testList = [
  QuestionInfo.fromMap(questionMemoryMatrix),
  QuestionInfo.fromMap(questionNumberReasoning),
  QuestionInfo.fromMap(questionFlashLight),
  QuestionInfo.fromMap(questionPairAssoLearning),
  QuestionInfo.fromMap(drawClockTest),
  QuestionInfo.fromMap(gooseFlyingSouth),
];

//创建每道题是否完成的列表
List<bool> testFinishedList = [];
