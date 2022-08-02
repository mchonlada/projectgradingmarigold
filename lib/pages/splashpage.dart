import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

import 'package:projectgradingmarigold/pages/homepage.dart';


class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _TimerButton createState() => _TimerButton();
}

class _TimerButton extends State<SplashScreen> {
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 4;
  int currentSeconds = 0;

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      });
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg1.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}