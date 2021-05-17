import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/Fragments/SecondFragment.dart';
import 'package:tester_app/Pages/NumberReasoning/NumberReasoningPage.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/Fragments/QuestionSecondFragment.dart';
import 'package:tester_app/Utils/Utils.dart';

import '../questions.dart';

class FirstFragment extends StatefulWidget {
  static const routerName = "/FirstFragment";

  @override
  State<StatefulWidget> createState() {
    return _FirstFragmentState();
  }
}

class _FirstFragmentState extends State<FirstFragment> {
  QuestionInfo questionInfo;
  AudioPlayer audioPlayer;
  AudioCache player;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // initAudioPlayer();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   play();
    // });
    super.initState();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    player = AudioCache();
  }

  @override
  void dispose() {
    // audioPlayer.release();
    // audioPlayer.dispose();
    super.dispose();
  }

  //播放音频文件
  play() async {
    //如果没有播放路径，则直接退出
    // if (questionInfo.soundPath1 == null) return;
    // audioPlayer = await player.play(questionInfo.soundPath1);
  }

  //停止播放
  stop() async {
    audioPlayer.stop();
  }

  Widget buildMainWidget() {
    return Container(
      width: maxWidth,
      height: maxHeight,
      child: Image.asset(
        questionInfo.backgroundImagePath1,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildBottomButtons(context) {
    double buttonWidth = 400;
    double buttonHeight = 170;
    TextStyle textStyle = TextStyle(
        fontSize: setSp(68), fontWeight: FontWeight.bold, color: Colors.white);
    BorderRadius borderRadius = BorderRadius.all(Radius.circular(setWidth(20)));
    BoxShadow boxShadow = BoxShadow(blurRadius: setWidth(5));
    double bottomHeight = 250;
    if (questionInfo.questionTitle == "记忆矩阵") {
      bottomHeight = 100;
    }
    return Positioned(
      width: maxWidth,
      bottom: setHeight(bottomHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: setWidth(buttonWidth),
            height: setHeight(buttonHeight),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, SecondFragment.routerName,
                    arguments: questionInfo);
              },
              child: Text(
                "说 明",
                style: textStyle,
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [boxShadow],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff3296d5), Color(0xff0467b6)],
              ),
              borderRadius: borderRadius,
            ),
          ),
          SizedBox(
            width: setWidth(300),
          ),
          Container(
            width: setWidth(buttonWidth),
            height: setHeight(buttonHeight),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, questionInfo.nextPageRouter,
                    arguments: questionInfo);
              },
              child: Text(
                "开 始",
                style: textStyle,
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [boxShadow],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff97cc42), Color(0xff5e9a01)],
              ),
              borderRadius: borderRadius,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    questionInfo = ModalRoute.of(context).settings.arguments;
    // questionInfo = QuestionInfo.fromMap(questionNumberReasoning);
    return Scaffold(
      body: Container(
        width: maxWidth,
        height: maxHeight,
        color: Color.fromARGB(255, 239, 239, 239),
        child: Stack(
          children: [
            buildMainWidget(),
            buildBottomButtons(context),
          ],
        ),
      ),
    );
  }
}
