import 'package:dio/dio.dart';
import 'package:tester_app/Utils/Utils.dart';

Future getUserInfoByToken(String token) async {
  Response response;
  Dio dio = Dio();
  try {
    response = await dio.get(baseUrl + "users/me",
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }));
    if (response.data["mobilephone"] != null) {
      //  用户信息完整
      await StorageUtil.setIntItem("id", response.data["id"]);
      await StorageUtil.setStringItem("username", response.data["username"]);
      await StorageUtil.setStringItem("mobile", response.data["mobilephone"]);
      await StorageUtil.setStringItem("IDcard", response.data["IDcard"]);
      await StorageUtil.setStringItem("address", response.data["adress"]);
      await StorageUtil.setIntItem("sex", int.parse(response.data["sex"]));
    } else {
      await StorageUtil.setIntItem("id", response.data["id"]);
      await StorageUtil.setStringItem("username", response.data["username"]);
    }
  } catch (e) {
    throw e;
  }
}
