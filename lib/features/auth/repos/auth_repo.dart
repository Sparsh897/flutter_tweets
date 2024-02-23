import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_tweet/core/api_services/config.dart';
import 'package:flutter_tweet/features/auth/models/user_model.dart';

class Authrepo {
  static Future<UserModel?> getuserRepo(String uid) async {
    try {
      Dio dio = Dio();
      final response = await dio.get(Config.serverUrl + "user/$uid");
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        UserModel userModel = UserModel.fromMap(response.data);
        return userModel;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString() as num);
      return null;
    }
  }

  static Future<bool> createUserRepo(UserModel usermodel) async {
    Dio dio = Dio();
    final response = await dio.post(Config.serverUrl + "user",data: usermodel.toMap());
    if (response.statusCode! >= 200 && response.statusCode! <= 300) {
      return true;
    } else {
      return false;
    }
  }
}
