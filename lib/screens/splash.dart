import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movies_app/screens/home_screen.dart';
import 'package:movies_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigationWidget();
    super.initState();
  }

  _navigationWidget() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString('login');

    Timer(const Duration(seconds: 1), () {
      user != null
          ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }), (route) => false)
          : Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
              return Login();
            }), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.purple[50],
        child: const Center(
          child: CircularProgressIndicator(color: Colors.purple),
        ),
      ),
    );
  }
}
