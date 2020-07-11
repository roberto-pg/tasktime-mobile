import 'dart:async';
import 'package:dio/dio.dart';
import 'package:task/global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class User {
  String name;
  String email;
  String password;

  User({this.name, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'], email: json['email'], password: json['password']);
  }
}

Future<Map> getAuthentication(params) async {
  Dio dio = new Dio();
  Response response;
  var chave, nome, id;
  try {
    response = await dio.post('$URL_AUTHENTICATE', data: params);
    chave = response.data["token"];
    nome = response.data["user"]["name"];
    id = response.data["user"]['_id'];
    await storage.write(key: 'nameUser', value: nome);
    await storage.write(key: 'jwt', value: chave);
    await storage.write(key: 'idUser', value: id);
  } on DioError catch (e) {
    if (e.response != null) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      print(e.request);
      print(e.message);
    }
  }
  return null;
}

Future<Map> getRegistration(params) async {
  Dio dio = new Dio();
  try {
    await dio.post('$URL_REGISTER', data: params);

    storage.write(key: 'erroRegister', value: "Sem erro");
  } on DioError catch (e) {
    if (e.response != null) {
      var msg = (e.response.data['error']);
      await storage.write(key: 'erroRegister', value: msg);

      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      print(e.request);
      print(e.message);
    }
  }
  return null;
}

Future<Map> getTokenPassword(params) async {
  Dio dio = new Dio();
  try {
    await dio.post('$URL_FORGOT_PASSWORD', data: params);

    storage.write(key: 'erroUser', value: "Sem erro");
  } on DioError catch (e) {
    if (e.response != null) {
      var msg = (e.response.data['error']);
      await storage.write(key: 'erroUser', value: msg);

      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      print(e.request);
      print(e.message);
    }
  }
  return null;
}

Future<Map> getResetPassword(params) async {
  Dio dio = new Dio();
  try {
    await dio.post('$URL_RESET_PASSWORD', data: params);

    storage.write(key: 'erroReset', value: "Sem erro");
  } on DioError catch (e) {
    if (e.response != null) {
      var msg = (e.response.data['error']);
      await storage.write(key: 'erroReset', value: msg);

      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      print(e.request);
      print(e.message);
    }
  }
  return null;
}
