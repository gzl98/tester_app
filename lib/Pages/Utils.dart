import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

double maxHeight, maxWidth;

String baseUrl = "http://39.96.37.82:8000/";

initialScreenUtil(BuildContext context) {
  ScreenUtil.instance = ScreenUtil(width: 2560, height: 1440)..init(context);
  maxWidth = MediaQuery.of(context).size.width;
  maxHeight = MediaQuery.of(context).size.height;
}

setWidth(double width) {
  return ScreenUtil.getInstance().setWidth(width);
}

setHeight(double height) {
  return ScreenUtil.getInstance().setHeight(height);
}

setSp(double sp) {
  return ScreenUtil.getInstance().setSp(sp);
}

Future<bool> showQuitDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('题目还没有答完，确定退出程序吗?'),
            actions: [
              FlatButton(
                child: Text('暂不'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ));
}

Future<bool> showMessageDialog(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(message),
            actions: [
              FlatButton(
                child: Text('确定'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ));
}

class StorageUtil {
  // 设置布尔的值
  static setBoolItem(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // 设置double的值
  static setDoubleItem(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  // 设置int的值
  static setIntItem(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  // 设置Sting的值
  static setStringItem(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // 设置StringList
  static setStringListItem(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  // 获取返回为bool的内容
  static getBoolItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(key);
    return value;
  }

  // 获取返回为double的内容
  static getDoubleItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    double value = prefs.getDouble(key);
    return value;
  }

  // 获取返回为int的内容
  static getIntItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(key);
    return value;
  }

  // 获取返回为String的内容
  static getStringItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return value;
  }

  // 获取返回为StringList的内容
  static getStringListItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> value = prefs.getStringList(key);
    return value;
  }

  // 移除单个
  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  // 清空所有的
  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
