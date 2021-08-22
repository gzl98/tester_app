import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tester_app/Utils/Utils.dart';

class MultipleObjectTrackingPage extends StatefulWidget {
  static final String routeName = "/MultipleObjectTrackingPage";

  @override
  State<StatefulWidget> createState() {
    return MultipleObjectTrackingPageState();
  }
}

class MultipleObjectTrackingPageState extends State<MultipleObjectTrackingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Container(), onWillPop: () => showExitDialog(context));
  }
}