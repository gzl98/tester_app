import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/EventBusType.dart';


//给出评分规则
const String characterRules="1.允许对照符号表填写\n2.禁止跳着填写，必须按顺序\n3.90s时间内完成，110分满分";
//中间题目展示组件

class CharacterPageMiddle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CharacterPageMiddleState();
  }
}

class CharacterPageMiddleState extends State<CharacterPageMiddle>{

  //静态初始化
  //10道测试题目
  List testnum=new List(10);
  List testIsEnable = new List<bool>.generate(10, (int i){
    return false;
  });
  int testScore=0;
  String text2 = "";
  //110道题目是否可见
  bool mainTestHidden=true;
  //110道题逐次阅读
  List mainIsEnable;
  //答题卡
  List mainanswer;
  //正式题目得分
  int mainScore=0;
  //记录每道题正误
  List mainCorrect;

  //动态初始化,重写函数
  @override
  void initState() {
    structureList(){
      List list_temp=new List<bool>.generate(15, (int i){
        return false;
      });
      return list_temp;
    }
    List tempIsEnable1 =structureList();
    List tempIsEnable2 =structureList();
    List tempIsEnable3 =structureList();
    List tempIsEnable4 =structureList();
    List tempIsEnable5 =structureList();
    List tempIsEnable6 =structureList();
    List tempIsEnable7 =structureList();
    List tempIsEnable8 =structureList();
    mainIsEnable=[tempIsEnable1,tempIsEnable2,tempIsEnable3,tempIsEnable4,tempIsEnable5,tempIsEnable6,tempIsEnable7,tempIsEnable8];

    answerList(){
      List answer_temp=new List<String>.generate(15, (int i){
        return "";
      });
      return answer_temp;
    }
    List answer_temp1=answerList();
    List answer_temp2=answerList();
    List answer_temp3=answerList();
    List answer_temp4=answerList();
    List answer_temp5=answerList();
    List answer_temp6=answerList();
    List answer_temp7=answerList();
    List answer_temp8=answerList();
    mainanswer=[answer_temp1,answer_temp2,answer_temp3,answer_temp4,answer_temp5,answer_temp6,answer_temp7,answer_temp8];

    CorrectList(){
      List list_temp=new List<bool>.generate(15, (int i){
        return false;
      });
      return list_temp;
    }
    List temp_Correct1 =CorrectList();
    List temp_Correct2 =CorrectList();
    List temp_Correct3 =CorrectList();
    List temp_Correct4 =CorrectList();
    List temp_Correct5 =CorrectList();
    List temp_Correct6 =CorrectList();
    List temp_Correct7 =CorrectList();
    List temp_Correct8 =CorrectList();
    mainCorrect=[temp_Correct1,temp_Correct2,temp_Correct3,temp_Correct4,temp_Correct5,temp_Correct6,temp_Correct7,temp_Correct8];
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child:Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child:Align(
                  child: Text("符号编码对照表",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
                  alignment:Alignment.bottomCenter,
                ),
              ),
              Expanded(
                flex:2,
                child:Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/example.png'),
                        fit: BoxFit.scaleDown,
                        alignment:Alignment.topCenter
                    ),
                  ),
                ),
              ),
              Expanded(
                flex:1,
                child: Text(""),
              ),
              Expanded(
                flex: 1,
                child:Align(
                  child: Text("符号编码测试",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
                  alignment:Alignment.bottomCenter,
                ),
              ),
              Expanded(
                flex:2,
                child:Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/test.png'),
                        fit: BoxFit.scaleDown,
                        alignment:Alignment.topCenter
                    ),
                  ),
                ),
              ),
              Expanded(
                flex:1,
                child: Text(""),
              ),
              Expanded(
                flex: 1,
                child:Align(
                  child: Text("答题框",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
                  alignment:Alignment.bottomCenter,
                ),
              ),
              Expanded(
                  flex:2,
                  child:Row(
                      children: <Widget>[
                        Expanded(
                          flex:2,
                          child:Text(""),
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                ///是否可编辑
                                enabled: true,
                                onChanged: (value){
                                  if(int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[1]=true;
                                    });
                                  }
                                  if(int.parse(value)==1){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },  //内容改变回调,
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[1],
                                onChanged: (value){
                                  if (int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[2]=true;
                                    });
                                  }
                                  if(int.parse(value)==5){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[2],
                                onChanged: (value){
                                  if (int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[3]=true;
                                    });
                                  }
                                  if(int.parse(value)==2){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[3],
                                onChanged: (value){
                                  if (int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[4]=true;
                                    });
                                  }
                                  if(int.parse(value)==1){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[4],
                                onChanged: (value){
                                  if (int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[5]=true;
                                    });
                                  }
                                  if(int.parse(value)==3){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[5],
                                onChanged: (value){
                                  if (int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[6]=true;
                                    });
                                  }
                                  if(int.parse(value)==6){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[6],
                                onChanged: (value){
                                  if (int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[7]=true;
                                    });
                                  }
                                  if(int.parse(value)==2){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[7],
                                onChanged: (value){
                                  if (int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[8]=true;
                                    });
                                  }
                                  if(int.parse(value)==4){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[8],
                                onChanged: (value){
                                  if (int.parse(value)>=0 && int.parse(value)<10){
                                    setState(() {
                                      testIsEnable[9]=true;
                                    });
                                  }
                                  if(int.parse(value)==1){
                                    setState(() {
                                      testScore+=1;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Align(
                              child:TextField(
                                enabled: testIsEnable[9],
                                onChanged: (value){
                                  if(int.parse(value)==6){
                                    setState(() {
                                      testScore+=1;
                                      print(testScore);
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,//键盘类型，数字键盘
                                style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                  LengthLimitingTextInputFormatter(1)//限制长度
                                ],
                              ),
                              alignment:Alignment.topCenter,
                            )
                        ),
                        Expanded(
                          flex:2,
                          child:Text(""),
                        ),
                      ]
                  )
              ),
              Expanded(
                  flex:2,
                  child:Row(
                      children: <Widget>[
                        Expanded(
                            flex:2,
                            child:Align(
                              child:RaisedButton(
                                color: Colors.white,
                                splashColor: Colors.indigoAccent,
                                onPressed:(){
                                  setState(() {
                                    text2 = "$testScore${testScore>=0 ? '' : '' }分";
                                  });
                                },
                                // 设置边框样式
                                shape: Border.all(
                                    color: Colors.grey, style: BorderStyle.solid, width: 2),
                                child: Text("测试结果分数：",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
                              ),
                              alignment: Alignment.bottomRight,
                            )
                        ),
                        Expanded(
                          flex:1,
                          child: Align(
                              child:Text(text2,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,decoration: TextDecoration.underline),),
                              alignment: Alignment.center
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                      ]
                  )
              ),
              Expanded(
                  flex:3,
                  child:Align(
                    child:RaisedButton(
                      color: Colors.white,
                      splashColor: Colors.pinkAccent,
                      onPressed:(){
                        setState(() {
                          mainTestHidden=false;
                          eventBus.fire(ChractStartEvent(10));
                        });
                      },
                      shape: Border.all(
                          color: Colors.black45, style: BorderStyle.solid, width: 2),
                      child: Text("~~~~~~~开始正式测试~~~~~~~",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
                    ),
                    alignment: Alignment.bottomCenter,
                  )
              ),
              Expanded(
                flex:5,
                child: Text(""),
              ),
            ],
          ),
        ),

        VerticalDivider(width: 3.0,color: Colors.blueGrey,thickness: 4.0,),

        Expanded(
          flex: 2,
          child: Offstage(
            offstage: mainTestHidden, //这里控制
            child: Column(
              children: <Widget>[
                Expanded(
                  flex:1,
                  child:Text(""),
                ),
                //第一行
                Expanded(
                    flex:1,
                    child:Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/bianma1.png'),
                                fit: BoxFit.scaleDown,
                                alignment:Alignment.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child:Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(""),
                              ),
                              Expanded(
                                  flex:1,
                                  child:Align(
                                    child:TextField(
                                      ///是否可编辑
                                      enabled: true,
                                      onChanged: (value){
                                        if(int.parse(value)>=0 && int.parse(value)<10){
                                          setState(() {
                                            mainIsEnable[0][1]=true;
                                          });
                                        }
                                        if(int.parse(value)==2){
                                          setState(() {
                                            mainScore+=1;
                                            mainCorrect[0][0]=true;
                                          });
                                        }
                                        setState(() {
                                          mainanswer[0][0]=value;
                                        });
                                      },  //内容改变回调,
                                      keyboardType: TextInputType.number,//键盘类型，数字键盘
                                      style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(1),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        // ignore: deprecated_member_use
                                        WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                        LengthLimitingTextInputFormatter(1)//限制长度
                                      ],
                                    ),
                                    alignment:Alignment.center,
                                  )
                              ),
                              Expanded(
                                  flex:1,
                                  child:Align(
                                    child:TextField(
                                      enabled: mainIsEnable[0][1],
                                      onChanged: (value){
                                        if(int.parse(value)>=0 && int.parse(value)<10){
                                          setState(() {
                                            mainIsEnable[0][2]=true;
                                          });
                                        }
                                        if(int.parse(value)==1){
                                          setState(() {
                                            mainScore+=1;
                                            mainCorrect[0][1]=true;
                                          });
                                        }
                                        setState(() {
                                          mainanswer[0][1]=value;
                                        });
                                      },  //内容改变回调,
                                      keyboardType: TextInputType.number,//键盘类型，数字键盘
                                      style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(1),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        // ignore: deprecated_member_use
                                        WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                        LengthLimitingTextInputFormatter(1)//限制长度
                                      ],
                                    ),
                                    alignment:Alignment.center,
                                  )
                              ),
                              Expanded(
                                  flex:1,
                                  child:Align(
                                    child:TextField(
                                      enabled: mainIsEnable[0][2],
                                      onChanged: (value){
                                        if(int.parse(value)>=0 && int.parse(value)<10){
                                          setState(() {
                                            mainIsEnable[0][3]=true;
                                          });
                                        }
                                        if(int.parse(value)==6){
                                          setState(() {
                                            mainScore+=1;
                                            mainCorrect[0][2]=true;
                                          });
                                        }
                                        setState(() {
                                          mainanswer[0][2]=value;
                                        });
                                      },  //内容改变回调,
                                      keyboardType: TextInputType.number,//键盘类型，数字键盘
                                      style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(1),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        // ignore: deprecated_member_use
                                        WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                        LengthLimitingTextInputFormatter(1)//限制长度
                                      ],
                                    ),
                                    alignment:Alignment.center,
                                  )
                              ),
                              Expanded(
                                  flex:1,
                                  child:Align(
                                    child:TextField(
                                      enabled: mainIsEnable[0][3],
                                      onChanged: (value){
                                        if(int.parse(value)>=0 && int.parse(value)<10){
                                          setState(() {
                                            mainIsEnable[0][4]=true;
                                          });
                                        }
                                        if(int.parse(value)==1){
                                          setState(() {
                                            mainScore+=1;
                                            mainCorrect[0][3]=true;
                                          });
                                        }
                                        setState(() {
                                          mainanswer[0][3]=value;
                                        });
                                      },  //内容改变回调,
                                      keyboardType: TextInputType.number,//键盘类型，数字键盘
                                      style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(1),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        // ignore: deprecated_member_use
                                        WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                        LengthLimitingTextInputFormatter(1)//限制长度
                                      ],
                                    ),
                                    alignment:Alignment.center,
                                  )
                              ),
                              Expanded(
                                  flex:1,
                                  child:Align(
                                    child:TextField(
                                      enabled: mainIsEnable[0][4],
                                      onChanged: (value){
                                        if(int.parse(value)>=0 && int.parse(value)<10){
                                          setState(() {
                                            mainIsEnable[1][0]=true;
                                          });
                                        }
                                        if(int.parse(value)==2){
                                          setState(() {
                                            mainScore+=1;
                                            mainCorrect[0][4]=true;
                                          });
                                        }
                                        setState(() {
                                          mainanswer[0][4]=value;
                                        });
                                      },  //内容改变回调,
                                      keyboardType: TextInputType.number,//键盘类型，数字键盘
                                      style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(1),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        // ignore: deprecated_member_use
                                        WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                        LengthLimitingTextInputFormatter(1)//限制长度
                                      ],
                                    ),
                                    alignment:Alignment.center,
                                  )
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(""),
                              ),
                            ],
                          ) ,
                        )

                      ],
                    )
                ),
                //第二行
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex:30,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma2.png'),
                              fit: BoxFit.scaleDown,
                              alignment:Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:Text("") ,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][0],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][1]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][0]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][0]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][1],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][2]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][1]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][1]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][2],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][3]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][2]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][2]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][3],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][4]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][3]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][3]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][4],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][5]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][4]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][4]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][5],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][6]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][5]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][5]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][6],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][7]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][6]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][6]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][7],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][8]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][7]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][7]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][8],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][9]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][8]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][8]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][9],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][10]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][9]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][9]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][10],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][11]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][10]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][10]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][11],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][12]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][11]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][11]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][12],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][13]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][12]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][12]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][13],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[1][14]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][13]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][13]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[1][14],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][0]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[1][14]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[1][14]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第三行
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex:30,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma3.png'),
                              fit: BoxFit.scaleDown,
                              alignment:Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:Text("") ,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][0],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][1]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][0]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][0]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][1],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][2]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][1]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][1]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][2],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][3]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][2]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][2]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][3],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][4]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][3]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][3]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][4],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][5]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][4]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][4]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][5],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][6]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][5]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][5]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][6],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][7]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][6]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][6]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][7],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][8]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][7]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][7]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][8],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][9]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][8]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][8]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][9],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][10]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][9]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][9]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][10],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][11]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][10]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][10]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][11],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][12]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][11]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][11]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][12],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][13]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][12]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][12]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][13],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[2][14]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][13]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][13]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[2][14],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][0]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[2][14]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[2][14]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第四行
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex:30,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma4.png'),
                              fit: BoxFit.scaleDown,
                              alignment:Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:Text("") ,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][0],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][1]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][0]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][0]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][1],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][2]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][1]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][1]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][2],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][3]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][2]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][2]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][3],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][4]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][3]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][3]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][4],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][5]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][4]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][4]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][5],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][6]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][5]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][5]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][6],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][7]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][6]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][6]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][7],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][8]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][7]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][7]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][8],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][9]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][8]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][8]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][9],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][10]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][9]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][9]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][10],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][11]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][10]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][10]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][11],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][12]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][11]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][11]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][12],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][13]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][12]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][12]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][13],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[3][14]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][13]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][13]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[3][14],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][0]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[3][14]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[3][14]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第五行
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex:30,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma5.png'),
                              fit: BoxFit.scaleDown,
                              alignment:Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:Text("") ,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][0],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][1]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][0]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][0]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][1],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][2]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][1]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][1]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][2],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][3]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][2]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][2]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][3],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][4]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][3]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][3]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][4],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][5]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][4]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][4]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][5],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][6]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][5]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][5]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][6],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][7]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][6]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][6]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][7],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][8]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][7]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][7]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][8],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][9]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][8]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][8]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][9],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][10]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][9]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][9]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][10],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][11]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][10]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][10]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][11],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][12]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][11]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][11]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][12],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][13]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][12]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][12]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][13],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[4][14]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][13]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][13]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[4][14],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][0]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[4][14]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[4][14]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第六行
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex:30,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma6.png'),
                              fit: BoxFit.scaleDown,
                              alignment:Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:Text("") ,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][0],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][1]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][0]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][0]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][1],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][2]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][1]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][1]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][2],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][3]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][2]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][2]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][3],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][4]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][3]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][3]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][4],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][5]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][4]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][4]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][5],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][6]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][5]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][5]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][6],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][7]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][6]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][6]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][7],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][8]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][7]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][7]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][8],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][9]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][8]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][8]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][9],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][10]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][9]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][9]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][10],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][11]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][10]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][10]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][11],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][12]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][11]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][11]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][12],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][13]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][12]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][12]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][13],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[5][14]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][13]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][13]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[5][14],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][0]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[5][14]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[5][14]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第七行
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex:30,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma7.png'),
                              fit: BoxFit.scaleDown,
                              alignment:Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:Text("") ,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][0],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][1]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][0]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][0]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][1],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][2]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][1]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][1]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][2],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][3]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][2]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][2]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][3],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][4]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][3]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][3]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][4],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][5]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][4]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][4]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][5],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][6]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][5]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][5]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][6],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][7]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][6]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][6]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][7],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][8]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][7]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][7]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][8],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][9]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][8]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][8]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][9],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][10]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][9]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][9]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][10],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][11]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][10]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][10]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][11],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][12]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][11]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][11]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][12],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][13]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][12]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][12]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][13],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[6][14]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][13]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][13]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[6][14],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][0]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[6][14]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[6][14]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                //第八行
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex:30,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/bianma8.png'),
                              fit: BoxFit.scaleDown,
                              alignment:Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:Text("") ,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][0],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][1]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][0]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][0]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][1],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][2]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][1]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][1]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][2],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][3]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][2]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][2]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][3],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][4]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][3]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][3]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][4],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][5]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][4]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][4]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][5],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][6]=true;
                                  });
                                }
                                if(int.parse(value)==2){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][5]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][5]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][6],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][7]=true;
                                  });
                                }
                                if(int.parse(value)==1){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][6]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][6]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][7],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][8]=true;
                                  });
                                }
                                if(int.parse(value)==6){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][7]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][7]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][8],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][9]=true;
                                  });
                                }
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][8]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][8]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][9],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][10]=true;
                                  });
                                }
                                if(int.parse(value)==7){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][9]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][9]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][10],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][11]=true;
                                  });
                                }
                                if(int.parse(value)==3){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][10]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][10]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][11],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][12]=true;
                                  });
                                }
                                if(int.parse(value)==5){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][11]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][11]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][12],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][13]=true;
                                  });
                                }
                                if(int.parse(value)==4){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][12]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][12]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][13],
                              onChanged: (value){
                                if(int.parse(value)>=0 && int.parse(value)<10){
                                  setState(() {
                                    mainIsEnable[7][14]=true;
                                  });
                                }
                                if(int.parse(value)==8){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][13]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][13]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                          flex:2,
                          child:Align(
                            child:TextField(
                              enabled: mainIsEnable[7][14],
                              onChanged: (value){
                                if(int.parse(value)==9){
                                  setState(() {
                                    mainScore+=1;
                                    mainCorrect[7][14]=true;
                                  });
                                }
                                setState(() {
                                  mainanswer[7][14]=value;
                                });
                              },  //内容改变回调,
                              keyboardType: TextInputType.number,//键盘类型，数字键盘
                              style: TextStyle(fontSize:20.0, color: Colors.black,fontWeight: FontWeight.w600),//输入文字样式
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,//只输入数字
                                LengthLimitingTextInputFormatter(1)//限制长度
                              ],
                            ),
                            alignment:Alignment.center,
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex:1,
                  child:Text(""),
                ),

              ],
            ),
          ),
        ),


        VerticalDivider(width: 3.0,color: Colors.blueGrey,thickness: 4.0,),
        Expanded(
          flex: 1,
          child:Container(
            child: RightInfoColumn(),
          ),
        ),
      ],
    );
  }
}


//右边信息栏
class RightInfoColumn extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_TesterInfoState("XXX","100s",characterRules,"未完成");

}

class _TesterInfoState extends State<RightInfoColumn>{
  var personName="";
  var testTime="";
  var scoreRules="";
  var isFinish="未完成";
  var _titleStyle=TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.w600
  );
  var _subTitleStyle=TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600
  );
  var _normalStyle=TextStyle(
    fontSize: 20.0,
  );

  _TesterInfoState(this.personName,this.testTime,this.scoreRules,this.isFinish){
    print(this.scoreRules);
  }

  @override
  Widget build(BuildContext context) {
    //每列宽度
    var paddingEdage=EdgeInsets.all(6);
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.start ,
      children: <Widget>[
        Container(
          color: Colors.black12,
          child:Center(
            child: Text("测试者信息",style: _titleStyle),
          ) ,
        ),

        Divider(height: 3.0,color: Colors.blueGrey,thickness:1,),
        Container(
          padding: paddingEdage,
          child:Row(
              children:<Widget>[
                Text("测试者姓名：",style: _subTitleStyle),
                Text(this.personName,style: _normalStyle,)
              ]
          ),
        ),
        Container(
          padding: paddingEdage,
          child:Row(
              children:<Widget>[
                Text("测试者是否完成：",style: _subTitleStyle),
                Text(this.isFinish,style: _normalStyle,)
              ]
          ),
        ),
        Container(
          padding: paddingEdage,
          child:Row(
              children:<Widget>[
                Text("测试者用时：",style: _subTitleStyle),
                Text(this.testTime,style: _normalStyle)
              ]
          ),
        ),
        Container(
          padding: paddingEdage,
          child: Text("评分规则",style: _subTitleStyle),
        ),
        Container(
          padding: paddingEdage,
          child: Text(this.scoreRules,style: _normalStyle),
        ),
      ],
    );
  }
}