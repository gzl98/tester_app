import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';

class BVMTPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BVMTPageState();
  }
}

class _BVMTPageState extends State<BVMTPage> {
  Widget buildButtonNextQuestion() {
    return SizedBox(
      width: setWidth(260),
      height: setHeight(120),
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(30)))),
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.keyboard_arrow_right,size: setSp(80),),
              Text(
                "下一题",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: setSp(58)),
              )
            ],
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/completePage", (route) => false);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: Container(
          // color: Colors.red,
          alignment: Alignment.center,
          // child: buttonNextQuestion,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "BVMTPage",
                style: TextStyle(fontSize: 80),
              ),
              buildButtonNextQuestion(),
            ],
          ),
        ),
      ),
    );
  }
}
