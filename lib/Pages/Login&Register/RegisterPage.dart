import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tester_app/Pages/Login&Register/CompleteInfoPage.dart';

import '../../Utils/Utils.dart';

class RegisterPage extends StatefulWidget {
  static const routerName = "/RegisterPage";

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  bool _isObscure2 = true;
  bool _isRegistering = false;
  Color _eyeColor;
  Color _eyeColor2;

  String _username;
  String _password;
  String _registerText = "注  册";

  final _formKey = GlobalKey<FormState>();
  final _formUsernameKey = GlobalKey<FormFieldState>();
  final _formPasswordKey = GlobalKey<FormFieldState>();
  final _formPassword2Key = GlobalKey<FormFieldState>();

  TextEditingController _controllerPassword = TextEditingController();

  //焦点
  FocusNode _focusNodeUsername = FocusNode();
  FocusNode _focusNodePassWord = FocusNode();
  FocusNode _focusNodePassWord2 = FocusNode();

  @override
  void initState() {
    super.initState();
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
    _focusNodePassWord2.addListener(() {
      if (!_focusNodePassWord2.hasFocus) {
        _formPassword2Key.currentState.validate();
      }
    });
  }

  @override
  void dispose() {
    _controllerPassword.dispose();
    super.dispose();
  }

  Widget sizeBox = SizedBox(
    height: setHeight(30),
    width: setWidth(30),
  );

  TextStyle fontStyle =
  TextStyle(fontSize: setSp(50), fontWeight: FontWeight.bold);
  TextStyle hintStyle = TextStyle(fontSize: setSp(35));

  Widget buildUsernameText(context) {
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

  Widget buildPasswordText(context) {
    return TextFormField(
        key: _formPasswordKey,
        focusNode: _focusNodePassWord,
        onSaved: (value) => _password = value,
        controller: _controllerPassword,
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

  Widget buildPasswordText2(context) {
    return TextFormField(
        key: _formPassword2Key,
        focusNode: _focusNodePassWord2,
        style: fontStyle,
        obscureText: _isObscure2,
        validator: (value) {
          if (value.isEmpty) {
            return '密码不能为空';
          }
          if (value != _controllerPassword.text) {
            return '密码不一致';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: '确认密码',
          hintText: '密码为6-20位，需以字母开头',
          hintStyle: hintStyle,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _eyeColor2,
            ),
            onPressed: () {
              setState(() {
                _isObscure2 = !_isObscure2;
                _eyeColor2 = _isObscure2
                    ? Colors.grey
                    : Theme.of(context).iconTheme.color;
              });
            },
          ),
        ));
  }

  Widget buildRegisterButton(context) {
    return Align(
      child: SizedBox(
        height: setHeight(105),
        width: setWidth(800),
        // ignore: deprecated_member_use
        child: RaisedButton(
          child: Text(
            _registerText,
            style: Theme.of(context).primaryTextTheme.headline4,
          ),
          color: Colors.blueGrey,
          onPressed: () {
            _focusNodeUsername.unfocus();
            _focusNodePassWord.unfocus();
            _focusNodePassWord2.unfocus();
            if (_isRegistering) {
              return;
            }
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              setState(() {
                _isRegistering = true;
                _registerText = "正 在 注 册...";
              });
              _onRegister();
            }
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(12)))),
        ),
      ),
    );
  }

  Widget buildToLogin(context) {
    return Align(
      alignment: Alignment.centerRight,
      // ignore: deprecated_member_use
      child: FlatButton(
        child: Text(
          '登录',
          style: TextStyle(fontSize: setSp(46), color: Colors.grey[600]),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitDialog(context),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            _focusNodeUsername.unfocus();
            _focusNodePassWord.unfocus();
            _focusNodePassWord2.unfocus();
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
                            offset: Offset(0.0, 8.0), //阴影xy轴偏移量
                            blurRadius: 15.0, //阴影模糊程度
                            spreadRadius: 1.0 //阴影扩散程度
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
                              buildUsernameText(context),
                              sizeBox,
                              buildPasswordText(context),
                              sizeBox,
                              buildPasswordText2(context),
                              sizeBox,
                              sizeBox,
                              buildRegisterButton(context),
                              buildToLogin(context),
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

  void _onRegister() async {
    Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(baseUrl + "registerwithtoken",
          data: FormData.fromMap({
            'username': _username,
            'password': _password,
            'Form_role': 1,
          }));
      if (response.statusCode == HttpStatus.ok) {
        setState(() {
          _isRegistering = false;
          _registerText = "注  册  成  功";
        });
        Map userinfo = response.data["userinfo"];
        await StorageUtil.setIntItem("id", userinfo["id"]);
        await StorageUtil.setStringItem("username", userinfo["username"]);
        await StorageUtil.setStringItem(
            "token", response.data["token"]["access_token"]);
        Navigator.pushNamedAndRemoveUntil(
            context, CompleteInfoPage.routerName, (router) => false);
      }
    } catch (e) {
      print(e);
      print(response);
      //TODO:显示错误信息
      setState(() {
        _isRegistering = false;
        _registerText = "注  册";
      });
      showMessageDialog(context, "注册失败!$response");
    }
  }
}
