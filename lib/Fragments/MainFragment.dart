import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';

class MainFragment extends StatefulWidget {
  const MainFragment({Key key, this.mainWidget, this.onNextButtonPressed})
      : super(key: key);

  final Widget mainWidget;
  final VoidCallback onNextButtonPressed;

  @override
  State<StatefulWidget> createState() {
    return _MainFragmentState();
  }
}

class _MainFragmentState extends State<MainFragment> {
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
              '姓名：Andrew',
              style: userInfoTitleFontStyle,
            ),
            Text(
              '年龄：22',
              style: userInfoTitleFontStyle,
            ),
            Text(
              '总答题次数：121',
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
            "下 一 题",
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
