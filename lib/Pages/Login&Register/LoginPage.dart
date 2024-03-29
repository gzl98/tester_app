import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Utils/HttpUtils.dart';
import 'package:tester_app/Utils/Utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool _isLogin = false;
  Color _eyeColor;

  String _username;
  String _password;
  String _loginText = "登  录";

  final _formKey = GlobalKey<FormState>();
  final _formUsernameKey = GlobalKey<FormFieldState>();
  final _formPasswordKey = GlobalKey<FormFieldState>();

  //焦点
  FocusNode _focusNodeUsername = FocusNode();
  FocusNode _focusNodePassWord = FocusNode();

  @override
  void initState() {
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _focusNodeUsername.addListener(() {
      if (!_focusNodeUsername.hasFocus) {
        _formUsernameKey.currentState.validate();
      }
    });
    _focusNodePassWord.addListener(() {
      if (!_focusNodePassWord.hasFocus) {
        _formPasswordKey.currentState.validate();
      }
    });
    super.initState();
  }

  Widget sizeBox = SizedBox(
    width: setWidth(30),
    height: setHeight(30),
  );

  TextStyle fontStyle =
      TextStyle(fontSize: setSp(50), fontWeight: FontWeight.bold);
  TextStyle hintStyle = TextStyle(fontSize: setSp(35));

  Widget buildUsernameText() {
    return TextFormField(
      key: _formUsernameKey,
      focusNode: _focusNodeUsername,
      onSaved: (value) => _username = value,
      style: fontStyle,
      decoration: InputDecoration(
        labelText: '用户名',
        hintText: '用户名为6-20位，只能包含字母和数字(需以字母开头)',
        hintStyle: hintStyle,
      ),
      validator: (value) {
        RegExp reg = RegExp(r'^[a-zA-Z][a-zA-Z0-9]{5,19}$');
        if (value.isEmpty) {
          return '用户名不能为空';
        }
        if (!reg.hasMatch(value)) {
          return '用户名格式错误';
        }
        return null;
      },
    );
  }

  Widget buildPasswordText() {
    return TextFormField(
        key: _formPasswordKey,
        focusNode: _focusNodePassWord,
        onSaved: (value) => _password = value,
        style: fontStyle,
        obscureText: _isObscure,
        validator: (value) {
          RegExp reg = RegExp(r'^[a-zA-Z]\w{5,19}$');
          if (value.isEmpty) {
            return '密码不能为空';
          }
          if (!reg.hasMatch(value)) {
            return '格式错误，密码为6-20位，需以字母开头';
          }
          _password = value;
          return null;
        },
        decoration: InputDecoration(
          labelText: '密码',
          hintText: '密码为6-20位，需以字母开头',
          hintStyle: hintStyle,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _eyeColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                _eyeColor = _isObscure
                    ? Colors.grey
                    : Theme.of(context).iconTheme.color;
              });
            },
          ),
        ));
  }

  Widget buildLoginButton() {
    return Align(
      child: SizedBox(
        height: setHeight(105),
        width: setWidth(800),
        child: RaisedButton(
          child: Text(
            _loginText,
            style: Theme.of(context).primaryTextTheme.headline4,
          ),
          color: Colors.blueGrey,
          onPressed: () {
            _focusNodeUsername.unfocus();
            _focusNodePassWord.unfocus();
            if (_isLogin) {
              return;
            }
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              setState(() {
                _isLogin = true;
                _loginText = "正 在 登 陆...";
              });
              _onLogin();
            }
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(12)))),
        ),
      ),
    );
  }

  Widget buildToRegister() {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text(
          '注册',
          style: TextStyle(fontSize: setSp(46), color: Colors.grey[600]),
        ),
        onPressed: () {
          // print("点击了空白区域");
          Navigator.pushNamed(context, "/register");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            _focusNodeUsername.unfocus();
            _focusNodePassWord.unfocus();
          },
          child: Container(
            color: Colors.white54,
            width: maxWidth,
            height: maxHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: setWidth(650),
                  height: setWidth(650),
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage('images/logo.jpg')),
                      border: Border.all(color: Colors.black26),
                      borderRadius:
                          BorderRadius.all(Radius.circular(setWidth(150))),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(setWidth(5), setWidth(5)), //阴影xy轴偏移量
                            blurRadius: setWidth(22), //阴影模糊程度
                            spreadRadius: setWidth(1.5) //阴影扩散程度
                            )
                      ]),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // color: Colors.red,
                      width: setWidth(800),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              sizeBox,
                              sizeBox,
                              buildUsernameText(),
                              sizeBox,
                              buildPasswordText(),
                              sizeBox,
                              sizeBox,
                              buildLoginButton(),
                              buildToRegister(),
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    Response response;
    Dio dio = Dio();
    try {
      response = await dio.post(baseUrl + "login",
          data: FormData.fromMap({
            'username': _username,
            'password': _password,
            'Form_role': 1,
          }));
      if (response.statusCode == HttpStatus.ok) {
        await StorageUtil.setStringItem("token", response.data['access_token']);
        setState(() {
          _isLogin = false;
          _loginText = "登  录  成  功";
        });
      }
    } catch (e) {
      //TODO:显示错误信息
      print(e);
      setState(() {
        _isLogin = false;
        _loginText = "登  录  失  败";
      });
    }
    try {
      await getUserInfoByToken(response.data['access_token']);
      String mobile = await StorageUtil.getStringItem("mobile");
      if (mobile != null) {
        //  用户信息完整
        Navigator.pushNamedAndRemoveUntil(
            context, "/showInfo", (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, "/completeInfo", (route) => false);
      }
    } catch (e) {
      print(e);
      StorageUtil.clear();
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
  }
}
