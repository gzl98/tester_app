import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';
import './MazeTitle.dart';
import './MazeMiddel.dart';
import './MazeBottom.dart';

class MazePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MazePageState();
  }
}

class _MazePageState extends State<MazePage> {
  Widget buildPage(){
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: MazePageTitle(),
        ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 8,
          child: MazePageMiddel(),
        ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 1,
          child: MazePageBottom(),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitDialog(context),
      child: Scaffold(
        body: buildPage(),
      ),
    );
  }
}
