import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tester_app/Pages/BVMT-R/BVMTPage.dart';
import 'package:tester_app/Pages/Login&Register/CompleteInfoPage.dart';
import 'package:tester_app/Pages/Login&Register/LoginPage.dart';
import 'package:tester_app/Pages/Login&Register/RegisterPage.dart';
import 'package:tester_app/Pages/Login&Register/ShowInfoPage.dart';
import 'package:tester_app/Pages/Maze/MazePage.dart';
import 'package:tester_app/Pages/SymbolEncoding/SymbolEncodingPage.dart';
import 'package:tester_app/Pages/TMT/TMTPage.dart';

import 'Pages/Utils.dart';

// String bootPage = "/login";
// String bootPage = "/completeInfo";
String bootPage = "/showInfo";

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
        "/TMT": (context) => TMTPage(),
        "/SymbolEncoding": (context) => SymbolEncodingPage(),
        "/Maze": (context) => MazePage(),
        "/BVMT": (context) => BVMTPage(),
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
      Navigator.pushNamedAndRemoveUntil(context, bootPage, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    initialScreenUtil(context);
    SharedPreferences.setMockInitialValues({});
    return Scaffold();
  }
}
