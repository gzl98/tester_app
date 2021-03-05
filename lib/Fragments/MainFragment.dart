import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';

class MainFragment extends StatefulWidget {
  const MainFragment(
      {Key key,
      this.mainWidget,
      this.onNextButtonPressed,
      this.nextButtonText = "下 一 题"})
      : super(key: key);

  final Widget mainWidget;
  final VoidCallback onNextButtonPressed;
  final String nextButtonText;

  @override
  State<StatefulWidget> createState() {
    return _MainFragmentState();
  }
}

class _MainFragmentState extends State<MainFragment> {
  String _username;
  String _sex;
  int _testCount;

  @override
  void initState() {
    initUserInfo();
    getTestCount();
    super.initState();
  }

  void initUserInfo() async {
    String username = await StorageUtil.getStringItem("username");
    int sexCode = await StorageUtil.getIntItem("sex");
    setState(() {
      _username = username;
      if (sexCode == 0)
        _sex = "男";
      else if (sexCode == 1) _sex = "女";
    });
  }

  void getTestCount() async {
    String username = await StorageUtil.getStringItem("username");
    String token = await StorageUtil.getStringItem("token");
    Response response;
    Dio dio = Dio();
    try {
      response = await dio.get(baseUrl + "queryQN_username",
          queryParameters: {"username": username},
          options: getAuthorizationOptions(token));
      setState(() {
        _testCount = response.data.length;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget buildTitle() {
    TextStyle userInfoTitleFontStyle = TextStyle(
        fontSize: setSp(42),
        fontWeight: FontWeight.bold,
        // color: Colors.red[400],
        // color: Color.fromARGB(255, 224, 100, 14),
        color: Colors.black54,
        shadows: [
          Shadow(
              color: Colors.grey,
              offset: Offset(setWidth(1.5), setHeight(1.5)),
              blurRadius: setWidth(1.5)),
        ]);
    return Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(
          left: setWidth(40),
          right: setWidth(40),
        ),
        width: setWidth(2000),
        height: setHeight(90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '姓名：$_username',
              style: userInfoTitleFontStyle,
            ),
            Text(
              '性别：$_sex',
              style: userInfoTitleFontStyle,
            ),
            Text(
              '总答题次数：$_testCount',
              style: userInfoTitleFontStyle,
            ),
          ],
        ));
  }

  Widget buildNextButton() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: setHeight(15)),
        width: setWidth(1960),
        height: setHeight(95),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
            elevation: MaterialStateProperty.all(setWidth(2)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(20))),
            )),
          ),
          child: Text(
            // "下 一 题",
            widget.nextButtonText,
            style: TextStyle(
              fontSize: setSp(44),
              fontWeight: FontWeight.w900,
            ),
          ),
          onPressed: widget.onNextButtonPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTitle(),
        Container(
          width: setWidth(2000),
          height: setHeight(1400),
          child: Center(
            child: Container(
              width: setWidth(1960),
              height: setHeight(1350),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]),
              ),
              child: widget.mainWidget,
            ),
          ),
        ),
        buildNextButton(),
      ],
    );
  }
}
