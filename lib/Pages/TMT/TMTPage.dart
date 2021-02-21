import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Utils/Utils.dart';
import './TMTTitle.dart';
import './TMTMiddel.dart';
import './TMTBottom.dart';

class TMTPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TMTPageState();
  }
}

class _TMTPageState extends State<TMTPage> {
  Widget buildPage(){
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TMTPageTitle(),
        ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 8,
          child: TMTPageMiddel(),
        ),
        Divider(height: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 1,
          child: TMTPageBottom(),
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
