import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kelompok_1/Screens/login.dart';
import '../constant/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 4),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: ((context) => const LoginScreen())),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              scale: 2.5,
            ),
            const CircularProgressIndicator(
              color: blueColor,
            ),
          ],
        ),
      ),
    );
  }
}
