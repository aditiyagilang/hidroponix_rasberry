import 'package:flutter/material.dart';
import 'package:hydroponx/login.dart';
import 'package:hydroponx/statusPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StatusPageScreen()),
      );
    });
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Opacity(
        opacity: 1,
        child: Image.asset(
          'assets/latar.png',
          fit: BoxFit.fitHeight,
          height: MediaQuery.of(context).size.height,
        ),
      ),
      Center(
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.fitHeight,
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Image.asset("assets/profider.png"),
        ),
      )
    ]));
  }
}
