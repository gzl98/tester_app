import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tester_app/Pages/testNavPage/testNavPage.dart';

double maxHeight, maxWidth;

String baseUrl = "http://39.108.252.201:9000/";

class ScreenUtil {
  static ScreenUtil instance = new ScreenUtil();

  //设计稿的设备尺寸修改
  int width;
  int height;
  bool allowFontScaling;

  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _pixelRatio;
  static double _statusBarHeight;

  static double _bottomBarHeight;

  static double _textScaleFactor;

  ScreenUtil({
    this.width = 1080,
    this.height = 1920,
    this.allowFontScaling = false,
  });

  static ScreenUtil getInstance() {
    return instance;
  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData;

  ///每个逻辑像素的字体像素数，字体的缩放比例
  static double get textScaleFactory => _textScaleFactor;

  ///设备的像素密度
  static double get pixelRatio => _pixelRatio;

  ///当前设备宽度 dp
  static double get screenWidthDp => _screenWidth;

  ///当前设备高度 dp
  static double get screenHeightDp => _screenHeight;

  ///当前设备宽度 px
  static double get screenWidth => _screenWidth * _pixelRatio;

  ///当前设备高度 px
  static double get screenHeight => _screenHeight * _pixelRatio;

  ///状态栏高度 刘海屏会更高
  static double get statusBarHeight => _statusBarHeight * _pixelRatio;

  ///底部安全区距离
  static double get bottomBarHeight => _bottomBarHeight * _pixelRatio;

  ///实际的dp与设计稿px的比例
  get scaleWidth => _screenWidth / instance.width;

  get scaleHeight => _screenHeight / instance.height;

  ///根据设计稿的设备宽度适配
  ///高度也根据这个来做适配可以保证不变形
  setWidth(double width) => width * scaleWidth;

  /// 根据设计稿的设备高度适配
  /// 当发现设计稿中的一屏显示的与当前样式效果不符合时,
  /// 或者形状有差异时,高度适配建议使用此方法
  /// 高度适配主要针对想根据设计稿的一屏展示一样的效果
  setHeight(double height) => height * scaleHeight;

  ///字体大小适配方法
  ///@param fontSize 传入设计稿上字体的px ,
  ///@param allowFontScaling 控制字体是否要根据系统的“字体大小”辅助选项来进行缩放。默认值为true。
  ///@param allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is true.
  setSp(double fontSize) => allowFontScaling
      ? setWidth(fontSize)
      : setWidth(fontSize) / _textScaleFactor;
}

initialScreenUtil(BuildContext context) {
  ScreenUtil.instance = ScreenUtil(width: 2560, height: 1600)..init(context);
  maxWidth = MediaQuery.of(context).size.width;
  maxHeight = MediaQuery.of(context).size.height;

  print(maxWidth);
  print(maxHeight);
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
            title: Text('题目还没有答完，确定退出吗?'),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('暂不'),
                onPressed: () => Navigator.pop(context),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('确定'),
                // onPressed: () => Navigator.pop(context, true),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, TestNavPage.routerName, (router) => false),
              ),
            ],
          ));
}

Future<bool> showExitDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('确定退出程序吗?'),
            actions: [
              FlatButton(
                child: Text('暂不'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () => exit(0),
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
      PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
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
  final result = await ImageGallerySaver.save(pngBytes.buffer.asUint8List());
  print('保存图片');
  print(result);
  if (result) {
    print('保存成功');
    return result;
  } else {
    print('保存失败');
  }
}
