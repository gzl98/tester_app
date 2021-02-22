import 'package:event_bus/event_bus.dart';

EventBus eventBus=new EventBus();

class NextEvent{
  int value;
  int answerTime;
  NextEvent(this.value,this.answerTime);
}