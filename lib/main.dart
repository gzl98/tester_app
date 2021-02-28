import 'package:flutter/material.dart';
import 'package:tester_app/Pages/BVMT-R/BMVTPage.dart';
import 'package:tester_app/Pages/Login&Register/CompleteInfoPage.dart';
import 'package:tester_app/Pages/Login&Register/CompletePage.dart';
import 'package:tester_app/Pages/Login&Register/LoginPage.dart';
import 'package:tester_app/Pages/Login&Register/RegisterPage.dart';
import 'package:tester_app/Pages/Login&Register/ShowInfoPage.dart';
import 'package:tester_app/Pages/Maze/MazePage.dart';
import 'package:tester_app/Pages/Character/CharacterPage.dart';
import 'package:tester_app/Pages/TMT/TMTPage.dart';
import 'package:tester_app/Pages/WMS/WMSPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';

import 'Utils/Utils.dart';

String bootPage = "/WMS";
// String bootPage = "/login";
// String bootPage = "/completeInfo";
// String bootPage = "/showInfo";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      routes: {
        "/": (context) => BootPage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/completeInfo": (context) => CompleteInfoPage(),
        "/showInfo": (context) => ShowInfoPage(),
        "/completePage": (context) => CompletePage(),
        "/TMT": (context) => TMTPage(),
        "/Character": (context) => CharacterPage(),
        "/Maze": (context) => MazePage(),
        "/BVMT": (context) => BMVTPage(),
        "/WMS": (context) => WMSPage(),
      },
    );
  }
}

class BootPage extends StatefulWidget {
  @override
  _BootPageState createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkLoginState();
    });
  }

  void checkLoginState() async {
    await initialScreenUtil(context);
    String token = await StorageUtil.getStringItem("token");
    if (token != null) {
      try {
        await getUserInfoByToken(token);
        String mobile = await StorageUtil.getStringItem("mobile");
        if (mobile != null) {
          //  用户信息完整
          Navigator.pushNamedAndRemoveUntil(
              context, "/showInfo", (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, "/completeInfo", (route) => false);
        }
      } catch (e) {
        print(e);
        StorageUtil.clear();
        Navigator.pushNamedAndRemoveUntil(context, bootPage, (route) => false);
      }
    } else {
      StorageUtil.clear();
      Navigator.pushNamedAndRemoveUntil(context, bootPage, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
