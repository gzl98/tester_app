import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

double maxHeight, maxWidth;

String baseUrl = "http://39.96.37.82:8000/";

initialScreenUtil(BuildContext context) {
  ScreenUtil.instance = ScreenUtil(width: 2560, height: 1440)
    ..init(context);
  maxWidth = MediaQuery
      .of(context)
      .size
      .width;
  maxHeight = MediaQuery
      .of(context)
      .size
      .height;
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
      builder: (context) =>
          AlertDialog(
            title: Text('题目还没有答完，确定退出吗?'),
            actions: [
              FlatButton(
                child: Text('暂不'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () =>
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/showInfo", (router) => false),
              ),
            ],
          ));
}

Future<bool> showQuitProgramDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('确定退出程序吗?'),
            actions: [
              FlatButton(
                child: Text('暂不'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () async =>
                await SystemChannels.platform.invokeMethod(
                    'SystemNavigator.pop'),
              ),
            ],
          ));
}

Future<bool> showMessageDialog(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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

//获取网络图片 返回ui.Image
Future<ui.Image> getNetImage(String url, {width, height}) async {
  ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

//获取本地图片  返回ui.Image 需要传入BuildContext context
Future<ui.Image> getAssetImage2(String asset, BuildContext context,
    {width, height}) async {
  ByteData data = await DefaultAssetBundle.of(context).load(asset);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

//获取本地图片 返回ui.Image 不需要传入BuildContext context
Future<ui.Image> getAssetImage(String asset, {width, height}) async {
  ByteData data = await rootBundle.load(asset);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

//保存图片到相册
saveToPictures(pngBytes) async {
  //Map<PermissionGroup,PermissionStatus> permissions= await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  print('执行保存图片');
  var permission =
  PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
  print(permission.toString());
  if (permission == PermissionStatus.denied) {
    //无权限 显示设置
    //bool isOpened=await PermissionHandler().openAppSettings();
    print('无权限');
  }

  //添加保存照片到相册的权限
  PermissionHandler().requestPermissions(<PermissionGroup>[
    PermissionGroup.storage,
  ]);
  final result =
  await ImageGallerySaver.saveImage(pngBytes.buffer.asUint8List());
  print('保存图片');
  print(result);
  if (result) {
    print('保存成功');
    return result;
  } else {
    print('保存失败');
  }
}
