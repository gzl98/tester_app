import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Utils/Utils.dart';

class CompleteInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompleteInfoPageState();
  }
}

class _CompleteInfoPageState extends State<CompleteInfoPage> {
  int sexValue = 0;

  bool _isSubmitting = false;
  Color _sexManColor = Colors.lightBlueAccent;
  Color _sexWomanColor = Colors.transparent;

  String _mobile;
  String _IDCard;
  String _address;
  String _completeText = "提  交";

  final _formKey = GlobalKey<FormState>();
  final _formMobileKey = GlobalKey<FormFieldState>();
  final _formIDCardKey = GlobalKey<FormFieldState>();
  final _formAddressKey = GlobalKey<FormFieldState>();

  //焦点
  FocusNode _focusNodeMobile = FocusNode();
  FocusNode _focusNodeIDCard = FocusNode();
  FocusNode _focusNodeAddress = FocusNode();

  @override
  void initState() {
    super.initState();
    // 强制横屏
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _focusNodeMobile.addListener(() {
      if (!_focusNodeMobile.hasFocus) {
        _formMobileKey.currentState.validate();
      }
    });
    _focusNodeIDCard.addListener(() {
      if (!_focusNodeIDCard.hasFocus) {
        _formIDCardKey.currentState.validate();
      }
    });
    _focusNodeAddress.addListener(() {
      if (!_focusNodeAddress.hasFocus) {
        _formAddressKey.currentState.validate();
      }
    });
    sexManStyle = sexStyleChecked;
    sexWomanStyle = sexStyleUnChecked;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget sizeBox = SizedBox(
    height: setHeight(30),
    width: setWidth(30),
  );

  TextStyle fontStyle =
      TextStyle(fontSize: setSp(50), fontWeight: FontWeight.bold);
  TextStyle hintStyle = TextStyle(fontSize: setSp(35));
  TextStyle sexStyleChecked = TextStyle(
      fontSize: setSp(45), fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle sexStyleUnChecked =
      TextStyle(fontSize: setSp(45), fontWeight: FontWeight.bold);
  TextStyle sexManStyle, sexWomanStyle;

  Widget buildMobileText(context) {
    return TextFormField(
      key: _formMobileKey,
      focusNode: _focusNodeMobile,
      onSaved: (value) => _mobile = value,
      style: fontStyle,
      decoration: InputDecoration(
        labelText: '手机号',
      ),
      validator: (value) {
        RegExp reg = RegExp(r'^1[3-9]\d{9}$');
        if (value.isEmpty) {
          return '手机号不能为空';
        }
        if (!reg.hasMatch(value)) {
          return '手机号格式错误';
        }
        return null;
      },
    );
  }

  Widget buildSexRadioButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "性别: ",
          style: TextStyle(
            fontSize: setSp(50),
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(155, 0, 0, 0),
          ),
        ),
        FlatButton(
          minWidth: setWidth(300),
          color: _sexManColor,
          child: Text(
            "男",
            style: sexManStyle,
          ),
          onPressed: () {
            setState(() {
              _sexManColor = Colors.lightBlueAccent;
              _sexWomanColor = Colors.transparent;
              sexManStyle = sexStyleChecked;
              sexWomanStyle = sexStyleUnChecked;
              sexValue = 0;
            });
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(15)))),
        ),
        FlatButton(
          minWidth: setWidth(300),
          color: _sexWomanColor,
          child: Text(
            "女",
            style: sexWomanStyle,
          ),
          onPressed: () {
            setState(() {
              _sexManColor = Colors.transparent;
              _sexWomanColor = Colors.pink[300];
              sexManStyle = sexStyleUnChecked;
              sexWomanStyle = sexStyleChecked;
              sexValue = 1;
            });
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(15)))),
        ),
      ],
    );
  }

  Widget buildIDCardText(context) {
    return TextFormField(
      key: _formIDCardKey,
      focusNode: _focusNodeIDCard,
      onSaved: (value) => _IDCard = value,
      style: fontStyle,
      decoration: InputDecoration(
        labelText: '身份证号码',
      ),
      validator: (value) {
        RegExp reg = RegExp(
            r'^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$');
        if (value.isEmpty) {
          return '身份证号码不能为空';
        }
        if (!reg.hasMatch(value)) {
          return '身份证号码格式错误';
        }
        _IDCard = value;
        return null;
      },
    );
  }

  Widget buildAddressText(context) {
    return TextFormField(
      key: _formAddressKey,
      focusNode: _focusNodeAddress,
      onSaved: (value) => _address = value,
      style: fontStyle,
      decoration: InputDecoration(
        labelText: '家庭住址',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return '家庭住址不能为空';
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton(context) {
    return Align(
      child: SizedBox(
        height: setHeight(110),
        width: setWidth(1930),
        child: RaisedButton(
          child: Text(
            _completeText,
            style: Theme.of(context).primaryTextTheme.headline4,
          ),
          color: Colors.blueGrey,
          onPressed: () {
            _focusNodeMobile.unfocus();
            _focusNodeIDCard.unfocus();
            _focusNodeAddress.unfocus();
            if (_isSubmitting) {
              return;
            }
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              setState(() {
                _isSubmitting = true;
                _completeText = "正 在 提 交...";
              });
              _onSubmit();
            }
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setWidth(12)))),
        ),
      ),
    );
  }

  Widget buildForm(context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: setWidth(800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildMobileText(context),
                sizeBox,
                buildIDCardText(context),
              ],
            ),
          ),
          Container(
            width: setWidth(800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                sizeBox,
                sizeBox,
                buildSexRadioButton(context),
                sizeBox,
                buildAddressText(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showQuitProgramDialog(context),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            _focusNodeMobile.unfocus();
            _focusNodeIDCard.unfocus();
            _focusNodeAddress.unfocus();
          },
          child: Container(
            color: Colors.white54,
            width: maxWidth,
            height: maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "请完善您的用户信息",
                  style: TextStyle(
                    fontSize: setSp(70),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sizeBox,
                sizeBox,
                Container(
                  // color: Colors.red,
                  width: maxWidth,
                  child: buildForm(context),
                ),
                sizeBox,
                sizeBox,
                sizeBox,
                buildSubmitButton(context),
                sizeBox,
                sizeBox,
                sizeBox,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() async {
    String _username = await StorageUtil.getStringItem("username");
    String _token = await StorageUtil.getStringItem("token");
    Dio dio = Dio();
    Response response;
    try {
      response = await dio.put(baseUrl + "updateuser",
          data: FormData.fromMap({
            'username': _username,
            'role': 1,
            'sex': sexValue,
            'mobilephone': _mobile,
            'IDcard': _IDCard,
            'address': _address,
          }),
          options: Options(headers: {
            "Authorization": "Bearer $_token",
          }));
      if (response.statusCode == HttpStatus.ok) {
        setState(() {
          _isSubmitting = false;
          _completeText = "提  交  成  功";
        });
        await StorageUtil.setIntItem("sex", sexValue);
        await StorageUtil.setStringItem("mobilephone", _mobile);
        await StorageUtil.setStringItem("IDcard", _IDCard);
        await StorageUtil.setStringItem("adress", _address);
        Navigator.pushNamedAndRemoveUntil(
            context, "/showInfo", (router) => false);
      }
    } catch (e) {
      print(e);
      print(response);
      //TODO:显示错误信息
      setState(() {
        _isSubmitting = false;
        _completeText = "提  交";
      });
      showMessageDialog(context, "提交失败!$response");
    }
  }
}
