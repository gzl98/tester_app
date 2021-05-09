import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tester_app/pojo/QuestionInfo.dart';
import 'package:tester_app/Fragments/QuestionSecondFragment.dart';
import 'package:tester_app/Utils/Utils.dart';

class QuestionFirstFragment extends StatefulWidget {
  static const routerName = "/QuestionFirst";

  @override
  State<StatefulWidget> createState() {
    return _QuestionFirstFragmentState();
  }
}

class _QuestionFirstFragmentState extends State<QuestionFirstFragment> {
  QuestionInfo questionInfo;
  AudioPlayer audioPlayer;
  AudioCache player;

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    initAudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      play();
    });
    super.initState();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    player = AudioCache();
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  //播放音频文件
  play() async {
    //如果没有播放路径，则直接退出
    if (questionInfo.soundPath1 == null) return;
    audioPlayer = await player.play(questionInfo.soundPath1);
  }

  //停止播放
  stop() async {
    audioPlayer.stop();
  }

  Widget buildNextStepButton(context) {
    return Container(
      width: setWidth(600),
      height: setHeight(120),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(setWidth(2)),
        ),
        onPressed: () {
          if (questionInfo.nextPageRouter != null) {
            stop();
            Navigator.pushNamed(context, questionInfo.nextPageRouter);
          } else {
            stop();
            Navigator.pushNamed(context, QuestionSecondFragment.routerName,
                arguments: {"questionInfo": questionInfo, "currentPage": 2});
          }
        },
        child: Text(
          "下一步",
          style: TextStyle(fontSize: setSp(55), fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xff418ffc), Color(0xff174cfc)],
      )),
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
        child: Column(
          children: [
            SizedBox(height: setHeight(300)),
            //上部布局
            Container(
              width: maxWidth,
              height: setHeight(1100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //左侧颜色条
                  Column(
                    children: [
                      SizedBox(height: setHeight(40)),
                      Container(
                        width: setWidth(15),
                        height: setHeight(300),
                        color: Color.fromARGB(255, 26, 132, 230),
                      ),
                      Container(
                        width: setWidth(15),
                        height: setHeight(300),
                        color: Color.fromARGB(255, 253, 101, 90),
                      ),
                    ],
                  ),
                  SizedBox(width: setWidth(150)),
                  //题目文本内容
                  Container(
                    width: setWidth(1200),
                    height: setHeight(1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questionInfo.questionName,
                          style: TextStyle(
                            fontSize: setSp(130),
                            color: Color.fromARGB(255, 31, 134, 233),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: setHeight(40)),
                        Text(
                          questionInfo.questionPurpose,
                          style: TextStyle(
                            height: setHeight(4.8),
                            fontSize: setSp(43),
                            color: Color.fromARGB(255, 133, 135, 135),
                          ),
                        ),
                        SizedBox(height: setHeight(40)),
                        questionInfo.questionNotes == null
                            ? Container()
                            : Text(
                                "注意：",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: setSp(46),
                                  color: Color.fromARGB(255, 226, 112, 113),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        questionInfo.questionNotes == null
                            ? Container()
                            : Text(
                                questionInfo.questionNotes,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  height: setHeight(3),
                                  fontSize: setSp(46),
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(width: setWidth(100)),
                  //右侧展示图片
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: setHeight(40)),
                        width: setWidth(900),
                        height: setHeight(600),
                        child: questionInfo.questionShowWidget == null
                            ? Image.asset(
                                'images/v2.0/testPicture.jpg',
                                fit: BoxFit.fill,
                              )
                            : questionInfo.questionShowWidget,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey[400], width: setWidth(1)),
                            color: Color.fromARGB(255, 226, 229, 228),
                            borderRadius: BorderRadius.all(
                                Radius.circular(setWidth(25)))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: setHeight(300)),
            //下一步按钮
            buildNextStepButton(context),
          ],
        ),
      ),
    );
  }
}
