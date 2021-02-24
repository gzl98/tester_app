import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class NextEvent {
  int value;
  int answerTime;

  NextEvent(this.value, this.answerTime);
}

class ChractStartEvent {
  int value;

  ChractStartEvent(this.value);
}

class ChractSendDataEvent {
  int value;
  int answerTime;

  ChractSendDataEvent(this.value, this.answerTime);
}
