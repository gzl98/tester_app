import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/Utils/Utils.dart';

import '../questions.dart';

class Fragment extends StatefulWidget {
  static const routerName = "/Fragment";

  @override
  State<StatefulWidget> createState() {
    return _FragmentState();
  }
}

class _FragmentState extends State<Fragment> {
  QuestionInfo questionInfo;
  AudioPlayer audioPlayer;
  AudioCache player;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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

  Widget buildBackground() {
    return Container(
      width: maxWidth,
      height: maxHeight,
      child: Image.asset(
        "images/v4.0/background.jpg",
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildImage() {
    return Positioned(
      top: setHeight(400),
      left: setWidth(170),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(setWidth(5), setHeight(4)),
            blurRadius: setWidth(10),
          ),
        ], border: Border.all(color: Colors.black87, width: setWidth(4))),
        width: maxWidth * 0.4,
        height: maxHeight * 0.4,
        child: Image.asset(
          questionInfo.questionImgPath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget buildQuestionTitle() {
    return Positioned(
      top: setHeight(100),
      left: setWidth(170),
      width: setWidth(1000),
      child: Text(
        questionInfo.questionTitle,
        style: TextStyle(
            shadows: [
              Shadow(
                offset: Offset(setWidth(2), setHeight(2)),
                blurRadius: setWidth(2),
              )
            ],
            height: setHeight(4),
            color: Color.fromARGB(255, 122, 29, 29),
            fontSize: setSp(94),
            fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget buildQuestionDescription() {
    return Positioned(
      top: setHeight(400),
      right: setWidth(140),
      child: Container(
        width: maxWidth * 0.4,
        height: maxHeight * 0.4,
        child: Text(
          questionInfo.questionRules,
          textAlign: TextAlign.justify,
          style: TextStyle(height: setHeight(3), fontSize: setSp(66), fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget buildBottomButtons(context) {
    return Positioned(
      width: maxWidth,
      bottom: setHeight(150),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: setWidth(500),
            height: setHeight(190),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, questionInfo.nextPageRouter, arguments: questionInfo);
              },
              child: Text(
                "开 始",
                style: TextStyle(fontSize: setSp(80), fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black54, blurRadius: setWidth(4), offset: Offset(setWidth(1), setHeight(1)))
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
    // questionInfo = QuestionInfo.fromMap(questionProcessSpeed);
    return Scaffold(
      body: Container(
        width: maxWidth,
        height: maxHeight,
        color: Color.fromARGB(255, 239, 239, 239),
        child: Stack(
          children: [
            buildBackground(),
            buildImage(),
            buildQuestionTitle(),
            buildQuestionDescription(),
            buildBottomButtons(context),
          ],
        ),
      ),
    );
  }
}
