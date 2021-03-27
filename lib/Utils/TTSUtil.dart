import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TTSUtil {
  factory TTSUtil() => _getInstance();

  static TTSUtil get instance => _getInstance();
  static TTSUtil _instance;

  //单例模式
  static TTSUtil _getInstance() {
    if (_instance == null) {
      _instance = new TTSUtil._internal();
    }
    return _instance;
  }

  TTSUtil._internal() {
    // 初始化
    initTTS();
  }

  dynamic languages;
  String language;
  FlutterTts flutterTts;
  double volume = 1;
  double pitch = 1.0;
  double rate = 1;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  //初始化
  initTTS() {
    flutterTts = FlutterTts();
    _getLanguages();
    _getEngines();
    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });
    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });
    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stopped;
    });
    flutterTts.setContinueHandler(() {
      ttsState = TtsState.continued;
    });
    flutterTts.setErrorHandler((msg) {
      print("Error: $msg");
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    //print(languages);
  }

  //获取引擎
  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        //print(engine);
      }
    }
  }

  Future speak(String text) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.awaitSpeakCompletion(true);
    if (text != null) {
      if (text.isNotEmpty) {
        var result = await flutterTts.speak(text);
      }
    }
  }

  Future stop() async {
    var result = await flutterTts.stop();
    //if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future pause() async {
    var result = await flutterTts.pause();
    //if (result == 1) setState(() => ttsState = TtsState.paused);
  }
}
