import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';

//pixel 900*600
Widget buildSDMTFirstFragmentShowWidget() {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/v2.0/SDMTbackground.jpg'),
          fit: BoxFit.scaleDown,
          alignment: Alignment.center),
    ),
  );
}

//pixel maxWidth*1000(内部必须包含一个Container，高度可以自定义，会影响下方文字的位置，但是必须指定)
Widget buildSDMTSecondFragmentShowWidget() {
  return Container(
    alignment: Alignment.center,
    width: maxWidth,
    height: setHeight(1000),
    child: Container(
      margin: EdgeInsets.only(top: setHeight(400)),
      alignment: Alignment.center,
      width: setWidth(800),
      height: setHeight(550),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/v2.0/SDMTbackground.jpg'),
              fit: BoxFit.fill,
              alignment: Alignment.center),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD), width: setWidth(1)),
          color: Color.fromARGB(255, 226, 229, 228),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(25)))),
    ),
  );
}

//pixel 900*600
Widget buildSymbolFirstFragmentShowWidget() {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/symbol/11.png'),
          fit: BoxFit.scaleDown,
          alignment: Alignment.center),
    ),
  );
}

//pixel maxWidth*1000(内部必须包含一个Container，高度可以自定义，会影响下方文字的位置，但是必须指定)
Widget buildSymbolSecondFragmentShowWidget() {
  return Container(
    alignment: Alignment.center,
    width: maxWidth,
    height: setHeight(1000),
    child: Container(
      margin: EdgeInsets.only(top: setHeight(400)),
      alignment: Alignment.center,
      width: setWidth(800),
      height: setHeight(550),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/v2.0/symbolbackground.png'),
              fit: BoxFit.fill,
              alignment: Alignment.center),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD), width: setWidth(1)),
          color: Color.fromARGB(255, 226, 229, 228),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(25)))),
    ),
  );
}

//pixel 900*600
Widget buildCharacterFirstFragmentShowWidget() {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/character/4.png'),
          fit: BoxFit.scaleDown,
          alignment: Alignment.center),
    ),
  );
}

//pixel maxWidth*1000(内部必须包含一个Container，高度可以自定义，会影响下方文字的位置，但是必须指定)
Widget buildCharacterSecondFragmentShowWidget() {
  return Container(
    alignment: Alignment.center,
    width: maxWidth,
    height: setHeight(1000),
    child: Container(
      margin: EdgeInsets.only(top: setHeight(400)),
      alignment: Alignment.center,
      width: setWidth(800),
      height: setHeight(550),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/v2.0/characterbackground.png'),
              fit: BoxFit.fill,
              alignment: Alignment.center),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD), width: setWidth(1)),
          color: Color.fromARGB(255, 226, 229, 228),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(25)))),
    ),
  );
}

Widget buildCOTFirstFragmentShowWidget() {
  return Container(
    width: setWidth(900),
    height: setHeight(600),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Color.fromARGB(255, 229, 229, 229),
        borderRadius: BorderRadius.all(Radius.circular(setWidth(50))),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 100, 100, 100),
              blurRadius: setWidth(10),
              offset: Offset(setWidth(1), setHeight(2)))
        ]),
    child: Center(
      child: Image.asset(
        "images/v2.0/COT/0.png",
        width: setWidth(350),
        fit: BoxFit.fill,
      ),
    ),
  );
}

//pixel 900*600
Widget buildWMSDigitalFirstFragmentShowWidget() {
  double digitalWidth = 150;
  List textList = ['1', '4', '8', '5'];
  List<Widget> editWidgets = [];
  for (int i = 0; i < textList.length; i++) {
    Widget digital = Column(
      children: [
        Text(
          textList[i],
          style: TextStyle(
            fontSize: setSp(140),
            color: Color.fromARGB(255, 98, 78, 75),
          ),
        ),
        Container(
          margin: EdgeInsets.all(setWidth(2.5)),
          width: setWidth(digitalWidth),
          height: setHeight(15),
          color: Color.fromARGB(255, 89, 150, 209),
        )
      ],
    );
    editWidgets.add(digital);
  }
  return Container(
      width: setWidth((digitalWidth + 5) * textList.length),
      // color: Color(0xff56a8aa),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: editWidgets,
          ),
        ],
      ));
}

//pixel maxWidth*1000(内部必须包含一个Container，高度可以自定义，会影响下方文字的位置，但是必须指定)
Widget buildWMSDigitalSecondFragmentShowWidget() {
  return Container(
    alignment: Alignment.center,
    width: maxWidth,
    height: setHeight(1000),
    child: Container(
      margin: EdgeInsets.only(top: setHeight(400)),
      alignment: Alignment.center,
      width: setWidth(800),
      height: setHeight(550),
      child: Text(
        '9',
        style: TextStyle(
          fontSize: setSp(250),
          color: Color.fromARGB(255, 98, 78, 75),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD), width: setWidth(1)),
          color: Color.fromARGB(255, 226, 229, 228),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(25)))),
    ),
  );
}

//pixel maxWidth*1000(内部必须包含一个Container，高度可以自定义，会影响下方文字的位置，但是必须指定)
Widget buildWMSDigitalThirdFragmentShowWidget() {
  Widget buildText() {
    double digitalWidth = 100;
    List textList = ['1', '4', '5', '', ''];
    List<Widget> editWidgets = [];
    for (int i = 0; i < textList.length; i++) {
      Widget digital = Column(
        children: [
          Text(
            textList[i].toString(),
            style: TextStyle(
              fontSize: setSp(90),
              color: Color.fromARGB(255, 98, 78, 75),
            ),
          ),
          Container(
            margin: EdgeInsets.all(setWidth(2.5)),
            width: setWidth(digitalWidth),
            height: setHeight(15),
            color: i == 3
                ? Color.fromARGB(255, 253, 121, 111)
                : Color.fromARGB(255, 89, 150, 209),
          )
        ],
      );
      editWidgets.add(digital);
    }
    return Container(
        width: setWidth((digitalWidth + 5) * textList.length),
        // color: Color(0xff56a8aa),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: editWidgets,
            ),
          ],
        ));
  }

  Widget buildKeyBoard() {
    BoxDecoration decoration = BoxDecoration(
        color: Color.fromARGB(255, 241, 241, 241),
        borderRadius: BorderRadius.all(Radius.circular(setWidth(5))),
        border: Border.all(width: setWidth(0.5), color: Colors.grey),
        boxShadow: [
          BoxShadow(color: Color(0xFF9E9E9E), blurRadius: setWidth(3))
        ]);
    TextStyle textStyle = TextStyle(
        fontSize: setSp(18),
        color: Colors.black54,
        fontWeight: FontWeight.bold);
    List<Widget> digitalList = [];
    for (int i = 0; i < 3; ++i) {
      List<Widget> childrenList = [];
      for (int j = 0; j < 3; ++j) {
        Widget container = Container(
          margin: EdgeInsets.only(
              right: setWidth(3),
              left: setWidth(3),
              top: setHeight(5),
              bottom: setHeight(5)),
          width: setWidth(50),
          height: setHeight(50),
          alignment: Alignment.center,
          child: Text((j * 3 + i + 1).toString(),
              style: TextStyle(
                  fontSize: setSp(25),
                  color: Colors.black54,
                  fontWeight: FontWeight.bold)),
          decoration: decoration,
        );
        childrenList.insert(0, container);
      }
      Widget childWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: childrenList,
      );
      digitalList.add(childWidget);
    }
    Widget functionKeys = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: setWidth(50),
          height: setHeight(50),
          margin: EdgeInsets.only(
              right: setWidth(3),
              left: setWidth(6),
              top: setHeight(5),
              bottom: setHeight(5)),
          child: Text("清除", style: textStyle),
          decoration: decoration,
        ),
        Container(
          alignment: Alignment.center,
          width: setWidth(50),
          height: setHeight(110),
          margin: EdgeInsets.only(
              right: setWidth(3),
              left: setWidth(6),
              top: setHeight(5),
              bottom: setHeight(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("确", style: textStyle),
              SizedBox(height: setHeight(10)),
              Text("认", style: textStyle),
            ],
          ),
          decoration: decoration,
        ),
      ],
    );
    return Container(
      width: setWidth(280),
      height: setHeight(230),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: digitalList + [functionKeys],
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(radius: setWidth(2.5), colors: [
          Color.fromARGB(255, 238, 240, 242),
          Color.fromARGB(255, 214, 216, 217),
        ]),
        border: Border.all(color: Colors.grey[300], width: setWidth(1)),
        borderRadius: BorderRadius.all(Radius.circular(setWidth(10))),
        boxShadow: [
          BoxShadow(
              color: Colors.black45,
              offset: Offset(setWidth(4), setHeight(10)),
              blurRadius: setWidth(10))
        ],
      ),
    );
  }

  return Container(
    alignment: Alignment.center,
    width: maxWidth,
    height: setHeight(1000),
    child: Container(
      margin: EdgeInsets.only(top: setHeight(400)),
      alignment: Alignment.center,
      width: setWidth(800),
      height: setHeight(550),
      child: Stack(
        children: [
          Positioned(
            right: setWidth(50),
            bottom: setHeight(40),
            child: buildKeyBoard(),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: setHeight(200)),
              child: buildText(),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD), width: setWidth(1)),
          color: Color.fromARGB(255, 226, 229, 228),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(25)))),
    ),
  );
}

//pixel 900*600
Widget buildWMSSpaceFirstFragmentShowWidget() {
  List<double> buttonX = [100, 200, 400, 500, 600, 700];
  List<double> buttonY = [450, 150, 320, 50, 460, 190];
  List<Widget> buttons = [];
  for (int i = 0; i < 6; i++) {
    Positioned positioned = Positioned(
      left: setWidth(buttonX[i]),
      top: setHeight(buttonY[i]),
      child: Container(
        width: setWidth(80),
        height: setHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: i == 3 ? Colors.blue[700] : Color.fromARGB(255, 98, 78, 75),
            boxShadow: [BoxShadow()],
            borderRadius: BorderRadius.all(Radius.circular(setWidth(20))),
          ),
        ),
      ),
    );
    buttons.add(positioned);
  }
  return Stack(
    children: buttons,
  );
}

//pixel maxWidth*1000(内部必须包含一个Container，高度可以自定义，会影响下方文字的位置，但是必须指定)
Widget buildWMSSpaceSecondFragmentShowWidget() {
  List<double> buttonX = [120, 240, 450, 570];
  List<double> buttonY = [370, 100, 350, 80];
  List<Widget> buttons = [];
  for (int i = 0; i < 4; i++) {
    Positioned positioned = Positioned(
      left: setWidth(buttonX[i]),
      top: setHeight(buttonY[i]),
      child: Container(
        width: setWidth(100),
        height: setHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: i == 3 ? Colors.blue[700] : Color.fromARGB(255, 98, 78, 75),
            boxShadow: [BoxShadow()],
            borderRadius: BorderRadius.all(Radius.circular(setWidth(20))),
          ),
        ),
      ),
    );
    buttons.add(positioned);
  }
  return Container(
    alignment: Alignment.center,
    width: maxWidth,
    height: setHeight(1000),
    child: Container(
      margin: EdgeInsets.only(top: setHeight(400)),
      alignment: Alignment.center,
      width: setWidth(800),
      height: setHeight(550),
      child: Stack(
        children: buttons,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD), width: setWidth(1)),
          color: Color.fromARGB(255, 226, 229, 228),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(25)))),
    ),
  );
}

//pixel 900*600
Widget buildFlashLightFirstFragmentShowWidget() {
  double centerX = 900 / 2;
  double centerY = 600 / 2;
  double spaceX = 240;
  double spaceY = 160;
  List<double> buttonX = [centerX, centerX - spaceX, centerX + spaceX, centerX];
  List<double> buttonY = [centerY - spaceY, centerY, centerY, centerY + spaceY];
  double buttonRadio = 120;
  List<Color> buttonColors = [
    Color.fromARGB(255, 130, 0, 0),
    Color.fromARGB(255, 0, 130, 0),
    Color.fromARGB(255, 0, 0, 130),
    Color.fromARGB(255, 130, 130, 0),
  ];
  List<Color> buttonLightColors = [
    Color.fromARGB(255, 245, 0, 0),
    Color.fromARGB(255, 0, 245, 0),
    Color.fromARGB(255, 0, 123, 255),
    Color.fromARGB(255, 230, 230, 0),
  ];
  List<Widget> buttons = [];
  for (int i = 0; i < buttonX.length; i++) {
    ElevatedButton button = ElevatedButton(
      child: Container(),
      style: ButtonStyle(
        animationDuration: Duration(milliseconds: 10),
        overlayColor: MaterialStateProperty.all(buttonLightColors[i]),
        backgroundColor: MaterialStateProperty.all(buttonColors[i]),
        elevation: MaterialStateProperty.all(setWidth(10)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(setWidth(buttonRadio))),
        )),
      ),
    );
    Positioned positioned = Positioned(
      left: setWidth(buttonX[i] - buttonRadio / 2),
      top: setHeight(buttonY[i] - buttonRadio / 2),
      child: Container(
        width: setWidth(buttonRadio),
        height: setHeight(buttonRadio),
        child: button,
      ),
    );
    buttons.add(positioned);
  }
  return Stack(
    children: buttons,
  );
}

//pixel maxWidth*1000(内部必须包含一个Container，高度可以自定义，会影响下方文字的位置，但是必须指定)
Widget buildFlashLightSecondFragmentShowWidget() {
  double centerX = 900 / 2;
  double centerY = 600 / 2;
  double spaceX = 240;
  double spaceY = 160;
  List<double> buttonX = [centerX, centerX - spaceX, centerX + spaceX, centerX];
  List<double> buttonY = [centerY - spaceY, centerY, centerY, centerY + spaceY];
  double buttonRadio = 120;
  List<Color> buttonColors = [
    Color.fromARGB(255, 130, 0, 0),
    Color.fromARGB(255, 0, 130, 0),
    Color.fromARGB(255, 0, 0, 130),
    Color.fromARGB(255, 130, 130, 0),
  ];
  List<Color> buttonLightColors = [
    Color.fromARGB(255, 245, 0, 0),
    Color.fromARGB(255, 0, 245, 0),
    Color.fromARGB(255, 0, 123, 255),
    Color.fromARGB(255, 230, 230, 0),
  ];
  List<Widget> buttons = [];
  for (int i = 0; i < buttonX.length; i++) {
    ElevatedButton button = ElevatedButton(
      child: Container(),
      style: ButtonStyle(
        animationDuration: Duration(milliseconds: 10),
        overlayColor: MaterialStateProperty.all(buttonLightColors[i]),
        backgroundColor: MaterialStateProperty.all(
            i == 2 ? buttonLightColors[i] : buttonColors[i]),
        elevation: MaterialStateProperty.all(setWidth(10)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(setWidth(buttonRadio))),
        )),
      ),
    );
    Positioned positioned = Positioned(
      left: setWidth(buttonX[i] - buttonRadio / 2),
      top: setHeight(buttonY[i] - buttonRadio / 2),
      child: Container(
        width: setWidth(buttonRadio),
        height: setHeight(buttonRadio),
        child: button,
      ),
    );
    buttons.add(positioned);
  }
  return Container(
    alignment: Alignment.center,
    width: maxWidth,
    height: setHeight(1000),
    child: Container(
      margin: EdgeInsets.only(top: setHeight(400)),
      alignment: Alignment.center,
      width: setWidth(900),
      height: setHeight(600),
      child: Stack(
        children: buttons,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD), width: setWidth(1)),
          color: Color.fromARGB(255, 226, 229, 228),
          borderRadius: BorderRadius.all(Radius.circular(setWidth(25)))),
    ),
  );
}
