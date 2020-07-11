import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task/pagesUser/loginUser.dart';
import 'mainPage.dart';
import 'package:connectivity/connectivity.dart';

final storage = new FlutterSecureStorage();

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String nameKey = "_key_name";
  var status;
  final int splashDuration = 1000;

  @override
  void initState() {
    super.initState();
    countDownTime();
  }

  countDownTime() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      status = await storage.read(key: 'nameKey');
      if (status == 'true') {
        return Timer(Duration(milliseconds: splashDuration), () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        });
      } else {
        return Timer(Duration(milliseconds: splashDuration), () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            fit: BoxFit.fill,
            width: 200.0,
          ),
          // new LogoImage(),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: CircularProgressIndicator(backgroundColor: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(child: Text("Aguardando conexão...")),
          )
        ],
      ),
    );
  }
}
