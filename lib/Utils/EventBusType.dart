import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class NextEvent {
  int value;
  int answerTime;
  NextEvent(this.value, this.answerTime);
}

class TimeCutDown {
  int value;
  TimeCutDown(this.value);
}
//跨组件 ——画板切换背景事件
class NextPicture{
  String imgPath;
  NextPicture(this.imgPath);
}
//跨组件事件
class ChractStartEvent {
  int value;

  ChractStartEvent(this.value);
}

class ChractSendDataEvent {
  int value;
  int answerTime;

  ChractSendDataEvent(this.value, this.answerTime);
}
