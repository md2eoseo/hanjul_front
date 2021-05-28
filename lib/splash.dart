import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hanjul_front/root_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    loadSplash();
    super.initState();
  }

  Future<Timer> loadSplash() async {
    return Timer(Duration(milliseconds: 600), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RootPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Icon(Icons.notes, size: 100),
              ),
              SizedBox(height: 10),
              Text(
                "한줄",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  letterSpacing: 1,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
