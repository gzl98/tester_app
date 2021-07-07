import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/Utils.dart';

class CompletePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompletePageState();
  }
}

class _CompletePageState extends State<CompletePage> {
  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  TextStyle fontStyle =
      TextStyle(fontSize: setSp(50), fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitDialog(context),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: setHeight(100),
            ),
            Container(
              width: maxWidth,
              alignment: AlignmentDirectional.center,
              child: Text(
                "恭 喜 您 完 成 测 试",
                style: TextStyle(
                  fontSize: setSp(180),
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: setHeight(280),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/showInfo", (router) => false);
                },
                child: Text(
                  "返回首页",
                  style: TextStyle(
                    color: Color.fromARGB(150, 0, 0, 0),
                    fontSize: setSp(70),
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
