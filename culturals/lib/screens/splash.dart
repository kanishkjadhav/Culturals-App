import 'dart:io';
import 'package:culturals/screens/home.dart';
import 'package:culturals/screens/login.dart';
import 'package:culturals/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:convert';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

//  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    startTimer();
//    firebaseCloudMessagingSetup();
  }

  startTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 1), () {
      if (prefs.getBool('onboarded') == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoardingScreen()));
      } else if (prefs.getString('profile') == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Map profile = jsonDecode(prefs.getString('profile'));
        if (profile["name"] == "") {
          prefs.remove('profile');
          prefs.remove('username');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(profile: profile)));
        }
      }
    });
  }

//  firebaseCloudMessagingSetup() {
//    if (Platform.isIOS) iOSPermission();
//
//    _firebaseMessaging.getToken().then((token){
//      print(token);
//    });
//
//    _firebaseMessaging.subscribeToTopic('flutter');
//
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print('on message $message');
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('on resume $message');
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print('on launch $message');
//      },
//    );
//  }

//  void iOSPermission() {
//    _firebaseMessaging.requestNotificationPermissions(
//        IosNotificationSettings(sound: true, badge: true, alert: true)
//    );
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings)
//    {
//      print("Settings registered: $settings");
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo_icc.png',
          height: 200.0,
          width: 200.0,
        ),
      ),
    );
  }
}