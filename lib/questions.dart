import 'package:tester_app/Pages/FlashLight/FlashLightPage.dart';
import 'package:tester_app/Pages/GooseFlyingSouth/GooseFlyingSouth.dart';
import 'package:tester_app/Pages/NblackTest/NbackTestPage.dart';
import 'package:tester_app/Pages/NumberReasoning/NumberReasoningPage.dart';
import 'package:tester_app/Pages/PictureSequenceMemoryTest/PictureSequenceMemoryTestPage.dart';
import 'package:tester_app/Pages/RVIPTest/RVIPTestPage.dart';
import 'package:tester_app/Pages/ShortTermMemoryTest/ShortTermMemoryPage.dart';

import 'package:tester_app/pojo/QuestionInfo.dart';
import 'Pages/ClockDrawTest/ClockDrawTestView.dart';
import 'Pages/MemoryMatrix/MemoryMatrix.dart';
import 'Pages/PairAssoLearning/PairAssoLearningMainPage.dart';
import 'Pages/ProcessSpeed/ProcessSpeedPage.dart';
import 'Pages/FlankerTest/FlankerTestMainPage.dart';
import 'Pages/PersistentTest/PersistentTestMainPage.dart';

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
  "questionPurpose": "这项测验主要评估您的短时空间记忆能力，请记住灯光闪烁的先后次序，记得越多，记忆力越好。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/FlashLight/FlashLight1.jpg",
  //第二个页面
  "questionRules": "屏幕中的六个橙色方框回同时闪烁绿色框中的四种图片一段时间，消失后请按照刚才的位置，选择四张图片出现的位置。",
  "backgroundImagePath2": "images/v4.0/FlashLight/FlashLight2.jpg",
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
  "questionPurpose": "这项测验主要评估您的短期记忆能力，请记住不同图案出现的位置，需要以最少的错误次数完成四关测试。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/PairAL/newPairAL.png",
  //第二个页面
  "questionRules": "屏幕中的灯光会按照一定的顺序依次闪烁，停止后请按照刚才的顺序依次点击对应的按钮。",
  "backgroundImagePath2": "images/v4.0/PairAL/newPairALNote.png",
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
  "questionPurpose": "这项测验主要评估您的认知能力，请您清晰地画出钟表轮廓，以及分针时针位置等。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/ClockDraw/drawClock.png",
  //第二个页面
  "questionRules": "本实验分为三关，第一关画出指定时间的分支和时针，第二关画出表针和数字，第三关画出全部的时钟。",
  "backgroundImagePath2": "images/v4.0/ClockDraw/drawClock.png",
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
  "questionPurpose":
      "这项练习通过对两种不同颜色的大雁进行分别计数，可以不断提高您的工作记忆能力，使您在实际生活中能够更轻松地应对一些事情吗，如在打电话的同时记录下主要谈话内容。",
  //第一个页面
  "backgroundImagePath1": "images/Goose/GooseFlySouth.png",
  //第二个页面
  "questionRules": "全部飞过后，请选择两种大雁分别有多少只。注意不要被其它的大雁干扰。",
  "backgroundImagePath2": "images/Goose/GooseFlySouth.png",
};
//雁南飞demo
final Map<String, String> shortTermMemoryTest = {
  //导航页面
  "questionAbility": "短期记忆",
  "questionTitle": "短期记忆测试",
  "questionNavContent": "被试需要记住网格上图案的形状，然后从记忆中选出图案以及其相对的位置",
  "questionNavPurpose": "提高保存在记忆中，并且立即以相同的顺序再回忆出信息的能力",
  "benefitExample": "训练后您的记忆力、注意力会提高，如在与人交流时会更容易集中精力",
  "questionImgPath": "images/v4.0/shortMemTest/testPic.jpg",
  "nextPageRouter": ShortItemMemoryTestPage.routerName,
  "questionPurpose": "记忆跨度是“编码”，以及将其保存在记忆中，并且立即以相同的顺序再回忆出信息的能力。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/shortMemTest/testPic.jpg",
  //第二个页面
  "questionRules":
      "被试需要记住网格上图案的形状，然后从记忆中选出图案以及其相对的位置。随着测试的进行，难度会越来越大。整个测试有21组，共 63 分。",
  "backgroundImagePath2": "images/v4.0/shortMemTest/shortMemTestNote.png",
};
//图片故事记忆
final Map<String, String> pictureSequenceMemoryTest = {
  //导航页面
  "questionAbility": "情景记忆",
  "questionTitle": "图片故事记忆",
  "questionNavContent": "被测试者需要记住图片的位置，并将中间的图片拖入正确的框中。",
  "questionNavPurpose": "训练被测试者的情景记忆能力。",
  "benefitExample": "当所有图片依次出现后，所有图片回归出图区域随机位置，不能覆盖重叠，测试者需要将图片从出图区域正确的拖至选择区域。",
  "questionImgPath":
      "images/v4.0/PictureSequenceMemoryTest/pictureSequenceMemoryTest.jpg",
  "nextPageRouter": PictureSequenceMemoryTestPage.routerName,
  "questionPurpose": "训练情景记忆能力。",
  //第一个页面
  "backgroundImagePath1":
      "images/v4.0/PictureSequenceMemoryTest/pictureSequenceMemoryTest.jpg",
  //第二个页面
  "questionRules":
      "选择难度页面，需测试组选择难度，难度不同意味着需要记忆的图片数量不同。本测试有3个主题（医院，超市，游乐园），每次测试按随机顺序出现。",
  "backgroundImagePath2":
      "images/v4.0/PictureSequenceMemoryTest/pictureSequenceMemoryTest.jpg",
};
//加工速度测试
final Map<String, String> questionProcessSpeed = {
  //导航页面
  "questionAbility": "感知速度",
  "questionTitle": "加工速度测试",
  "questionNavContent": "被测试者需要快速搜索和比较同时出现的图像。",
  "questionNavPurpose": "训练被测试者的快速感知图像的能力。",
  "benefitExample": "训练后您的信息处理速度会得到提升。",
  "questionImgPath": "images/v4.0/ProcessSpeed/process_speed.png",
  "nextPageRouter": ProcessSpeedPage.routerName,
  "questionPurpose": "训练图像感知速度。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/FlashLight/FlashLight1.jpg",
  //第二个页面
  "questionRules": "测试者需要尽可能快地找出两个相同的图案。如果您不慎点错图案，可再次点击以取消选择。请注意，当您选择两个图案后程序将自动判题。",
  "backgroundImagePath2": "images/v4.0/FlashLight/FlashLight2.jpg",
};
//抗干扰能力测试
final Map<String, String> questionFlanketTest = {
  //导航页面
  "questionAbility": "抗干扰能力",
  "questionTitle": "抗干扰能力测试",
  "questionNavContent": "被测试者需要快速点击与最中间箭头指向相同的按钮。",
  "questionNavPurpose": "训练被测试者的抵抗侧翼干扰的能力。",
  "benefitExample": "训练后您的抗干扰能力会得到提升。",
  "questionImgPath": "images/v4.0/Flanker/bgFlanker.png",
  "nextPageRouter": FlankerTestMainPage.routerName,
  "questionPurpose": "训练抗干扰能力。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/Flanker/bgFlanker.png",
  //第二个页面
  "questionRules": "本测试正式开始前提供4次模拟测试，不计入总成绩；正式测试共计20次。测试者需要在2s内点击与中间箭头方向相同的按钮，2s内未操作视为错误。",
  "backgroundImagePath2": "images/v4.0/Flanker/bgFlanker.png",
};
//持续警惕性测试
final Map<String, String> questionPersistentTest = {
  //导航页面
  "questionAbility": "持续警惕性",
  "questionTitle": "持续警惕性测试",
  "questionNavContent": "被测试者需要快速点击一闪而过的绿色的圆。",
  "questionNavPurpose": "训练被测试者的精神运动警戒的能力。",
  "benefitExample": "训练后您的持续警惕能力会得到提升。",
  "questionImgPath": "images/v4.0/Persistent/bgPersistent.png",
  "nextPageRouter": PersistentTestMainPage.routerName,
  "questionPurpose": "训练持续警惕能力。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/Persistent/bgPersistent.png",
  //第二个页面
  "questionRules": "在测试开始后，随机间隔从2-7秒，一个按钮的颜色变为绿色。测试者需要在0.6s内点击相应的按钮，否则记为错误，并跳至下一题。模拟测试2次，正式测试8次。",
  "backgroundImagePath2": "images/v4.0/Persistent/bgPersistent.png",
};

//快速视觉信息处理任务
final Map<String, String> RVIPTest = {
  //导航页面
  "questionAbility": "注意力工作记忆",
  "questionTitle": "快速视觉信息处理测试",
  "questionNavContent": "当测试者发现窗口出现提示栏中数字组合时，需要按下按键。",
  "questionNavPurpose": "训练被测试者的视觉注意力以及工作记忆。",
  "benefitExample": "训练后您的注意力以及工作记忆会得到提升。",
  "questionImgPath": "images/v4.0/RVIP/RVIP.png",
  "nextPageRouter": RVIPTestPage.routerName,
  "questionPurpose": "训练持续警惕能力。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/RVIP/RVIP.png",
  //第二个页面
  "questionRules": "在测试开始后，随机出现数字2-9，速度为1分钟，出现100个数字，本次是共2分钟，一共出现200个数字。当测试者看到提示框中的数字序列时需要按下确定按钮。",
  "backgroundImagePath2": "images/v4.0/RVIP/RVIP.png",
};
// Nback测试
final Map<String, String> NbackTest = {
  //导航页面
  "questionAbility": "工作记忆",
  "questionTitle": " N-back测试",
  "questionNavContent": "当测试者发现当出现i与i-2位置的图形一样时，按下按键。",
  "questionNavPurpose": "训练被测试者的连续工作以及。",
  "benefitExample": "训练后您的表现工作记忆会得到提升。",
  "questionImgPath": "images/v4.0/Nback/Nback.png",
  "nextPageRouter": NbackTestPage.routerName,
  "questionPurpose": "训练表现工作记忆。",
  //第一个页面
  "backgroundImagePath1": "images/v4.0/Nback/Nback.png",
  //第二个页面
  "questionRules": "在测试开始后，当出现i与i-2位置的图形一样时，按下按键。共有80个图形，10个正确的组合，在2分钟之内完成。",
  "backgroundImagePath2": "images/v4.0/Nback/Nback.png",
};
List testList = [
  QuestionInfo.fromMap(questionMemoryMatrix),
  QuestionInfo.fromMap(questionNumberReasoning),
  QuestionInfo.fromMap(questionFlashLight),
  QuestionInfo.fromMap(questionPairAssoLearning),
  QuestionInfo.fromMap(drawClockTest),
  QuestionInfo.fromMap(gooseFlyingSouth),
  QuestionInfo.fromMap(shortTermMemoryTest),
  QuestionInfo.fromMap(pictureSequenceMemoryTest),
  QuestionInfo.fromMap(questionProcessSpeed),
  QuestionInfo.fromMap(questionFlanketTest),
  QuestionInfo.fromMap(questionPersistentTest),
  QuestionInfo.fromMap(RVIPTest),
  QuestionInfo.fromMap(NbackTest),
];

//创建每道题是否完成的列表
List<bool> testFinishedList = [];
