import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tester_app/Utils/Utils.dart';

getUserInfoByToken(String token) async {
  //将User信息保存在Storage中
  Response response;
  Dio dio = Dio();
  try {
    response = await dio.get(baseUrl + "users/me",
        options: getAuthorizationOptions(token));
    if (response.data["mobilephone"] != null) {
      //  用户信息完整
      await StorageUtil.setIntItem("id", response.data["id"]);
      await StorageUtil.setStringItem("username", response.data["username"]);
      await StorageUtil.setStringItem("mobile", response.data["mobilephone"]);
      await StorageUtil.setStringItem("IDcard", response.data["IDcard"]);
      await StorageUtil.setStringItem("address", response.data["address"]);
      await StorageUtil.setIntItem("sex", int.parse(response.data["sex"]));
    } else {
      await StorageUtil.setIntItem("id", response.data["id"]);
      await StorageUtil.setStringItem("username", response.data["username"]);
    }
  } catch (e) {
    throw e;
  }
}

Options getAuthorizationOptions(String token) {
  return Options(headers: {
    "Authorization": "Bearer $token",
  });
}

setAnswer(int type,
    {int answerTimeDelta = 0,
    int score: -1,
    String answerText,
    String imagePath,
    String imageName,
    File audio,
    File video}) async {
  String token = await StorageUtil.getStringItem("token");
  int QNid = await StorageUtil.getIntItem("QNid");
  Dio dio = Dio();
  Response response;
  Map<String, dynamic> params = {
    // "QNid": 353,
    "QNid": QNid,
    "type": type,
    "score": score,
    "answer_timedelta": answerTimeDelta,
  };
  if (answerText != null)
    params.addAll({
      "answer_text": answerText,
    });

  FormData formData;
  if (imagePath != null) {
    var image = await MultipartFile.fromFile(imagePath, filename: imageName);
    formData = FormData.fromMap({
      "answer_img": image,
    });
  }
  try {
    response = await dio.post(baseUrl + "addnewSubject",
        queryParameters: params,
        data: formData,
        options: getAuthorizationOptions(token));
    print(response.data);
  } catch (e) {
    print(e);
    print(e.response.data);
  }
}
