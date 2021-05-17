import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/Pages/NumberReasoning/NumberReasoningPage.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/Fragments/QuestionSecondFragment.dart';
import 'package:tester_app/Utils/Utils.dart';

class SecondFragment extends StatefulWidget {
  static const routerName = "/SecondFragment";

  @override
  State<StatefulWidget> createState() {
    return _SecondFragmentState();
  }
}

class _SecondFragmentState extends State<SecondFragment> {
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

  Widget buildMainWidget(context) {
    return Container(
      width: maxWidth,
      height: maxHeight,
      child: Image.asset(
        questionInfo.backgroundImagePath2,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildTitle() {
    return Positioned(
      top: setHeight(130),
      left: setWidth(130),
      child: Text(
        "训练说明:",
        style: TextStyle(
            color: Colors.red,
            fontSize: setSp(90),
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildQuestionDescription() {
    return Positioned(
      top: setHeight(400),
      right: setWidth(70),
      width: setWidth(1000),
      child: Text(
        questionInfo.questionRules,
        style: TextStyle(
            height: setHeight(4),
            color: Colors.white70,
            fontSize: setSp(66),
            fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget buildBottomButtons(context) {
    return Positioned(
      right: setWidth(200),
      bottom: setHeight(120),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: setWidth(500),
            height: setHeight(190),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, NumberReasoningPage.routerName,
                    arguments: questionInfo);
              },
              child: Text(
                "开 始",
                style: TextStyle(
                    fontSize: setSp(80),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: setWidth(4),
                    offset: Offset(setWidth(1), setHeight(1)))
              ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff97cc42), Color(0xff5e9a01)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(setWidth(20))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    questionInfo = ModalRoute.of(context).settings.arguments;
    // questionInfo = QuestionInfo.fromMap(questionWMS);
    return Scaffold(
      body: Container(
        width: maxWidth,
        height: maxHeight,
        color: Color.fromARGB(255, 239, 239, 239),
        child: Stack(
          children: [
            buildMainWidget(context),
            buildTitle(),
            buildQuestionDescription(),
            buildBottomButtons(context),
          ],
        ),
      ),
    );
  }
}
