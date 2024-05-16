import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thirdeyeapp/pages/loginpage.dart';
import 'package:thirdeyeapp/pages/signup.dart';
import 'package:thirdeyeapp/pages/spects.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage ()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFFdddcdb),
              child: Image.asset(
                'lib/images/Logo.png',
              ),
            )
          ],
        ),
      ),
    );
  }
}
