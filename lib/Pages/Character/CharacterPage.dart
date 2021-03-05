import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/Utils.dart';
import './CharacterTitle.dart';
import './CharacterMiddle.dart';
import './CharacterBottom.dart';



class CharacterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CharacterPageState();
  }
}

//页面组件
class CharacterPageState extends State<CharacterPage> {
  @override
  Widget buildPage(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: CharacterPageTitle(),
        ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 8,
          child: CharacterPageMiddle(),
        ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 1,
          child: CharacterPageBottom(),
        )
      ],
    );
  }
  //解决显示黑黄屏的问题
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: buildPage(context),
      ),
    );
  }
}