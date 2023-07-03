import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static String splashScreenId = 'splash_screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1),
        () => Navigator.pushReplacementNamed(context, HomeScreen.homeScreenId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: const Color.fromRGBO(40, 43, 50, 1.0),
        child: Center(
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(69, 73, 84, 0.5), shape: BoxShape.circle),
            child: const Text(
              'ToBeHonest',
              style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
