import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';
import './BMVTTitle.dart';
import './BMVTMiddel.dart';
import './BMVTBottom.dart';

class BMVTPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BMVTPageState();
  }
}

class _BMVTPageState extends State<BMVTPage> {
  Widget buildPage(){
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: BMVTPageTitle(),
        ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 8,
          child: BMVTPageMiddel(),
        ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 1,
          child: BMVTPageBottom(),
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
