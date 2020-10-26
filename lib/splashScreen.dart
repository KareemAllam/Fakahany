import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fakahany/Get_Location.dart';
import 'package:fakahany/HomeScreen.dart';
import 'package:fakahany/SecondSplash.dart';
import 'package:fakahany/login/signup.dart';
import 'package:fakahany/login/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fakahany/global/Colors.dart' as myColors;
import 'dart:math';
import 'package:fakahany/search.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  @override
  Future<void> initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => SignUp())));

    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: 200).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: animation.value,
              width: animation.value,
              child: SizedBox(
                  width: 170,
                  height: 170,
                  child: SvgPicture.asset('assets/images/logofinal.svg')),
            ),
          ],
        ),
      ),
    );
  }
}
