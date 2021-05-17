import 'package:flutter/material.dart';
import 'package:tester_app/Fragments/FirstFragment.dart';
import 'package:tester_app/Fragments/QuestionFirstFragment.dart';
import 'package:tester_app/Fragments/QuestionSecondFragment.dart';
import 'package:tester_app/Pages/COT/COTPage.dart';
import 'package:tester_app/Pages/Login&Register/CompleteInfoPage.dart';
import 'package:tester_app/Pages/Login&Register/LoginPage.dart';
import 'package:tester_app/Pages/Login&Register/RegisterPage.dart';
import 'package:tester_app/Pages/Login&Register/ShowInfoPage.dart';
import 'package:tester_app/Pages/MemoryMatrix/MemoryMatrix.dart';
import 'package:tester_app/Pages/NewCharacter/NewCharacterMainPage.dart';
import 'package:tester_app/Pages/NumberReasoning/NumberReasoningPage.dart';
import 'package:tester_app/Pages/STROOP/StroopColorWordPage.dart';
import 'package:tester_app/Pages/STROOP/StroopWordColorPage.dart';
import 'package:tester_app/Pages/STROOP/StroopWordPage.dart';
import 'package:tester_app/Pages/Symbol/SymbolMainPage.dart';
import 'package:tester_app/Pages/WMS/WMSDigitalPage.dart';
import 'package:tester_app/Pages/WMS/WMSSpacePage.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'Fragments/SecondFragment.dart';
import 'Pages/NewTMT/TMTSpacePage.dart';
import 'Utils/Utils.dart';

// String bootPage = TestNavPage.routerName;
String bootPage = FirstFragment.routerName;
// String bootPage = LoginPage.routerName;

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
        LoginPage.routerName: (context) => LoginPage(),
        RegisterPage.routerName: (context) => RegisterPage(),
        ShowInfoPage.routerName: (context) => ShowInfoPage(),
        CompleteInfoPage.routerName: (context) => CompleteInfoPage(),
        WMSSpacePage.routerName: (context) => WMSSpacePage(),
        WMSDigitalPage.routerName: (context) => WMSDigitalPage(),
        StroopPage.routerName: (context) => StroopPage(),
        StroopWordColorPage.routerName: (context) => StroopWordColorPage(),
        StroopColorWordPage.routerName: (context) => StroopColorWordPage(),
        SymbolMainPage.routerName: (context) => SymbolMainPage(),
        CharacterMainPage.routerName: (context) => CharacterMainPage(),
        COTPage.routerName: (context) => COTPage(),
        TestNavPage.routerName: (context) => TestNavPage(),
        QuestionFirstFragment.routerName: (context) => QuestionFirstFragment(),
        QuestionSecondFragment.routerName: (context) =>
            QuestionSecondFragment(),
        TMTSpacePage.routerName: (context) => TMTSpacePage(),
        FirstFragment.routerName: (context) => FirstFragment(),
        SecondFragment.routerName: (context) => SecondFragment(),
        NumberReasoningPage.routerName: (context) => NumberReasoningPage(),
        MemoryMatrixPage.routerName: (context) => MemoryMatrixPage(),
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
              context, ShowInfoPage.routerName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, CompleteInfoPage.routerName, (route) => false);
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
